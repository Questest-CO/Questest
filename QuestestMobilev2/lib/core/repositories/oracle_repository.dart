import 'package:dio/dio.dart';
import '../errors/app_exception.dart';
import '../models/oracle/category_model.dart';
import '../models/oracle/questionnaire_model.dart';
import '../models/oracle/oracle_user_dto.dart';
import '../network/oracle/oracle_api_client.dart';

/// Repository for Oracle DB API data operations
/// Provides a clean interface between the domain layer and data layer
/// Handles error transformation and data mapping
class OracleRepository {
  final OracleApiClient _apiClient;

  OracleRepository(this._apiClient);

  // ============ CATEGORIES ============

  /// Fetches all categories from Oracle DB
  /// Returns [List<CategoryModel>] on success
  /// Throws [AppException] on failure
  Future<List<CategoryModel>> getCategories() async {
    try {
      return await _apiClient.getCategories();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ============ QUESTIONNAIRES ============

  /// Fetches all questionnaires from Oracle DB
  /// Returns [List<QuestionnaireModel>] on success
  /// Throws [AppException] on failure
  Future<List<QuestionnaireModel>> getQuestionnaires() async {
    try {
      return await _apiClient.getQuestionnaires();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetches a questionnaire by its ID
  /// [id] - The questionnaire ID
  /// Returns [QuestionnaireModel] on success
  /// Throws [AppException] on failure
  Future<QuestionnaireModel> getQuestionnaireById(int id) async {
    try {
      return await _apiClient.getQuestionnaireById(id);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetches all questionnaires created by a specific user
  /// [userId] - The user ID
  /// Returns [List<QuestionnaireModel>] on success
  /// Throws [AppException] on failure
  Future<List<QuestionnaireModel>> getQuestionnairesByUserId(int userId) async {
    try {
      return await _apiClient.getQuestionnairesByUserId(userId);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ============ USERS ============

  /// Fetches all users from Oracle DB
  /// Returns [List<OracleUserDto>] on success
  /// Throws [AppException] on failure
  Future<List<OracleUserDto>> getUsers() async {
    try {
      return await _apiClient.getUsers();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetches a user by their ID
  /// [id] - The user ID
  /// Returns [OracleUserDto] on success
  /// Throws [AppException] on failure
  Future<OracleUserDto> getUserById(int id) async {
    try {
      return await _apiClient.getUserById(id);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ============ ERROR HANDLING ============

  /// Transforms DioException errors into AppException
  /// If the error already contains an AppException, it's returned directly
  AppException _handleError(DioException e) {
    // Check if error was already transformed by interceptor
    if (e.error is AppException) {
      return e.error as AppException;
    }

    // Fallback error handling
    return NetworkException(
      message: e.message ?? 'An unexpected network error occurred.',
      code: 'NETWORK_ERROR',
      details: e.toString(),
    );
  }
}

