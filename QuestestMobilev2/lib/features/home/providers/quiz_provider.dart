import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/quiz_model.dart';
import '../../../core/providers/dio_provider.dart';

/// Provider for fetching quizzes
final quizzesProvider = FutureProvider<List<QuizModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  return await apiClient.getQuizzes();
});

/// Provider for a single quiz by ID
final quizByIdProvider = FutureProvider.family<QuizModel, String>((ref, id) async {
  final apiClient = ref.watch(apiClientProvider);
  return await apiClient.getQuizById(id);
});

