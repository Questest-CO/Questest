import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'oracle_api_client.g.dart';

/// REST API client for Oracle DB
/// Uses Retrofit for type-safe API calls
@RestApi()
abstract class OracleApiClient {
  factory OracleApiClient(Dio dio, {String? baseUrl}) = _OracleApiClient;

  // ============ CATEGORIES ============

  /// Get all categories
  /// Returns Oracle ORDS response wrapper (Map) - items will be extracted in repository
  @GET('/categories')
  Future<dynamic> getCategories();

  // ============ QUESTIONNAIRES ============

  /// Get all questionnaires
  /// Returns Oracle ORDS response wrapper (Map) - items will be extracted in repository
  @GET('/questionnaires/')
  Future<dynamic> getQuestionnaires();

  /// Get questionnaire by ID
  /// Returns Oracle ORDS response wrapper (Map) - items[0] will be extracted in repository
  @GET('/questionnaires/{id}')
  Future<dynamic> getQuestionnaireById(@Path('id') int id);

  /// Get questionnaires by user ID
  /// Returns Oracle ORDS response wrapper (Map) - items will be extracted in repository
  @GET('/questionnaires/user/{userId}')
  Future<dynamic> getQuestionnairesByUserId(
    @Path('userId') int userId,
  );

  /// Create a new questionnaire
  /// Returns Oracle ORDS response wrapper (Map) - items[0] will be extracted in repository
  @POST('/questionnaires/')
  Future<dynamic> createQuestionnaire(@Body() Map<String, dynamic> body);

  // ============ USERS ============

  /// Get all users
  /// Returns Oracle ORDS response wrapper (Map) - items will be extracted in repository
  @GET('/users/')
  Future<dynamic> getUsers();

  /// Get user by ID
  /// Returns Oracle ORDS response wrapper (Map) - items[0] will be extracted in repository
  @GET('/users/{id}')
  Future<dynamic> getUserById(@Path('id') int id);

  // ============ FILLED QUESTIONNAIRES ============

  /// Get all filled questionnaires (history)
  /// Returns Oracle ORDS response wrapper (Map) - items will be extracted in repository
  @GET('/questionnaires_filled/')
  Future<dynamic> getFilledQuestionnaires();

  /// Get filled questionnaires by quiz ID
  /// Returns Oracle ORDS response wrapper (Map) - items will be extracted in repository
  @GET('/questionnaires_filled/{quest_id}')
  Future<dynamic> getFilledQuestionnairesByQuizId(
    @Path('quest_id') int questId,
  );

  /// Submit a new filled questionnaire result
  /// Returns Oracle ORDS response wrapper (Map) - items[0] will be extracted in repository
  @POST('/questionnaires_filled/')
  Future<dynamic> submitFilledQuestionnaire(
    @Body() Map<String, dynamic> body,
  );
}

