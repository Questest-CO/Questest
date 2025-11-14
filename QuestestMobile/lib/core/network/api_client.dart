import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/quiz_model.dart';
import '../models/user_model.dart';
import '../models/auth_response.dart';

part 'api_client.g.dart';

/// REST API client for Questest
/// Uses Retrofit for type-safe API calls
@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  /// Get list of quizzes
  @GET('/quizzes')
  Future<List<QuizModel>> getQuizzes();

  /// Get quiz by ID
  @GET('/quizzes/{id}')
  Future<QuizModel> getQuizById(@Path('id') String id);

  /// Get user profile
  @GET('/users/{id}')
  Future<UserModel> getUserById(@Path('id') String id);

  /// Login
  @POST('/auth/login')
  Future<AuthResponse> login(@Body() Map<String, dynamic> credentials);
}

