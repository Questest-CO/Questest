import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/quiz_model.dart';
import '../../../core/models/oracle/questionnaire_model.dart';
import '../../../core/providers/oracle_providers.dart';

/// Current user ID for Oracle DB
/// TODO: This should be mapped from Firebase UID to Oracle user ID
/// For now using hardcoded value for testing
final currentUserIdProvider = StateProvider<int>((ref) => 1);

/// Provider for fetching quizzes from Oracle API
final quizzesProvider = FutureProvider<List<QuizModel>>((ref) async {
  final oracleRepository = ref.watch(oracleRepositoryProvider);
  return await oracleRepository.getQuestionnaires();
});

/// Provider for fetching current user's quizzes
final myQuizzesProvider = FutureProvider<List<QuizModel>>((ref) async {
  final oracleRepository = ref.watch(oracleRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  final questionnaires = await oracleRepository.getQuestionnairesByUserId(userId);
  
  // Convert QuestionnaireModel list to QuizModel list
  return questionnaires.map((q) => _questionnaireToQuizModel(q)).toList();
});

/// Helper function to convert QuestionnaireModel to QuizModel
QuizModel _questionnaireToQuizModel(QuestionnaireModel questionnaire) {
  final random = Random();
  final imageId = random.nextInt(1000);
  final thumbnailUrl = 'https://images.unsplash.com/photo-${1500000000000 + imageId}?w=800';
  
  return QuizModel(
    id: questionnaire.id.toString(),
    title: questionnaire.title ?? '',
    subtitle: 'Quiz ID: ${questionnaire.id}',
    thumbnailUrl: thumbnailUrl,
    questionCount: questionnaire.questionCount ?? 0,
    participantsCount: 0,
    description: questionnaire.description,
    category: questionnaire.categoryId?.toString(),
  );
}

/// Provider for a single quiz by ID from Oracle API
final quizByIdProvider = FutureProvider.family<QuizModel, String>((ref, id) async {
  final oracleRepository = ref.watch(oracleRepositoryProvider);
  // Note: Oracle API uses int IDs, so we need to parse the string ID
  final quizId = int.tryParse(id);
  if (quizId == null) {
    throw Exception('Invalid quiz ID: $id');
  }
  final questionnaire = await oracleRepository.getQuestionnaireById(quizId);
  // Convert QuestionnaireModel to QuizModel for compatibility
  return _questionnaireToQuizModel(questionnaire);
});

