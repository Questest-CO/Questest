import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../errors/app_exception.dart';

/// Dio client configuration for Oracle DB API
/// Provides a configured Dio instance with interceptors and error handling
class OracleDioClient {
  /// Oracle DB API Base URL
  static const String baseUrl =
      'https://gd3ae4848c58cfd-wcd7t5vwyerz06lb.adb.eu-frankfurt-1.oraclecloudapps.com/ords/admin/api';

  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  late final Dio dio;

  OracleDioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: connectTimeout),
        receiveTimeout: const Duration(milliseconds: receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(_createLoggingInterceptor());
    dio.interceptors.add(_createErrorInterceptor());
  }

  /// Logging interceptor to log requests and responses
  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.i(
          '🌐 ORACLE REQUEST[${options.method}] => PATH: ${options.path}\n'
          'Headers: ${options.headers}\n'
          'Query: ${options.queryParameters}\n'
          'Body: ${options.data}',
        );
        handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i(
          '✅ ORACLE RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}\n'
          'Data: ${response.data}',
        );
        handler.next(response);
      },
      onError: (error, handler) {
        _logger.e(
          '❌ ORACLE ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}\n'
          'Message: ${error.message}\n'
          'Data: ${error.response?.data}',
        );
        handler.next(error);
      },
    );
  }

  /// Error interceptor to transform Dio errors into app exceptions
  Interceptor _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        final exception = _mapDioErrorToAppException(error);
        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: exception,
            response: error.response,
            type: error.type,
          ),
        );
      },
    );
  }

  /// Maps Dio errors to application-specific exceptions
  AppException _mapDioErrorToAppException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
          code: 'TIMEOUT',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'No internet connection. Please check your network.',
          code: 'NO_CONNECTION',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return const NetworkException(
          message: 'Request was cancelled.',
          code: 'CANCELLED',
        );

      default:
        return NetworkException(
          message: error.message ?? 'An unexpected error occurred.',
          code: 'UNKNOWN',
          details: error.toString(),
        );
    }
  }

  /// Handles bad response errors (4xx, 5xx)
  AppException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    switch (statusCode) {
      case 400:
        return ServerException(
          message: _extractErrorMessage(data) ?? 'Bad request.',
          statusCode: statusCode,
          code: 'BAD_REQUEST',
        );

      case 401:
        return const AuthException(
          message: 'Unauthorized. Please login again.',
          code: 'UNAUTHORIZED',
        );

      case 403:
        return const AuthException(
          message: 'Access forbidden.',
          code: 'FORBIDDEN',
        );

      case 404:
        return NotFoundException(
          message: _extractErrorMessage(data) ?? 'Resource not found.',
          code: 'NOT_FOUND',
        );

      case 500:
      case 502:
      case 503:
        return ServerException(
          message: 'Server error. Please try again later.',
          statusCode: statusCode,
          code: 'SERVER_ERROR',
        );

      default:
        return ServerException(
          message: _extractErrorMessage(data) ?? 'An error occurred.',
          statusCode: statusCode,
          code: 'HTTP_ERROR',
        );
    }
  }

  /// Extracts error message from response data
  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      // Try common error message fields
      return data['message'] as String? ??
          data['error'] as String? ??
          data['error_message'] as String? ??
          data['detail'] as String?;
    }

    if (data is String) {
      return data;
    }

    return null;
  }
}

