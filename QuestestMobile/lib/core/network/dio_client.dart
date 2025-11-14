import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Dio client configuration
/// Provides a configured Dio instance with interceptors and error handling
class DioClient {
  // Dla emulatora Android użyj 10.0.2.2 zamiast localhost
  // Dla iOS emulatora i web użyj localhost
  // Dla fizycznego urządzenia użyj IP komputera (np. 192.168.1.100)
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    if (Platform.isAndroid) {
      // Emulator Android używa 10.0.2.2 do dostępu do localhost hosta
      return 'http://10.0.2.2:3000';
    }
    // iOS emulator i inne platformy
    return 'http://localhost:3000';
  }
  
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

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: DioClient.baseUrl,
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
    dio.interceptors.add(_createAuthInterceptor());
  }

  /// Logging interceptor to log requests and responses
  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.i(
          'REQUEST[${options.method}] => PATH: ${options.path}\n'
          'Headers: ${options.headers}\n'
          'Body: ${options.data}',
        );
        handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i(
          'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}\n'
          'Data: ${response.data}',
        );
        handler.next(response);
      },
      onError: (error, handler) {
        _logger.e(
          'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}\n'
          'Message: ${error.message}\n'
          'Data: ${error.response?.data}',
        );
        handler.next(error);
      },
    );
  }

  /// Auth interceptor to add authentication token to requests
  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        // TODO: Get token from secure storage
        // For now, we'll add it when available
        // final token = 'your_token_here';
        // options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    );
  }
}

