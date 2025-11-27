import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/oracle/category_model.dart';
import '../../models/oracle/questionnaire_model.dart';
import '../../models/oracle/oracle_user_dto.dart';

part 'oracle_api_client.g.dart';

/// REST API client for Oracle DB
/// Uses Retrofit for type-safe API calls
@RestApi()
abstract class OracleApiClient {
  factory OracleApiClient(Dio dio, {String? baseUrl}) = _OracleApiClient;

  // ============ CATEGORIES ============

  /// Get all categories
  @GET('/categories')
  Future<List<CategoryModel>> getCategories();

  // ============ QUESTIONNAIRES ============

  /// Get all questionnaires
  @GET('/questionnaires/')
  Future<List<QuestionnaireModel>> getQuestionnaires();

  /// Get questionnaire by ID
  @GET('/questionnaires/{id}')
  Future<QuestionnaireModel> getQuestionnaireById(@Path('id') int id);

  /// Get questionnaires by user ID
  @GET('/questionnaires/user/{userId}')
  Future<List<QuestionnaireModel>> getQuestionnairesByUserId(
    @Path('userId') int userId,
  );

  // ============ USERS ============

  /// Get all users
  @GET('/users/')
  Future<List<OracleUserDto>> getUsers();

  /// Get user by ID
  @GET('/users/{id}')
  Future<OracleUserDto> getUserById(@Path('id') int id);
}

