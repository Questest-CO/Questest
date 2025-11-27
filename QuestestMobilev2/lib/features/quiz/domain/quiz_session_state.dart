import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/quiz_question.dart';

part 'quiz_session_state.freezed.dart';

/// Quiz session status enum
enum QuizStatus {
  /// Initial state before quiz starts
  initial,

  /// Quiz is actively running with timer
  inProgress,

  /// Quiz is paused (e.g., app backgrounded)
  paused,

  /// Quiz has been completed (time ran out or all questions answered)
  completed,
}

/// Immutable state for quiz session
/// Holds all data needed for quiz gameplay
@freezed
class QuizSessionState with _$QuizSessionState {
  const QuizSessionState._();

  const factory QuizSessionState({
    /// List of questions in this quiz session
    required List<QuizQuestion> questions,

    /// Current question index (0-based)
    required int currentQuestionIndex,

    /// Map of question ID to answer(s)
    /// - SingleChoice: int (selected option ID)
    /// - MultipleChoice: Set<int> (selected option IDs)
    /// - OpenText: String (user's text answer)
    required Map<int, dynamic> answers,

    /// Remaining time in seconds
    required int remainingSeconds,

    /// Current quiz status
    required QuizStatus status,
  }) = _QuizSessionState;

  /// Factory for creating initial state
  factory QuizSessionState.initial({
    required List<QuizQuestion> questions,
    required int timeLimitSeconds,
  }) {
    return QuizSessionState(
      questions: questions,
      currentQuestionIndex: 0,
      answers: {},
      remainingSeconds: timeLimitSeconds,
      status: QuizStatus.initial,
    );
  }

  // ============ COMPUTED PROPERTIES ============

  /// Get current question
  QuizQuestion get currentQuestion => questions[currentQuestionIndex];

  /// Check if on last question
  bool get isLastQuestion => currentQuestionIndex >= questions.length - 1;

  /// Get total number of questions
  int get totalQuestions => questions.length;

  /// Get current question number (1-based for display)
  int get currentQuestionNumber => currentQuestionIndex + 1;

  /// Calculate progress (0.0 to 1.0)
  double get progress => (currentQuestionIndex + 1) / totalQuestions;

  /// Format remaining time as MM:SS
  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Check if time is running low (under 1 minute)
  bool get isTimeWarning => remainingSeconds <= 60;

  /// Check if current question has been answered
  bool get hasCurrentAnswer {
    final answer = answers[currentQuestion.id];
    if (answer == null) return false;

    switch (currentQuestion.type) {
      case QuestionType.singleChoice:
        return true; // If answer exists, it's valid
      case QuestionType.multipleChoice:
        return (answer as Set<int>).isNotEmpty;
      case QuestionType.openText:
        return (answer as String).trim().isNotEmpty;
    }
  }

  /// Count total answered questions
  int get answeredCount {
    int count = 0;
    for (final question in questions) {
      final answer = answers[question.id];
      if (answer == null) continue;

      switch (question.type) {
        case QuestionType.singleChoice:
          count++;
          break;
        case QuestionType.multipleChoice:
          if ((answer as Set<int>).isNotEmpty) count++;
          break;
        case QuestionType.openText:
          if ((answer as String).trim().isNotEmpty) count++;
          break;
      }
    }
    return count;
  }

  // ============ TYPE-SAFE ANSWER GETTERS ============

  /// Get single choice answer for a question
  int? getSingleChoiceAnswer(int questionId) {
    final answer = answers[questionId];
    return answer as int?;
  }

  /// Get multiple choice answers for a question
  Set<int> getMultipleChoiceAnswers(int questionId) {
    final answer = answers[questionId];
    return (answer as Set<int>?) ?? <int>{};
  }

  /// Get open text answer for a question
  String getOpenTextAnswer(int questionId) {
    final answer = answers[questionId];
    return (answer as String?) ?? '';
  }
}

