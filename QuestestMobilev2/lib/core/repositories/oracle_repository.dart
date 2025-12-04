import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import '../errors/app_exception.dart';
import '../models/oracle/category_model.dart';
import '../models/oracle/questionnaire_model.dart';
import '../models/oracle/oracle_user_dto.dart';
import '../models/oracle/questionnaire_detail_model.dart';
import '../models/quiz_model.dart';
import '../network/oracle/oracle_api_client.dart';
import '../../features/creator/presentation/providers/creator_providers.dart';

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
      final response = await _apiClient.getCategories();
      // Extract items from Oracle ORDS response wrapper
      final items = response['items'] as List<dynamic>? ?? [];
      return items
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ============ QUESTIONNAIRES ============

  /// Fetches all questionnaires from Oracle DB and maps them to QuizModel
  /// Returns [List<QuizModel>] on success
  /// Throws [AppException] on failure
  /// Maps Oracle data (id: int, title: string, category: int) to QuizModel
  /// Generates random Unsplash images and maps category_id to category string
  Future<List<QuizModel>> getQuestionnaires() async {
    try {
      final response = await _apiClient.getQuestionnaires();
      // Extract items from Oracle ORDS response wrapper
      final items = response['items'] as List<dynamic>? ?? [];
      
      if (items.isEmpty) {
        return [];
      }

      return items.map((e) {
        final data = e as Map<String, dynamic>;
        final id = data['id'] as int? ?? 0;
        final title = data['title'] as String? ?? '';
        final categoryId = data['category'] as int?;
        final createdBy = data['created_by'] as int?;
        
        // Generate random Unsplash image URL
        final random = Random();
        final imageId = random.nextInt(1000);
        final thumbnailUrl = 'https://images.unsplash.com/photo-${1500000000000 + imageId}?w=800';
        
        // Map category_id to category string (you can customize this mapping)
        String? categoryString;
        if (categoryId != null) {
          categoryString = _mapCategoryIdToString(categoryId);
        }
        
        return QuizModel(
          id: id.toString(),
          title: title,
          subtitle: createdBy != null ? 'Autor ID: $createdBy' : 'Brak autora',
          thumbnailUrl: thumbnailUrl,
          questionCount: data['question_count'] as int? ?? 0,
          participantsCount: 0, // Not available in API response
          description: data['description'] as String?,
          category: categoryString,
        );
      }).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetches a questionnaire by its ID
  /// [id] - The questionnaire ID
  /// Returns [QuestionnaireModel] on success
  /// Throws [AppException] on failure
  /// Extracts first item from Oracle ORDS wrapper
  Future<QuestionnaireModel> getQuestionnaireById(int id) async {
    try {
      final response = await _apiClient.getQuestionnaireById(id);
      // Extract first item from Oracle ORDS response wrapper
      final items = response['items'] as List<dynamic>? ?? [];
      if (items.isEmpty) {
        throw NotFoundException(
          message: 'Questionnaire with id $id not found',
          code: 'NOT_FOUND',
        );
      }
      return QuestionnaireModel.fromJson(items[0] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetches questionnaire details (with questions and options) by ID
  /// [id] - The questionnaire ID
  /// Returns [QuestionnaireDetailModel] on success
  /// Throws [AppException] on failure
  /// Handles double-encoded JSON: extracts questionnaire_json string and parses it
  Future<QuestionnaireDetailModel> getQuestionnaireDetails(int id) async {
    try {
      final response = await _apiClient.getQuestionnaireById(id);
      // Extract first item from Oracle ORDS response wrapper
      final items = response['items'] as List<dynamic>? ?? [];
      if (items.isEmpty) {
        throw NotFoundException(
          message: 'Questionnaire with id $id not found',
          code: 'NOT_FOUND',
        );
      }
      
      final data = items[0] as Map<String, dynamic>;
      final questionnaireJsonString = data['questionnaire_json'] as String?;
      
      if (questionnaireJsonString == null || questionnaireJsonString.isEmpty) {
        throw ServerException(
          message: 'Questionnaire JSON data is missing',
          statusCode: 500,
          code: 'MISSING_DATA',
        );
      }
      
      // Parse the double-encoded JSON string
      return QuestionnaireDetailModel.fromJsonString(questionnaireJsonString);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      // Handle JSON parsing errors
      throw ServerException(
        message: 'Failed to parse questionnaire JSON: ${e.toString()}',
        statusCode: 500,
        code: 'PARSE_ERROR',
      );
    }
  }

  /// Fetches all questionnaires created by a specific user
  /// [userId] - The user ID
  /// Returns [List<QuestionnaireModel>] on success
  /// Throws [AppException] on failure
  Future<List<QuestionnaireModel>> getQuestionnairesByUserId(int userId) async {
    try {
      final response = await _apiClient.getQuestionnairesByUserId(userId);
      // Extract items from Oracle ORDS response wrapper
      final items = response['items'] as List<dynamic>? ?? [];
      return items
          .map((e) => QuestionnaireModel.fromJson(e as Map<String, dynamic>))
          .toList();
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
      final response = await _apiClient.getUsers();
      // Extract items from Oracle ORDS response wrapper
      final items = response['items'] as List<dynamic>? ?? [];
      return items
          .map((e) => OracleUserDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetches a user by their ID
  /// [id] - The user ID
  /// Returns [OracleUserDto] on success
  /// Throws [AppException] on failure
  /// Extracts first item from Oracle ORDS wrapper
  Future<OracleUserDto> getUserById(int id) async {
    try {
      final response = await _apiClient.getUserById(id);
      // Extract first item from Oracle ORDS response wrapper
      final items = response['items'] as List<dynamic>? ?? [];
      if (items.isEmpty) {
        throw NotFoundException(
          message: 'User with id $id not found',
          code: 'NOT_FOUND',
        );
      }
      return OracleUserDto.fromJson(items[0] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Creates a new questionnaire
  /// [title] - Questionnaire title
  /// [description] - Questionnaire description
  /// [categoryId] - Category ID
  /// [userId] - User ID (created_by)
  /// [questions] - List of questions with options
  /// Returns [QuestionnaireModel] on success
  /// Throws [AppException] on failure
  Future<QuestionnaireModel> createQuestionnaire({
    required String title,
    required String description,
    required int categoryId,
    required int userId,
    required List<QuestionDraft> questions,
    String isPrivate = 'N',
  }) async {
    try {
      // Build questionnaire_json structure
      final questionnaireJson = {
        'id': 0, // Will be assigned by backend
        'title': title,
        'questions': questions.asMap().entries.map((entry) {
          final questionIndex = entry.key;
          final question = entry.value;
          return {
            'id': 0, // Will be assigned by backend
            'content': question.content,
            'options': question.answers.asMap().entries.map((optEntry) {
              final optIndex = optEntry.key;
              final optContent = optEntry.value;
              return {
                'id': 0, // Will be assigned by backend
                'content': optContent,
                'is_correct': optIndex == question.correctAnswerIndex,
              };
            }).where((opt) => opt['content'].toString().trim().isNotEmpty).toList(),
          };
        }).toList(),
      };

      // Build request body
      // Note: Keys must match Oracle PL/SQL procedure parameter names
      // The procedure does NOT accept 'description' parameter
      // The procedure expects 'id' parameter (null for new records)
      final body = {
        'id': null, // Required by Oracle procedure, null for new records
        'title': title,
        'category': categoryId, // Changed from 'category_id' to match DB schema
        'created_by': userId,
        'private': isPrivate, // Changed from 'is_private' to match DB schema
        'questionnaire_json': jsonEncode(questionnaireJson),
      };

      final response = await _apiClient.createQuestionnaire(body);
      
      // Extract first item from Oracle ORDS response wrapper
      final items = response['items'] as List<dynamic>? ?? [];
      if (items.isEmpty) {
        throw ServerException(
          message: 'Failed to create questionnaire: empty response',
          statusCode: 500,
          code: 'CREATE_ERROR',
        );
      }
      
      return QuestionnaireModel.fromJson(items[0] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw ServerException(
        message: 'Failed to create questionnaire: ${e.toString()}',
        statusCode: 500,
        code: 'CREATE_ERROR',
      );
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

  // ============ HELPER METHODS ============

  /// Maps category ID to category string
  /// You can customize this mapping based on your category data
  String? _mapCategoryIdToString(int categoryId) {
    // Default mapping - you can enhance this by fetching categories
    switch (categoryId) {
      case 1:
        return 'quiz';
      case 2:
        return 'exam';
      default:
        return 'quiz'; // Default fallback
    }
  }
}

