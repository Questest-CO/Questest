import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/quiz_session_state.dart';
import '../models/quiz_question.dart';
import '../../../core/utils/app_constants.dart';

part 'quiz_controller.g.dart';

/// Controller for managing quiz session state and logic
/// Handles timer, answer selection, and navigation between questions
@riverpod
class QuizController extends _$QuizController {
  Timer? _timer;

  @override
  QuizSessionState build() {
    // Setup timer cleanup on dispose
    ref.onDispose(() {
      _timer?.cancel();
      debugPrint('🧹 QuizController disposed - timer cancelled');
    });

    // Start empty; real questions loaded via loadQuestions()
    return QuizSessionState.initial(
      questions: const [],
      timeLimitSeconds: AppConstants.defaultQuizTimeLimit,
    );
  }

  // ============ QUIZ LIFECYCLE ============

  /// Starts the quiz session and begins the timer
  void startQuiz() {
    if (state.status == QuizStatus.inProgress) return;
    if (state.questions.isEmpty) return;

    state = state.copyWith(status: QuizStatus.inProgress);
    _startTimer();

    debugPrint('🎮 Quiz started! Time: ${state.formattedTime}');
  }

  /// Pauses the quiz (stops timer but preserves state)
  void pauseQuiz() {
    if (state.status != QuizStatus.inProgress) return;

    _timer?.cancel();
    state = state.copyWith(status: QuizStatus.paused);

    debugPrint('⏸️ Quiz paused');
  }

  /// Resumes a paused quiz
  void resumeQuiz() {
    if (state.status != QuizStatus.paused) return;

    state = state.copyWith(status: QuizStatus.inProgress);
    _startTimer();

    debugPrint('▶️ Quiz resumed');
  }

  /// Finishes the quiz (either completed or time ran out)
  void finishQuiz() {
    _timer?.cancel();
    state = state.copyWith(status: QuizStatus.completed);

    debugPrint('🏁 Quiz completed!');
    debugPrint('   Answered: ${state.answeredCount}/${state.totalQuestions}');
    debugPrint('   Time remaining: ${state.formattedTime}');
  }

  /// Replace current questions/time with data from backend.
  void loadQuestions(List<QuizQuestion> questions, int? timeLimitSeconds) {
    final limit = timeLimitSeconds ?? AppConstants.defaultQuizTimeLimit;
    debugPrint('🎯 Loading questions from backend: ${questions.length} items, limit=$limit');
    state = QuizSessionState.initial(
      questions: questions,
      timeLimitSeconds: limit,
    );
    debugPrint('🎯 State after load: ${state.questions.length} items');
  }

  // ============ TIMER ============

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (state.status != QuizStatus.inProgress) return;

    final newTime = state.remainingSeconds - 1;

    if (newTime <= 0) {
      // Time's up!
      state = state.copyWith(remainingSeconds: 0);
      finishQuiz();
      debugPrint('⏰ Time\'s up!');
    } else {
      state = state.copyWith(remainingSeconds: newTime);
    }
  }

  // ============ ANSWER HANDLING ============

  /// Select an answer for single choice question
  /// Replaces any previous selection
  void selectAnswer(int questionId, int answerId) {
    final newAnswers = Map<int, dynamic>.from(state.answers);
    newAnswers[questionId] = answerId;

    state = state.copyWith(answers: newAnswers);

    debugPrint('📝 SingleChoice Q$questionId: selected option $answerId');
  }

  /// Toggle an answer for multiple choice question
  /// Adds or removes the option from selection
  void toggleAnswer(int questionId, int answerId) {
    final newAnswers = Map<int, dynamic>.from(state.answers);
    final currentSet =
        Set<int>.from((newAnswers[questionId] as Set<int>?) ?? <int>{});

    if (currentSet.contains(answerId)) {
      currentSet.remove(answerId);
    } else {
      currentSet.add(answerId);
    }

    newAnswers[questionId] = currentSet;
    state = state.copyWith(answers: newAnswers);

    debugPrint(
        '📝 MultipleChoice Q$questionId: toggled option $answerId → $currentSet');
  }

  /// Submit open text answer
  void submitOpenAnswer(int questionId, String text) {
    final newAnswers = Map<int, dynamic>.from(state.answers);
    newAnswers[questionId] = text;

    state = state.copyWith(answers: newAnswers);

    debugPrint(
        '📝 OpenText Q$questionId: "${text.substring(0, text.length.clamp(0, 30))}..."');
  }

  // ============ NAVIGATION ============

  /// Move to the next question or finish if on last
  void nextQuestion() {
    if (state.isLastQuestion) {
      finishQuiz();
    } else {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
      );
      debugPrint(
          '➡️ Next question: ${state.currentQuestionNumber}/${state.totalQuestions}');
    }
  }

  /// Move to the previous question (if not on first)
  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
      );
      debugPrint(
          '⬅️ Previous question: ${state.currentQuestionNumber}/${state.totalQuestions}');
    }
  }

  /// Jump to a specific question by index
  void goToQuestion(int index) {
    if (index >= 0 && index < state.totalQuestions) {
      state = state.copyWith(currentQuestionIndex: index);
      debugPrint('🎯 Jump to question: ${index + 1}/${state.totalQuestions}');
    }
  }
}

