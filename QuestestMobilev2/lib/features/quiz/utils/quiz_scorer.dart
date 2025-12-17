import '../domain/quiz_session_state.dart';
import '../models/quiz_question.dart';

/// Result of quiz scoring calculation
class QuizScore {
  final int correctCount;
  final int totalQuestions;
  final double percentage;

  const QuizScore({
    required this.correctCount,
    required this.totalQuestions,
    required this.percentage,
  });
}

/// Utility class for calculating quiz scores
class QuizScorer {
  /// Calculate the score from a completed quiz session
  /// Returns QuizScore with correct count, total questions, and percentage
  static QuizScore calculateScore(QuizSessionState quizState) {
    if (quizState.questions.isEmpty) {
      return const QuizScore(
        correctCount: 0,
        totalQuestions: 0,
        percentage: 0.0,
      );
    }

    int correctCount = 0;
    final totalQuestions = quizState.questions.length;

    for (final question in quizState.questions) {
      final userAnswer = quizState.answers[question.id];
      
      // Skip if question wasn't answered
      if (userAnswer == null) {
        continue;
      }

      // Check correctness based on question type
      final isCorrect = _checkAnswerCorrectness(question, userAnswer);
      if (isCorrect) {
        correctCount++;
      }
    }

    final percentage = totalQuestions > 0
        ? (correctCount / totalQuestions) * 100
        : 0.0;

    return QuizScore(
      correctCount: correctCount,
      totalQuestions: totalQuestions,
      percentage: percentage,
    );
  }

  /// Check if a user's answer is correct for a given question
  static bool _checkAnswerCorrectness(QuizQuestion question, dynamic userAnswer) {
    switch (question.type) {
      case QuestionType.singleChoice:
        // For single choice, check if selected option ID is correct
        if (userAnswer is! int) return false;
        if (question.options == null) return false;
        
        try {
          final selectedOption = question.options!.firstWhere(
            (option) => option.id == userAnswer,
          );
          return selectedOption.isCorrect;
        } catch (e) {
          // Option not found, answer is incorrect
          return false;
        }

      case QuestionType.multipleChoice:
        // For multiple choice, check if selected set matches correct set exactly
        if (userAnswer is! Set<int>) return false;
        if (question.options == null) return false;

        // Get set of correct option IDs
        final correctOptionIds = question.options!
            .where((option) => option.isCorrect)
            .map((option) => option.id)
            .toSet();

        // Check if user's selection matches correct set exactly
        return userAnswer.length == correctOptionIds.length &&
            userAnswer.every((id) => correctOptionIds.contains(id));

      case QuestionType.openText:
        // Open text questions cannot be automatically scored
        // For now, we'll count them as incorrect
        // In the future, this could be handled by manual review or AI scoring
        return false;
    }
  }
}

