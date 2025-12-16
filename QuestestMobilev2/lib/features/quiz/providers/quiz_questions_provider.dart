import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/oracle/questionnaire_detail_model.dart';
import '../../../core/providers/oracle_providers.dart';
import '../models/quiz_question.dart';

/// Fetch questionnaire details from Oracle and map to QuizQuestion UI model.
final quizQuestionsProvider =
    FutureProvider.family<List<QuizQuestion>, String>((ref, quizId) async {
  final repository = ref.watch(oracleRepositoryProvider);
  final parsedId = int.tryParse(quizId);
  if (parsedId == null) {
    throw Exception('Invalid quiz id: $quizId');
  }

  final detail = await repository.getQuestionnaireDetails(parsedId);
  final questions = _mapDetailToQuestions(detail);
  // Debug info to console to help diagnose empty lists
  if (questions.isEmpty) {
    // ignore: avoid_print
    print('Quiz $quizId has no questions after mapping. Detail: $detail');
  } else {
    // ignore: avoid_print
    print('Quiz $quizId loaded ${questions.length} questions');
  }
  return questions;
});

List<QuizQuestion> _mapDetailToQuestions(QuestionnaireDetailModel detail) {
  return detail.questions.map((q) {
    // Heurystyka: jeśli jest tylko jedna poprawna odpowiedź -> singleChoice,
    // jeśli wiele oznaczonych jako correct -> multipleChoice,
    // jeśli brak opcji -> openText.
    final options = q.options;
    if (options.isEmpty) {
      return QuizQuestion(
        id: q.id,
        content: q.content,
        type: QuestionType.openText,
        options: null,
      );
    }

    final correctCount =
        options.where((o) => o.isCorrect == true).length;
    final type = correctCount > 1
        ? QuestionType.multipleChoice
        : QuestionType.singleChoice;

    return QuizQuestion(
      id: q.id,
      content: q.content,
      type: type,
      options: options
          .map((o) => AnswerOption(
                id: o.id,
                content: o.content,
              ))
          .toList(),
    );
  }).toList();
}

