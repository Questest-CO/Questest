import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/quiz_model.dart';
import '../../../core/providers/oracle_providers.dart';

/// Provider for fetching quizzes from Oracle API
final quizzesProvider = FutureProvider<List<QuizModel>>((ref) async {
  final oracleRepository = ref.watch(oracleRepositoryProvider);
  return await oracleRepository.getQuestionnaires();
});

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
  return QuizModel(
    id: questionnaire.id.toString(),
    title: questionnaire.title ?? '',
    subtitle: 'Quiz ID: ${questionnaire.id}',
    thumbnailUrl: 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=800',
    questionCount: questionnaire.questionCount ?? 0,
    participantsCount: 0,
    description: questionnaire.description,
    category: questionnaire.categoryId?.toString(),
  );
});

