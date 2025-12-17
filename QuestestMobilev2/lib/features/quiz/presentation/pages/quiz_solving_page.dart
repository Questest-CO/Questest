import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/quiz_session_state.dart';
import '../../models/quiz_question.dart';
import '../../providers/quiz_controller.dart';
import '../../providers/quiz_questions_provider.dart';
import '../../utils/quiz_scorer.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_progress_header.dart';
import '../widgets/single_choice_answer.dart';
import '../widgets/multiple_choice_answer.dart';
import '../widgets/open_text_answer.dart';
import 'quiz_result_page.dart';

/// Main quiz solving screen
/// Displays questions and handles user answers
/// Uses Riverpod for state management
class QuizSolvingPage extends ConsumerStatefulWidget {
  const QuizSolvingPage({
    super.key,
    required this.quizId,
    this.quizTitle,
    this.timeLimitSeconds,
  });

  /// Quiz ID from backend (string from QuizModel)
  final String quizId;

  /// Optional quiz title to show in AppBar
  final String? quizTitle;

  /// Optional custom time limit; falls back to AppConstants.defaultQuizTimeLimit
  final int? timeLimitSeconds;

  @override
  ConsumerState<QuizSolvingPage> createState() => _QuizSolvingPageState();
}

class _QuizSolvingPageState extends ConsumerState<QuizSolvingPage> {
  bool _initialized = false;
  bool _loadingQuestions = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quizState = ref.watch(quizControllerProvider);
    final questionsAsync = ref.watch(quizQuestionsProvider(widget.quizId));

    ref.listen<AsyncValue<List<QuizQuestion>>>(
      quizQuestionsProvider(widget.quizId),
      (previous, next) {
        next.when(
          data: (questions) {
            if (!mounted) return;
            if (questions.isNotEmpty && !_initialized) {
              debugPrint(
                  '📥 quizQuestionsProvider delivered ${questions.length} questions for quizId=${widget.quizId}');
              ref
                  .read(quizControllerProvider.notifier)
                  .loadQuestions(questions, widget.timeLimitSeconds);
              ref.read(quizControllerProvider.notifier).startQuiz();
              setState(() {
                _initialized = true;
                _loadingQuestions = false;
              });
            } else if (questions.isEmpty) {
              setState(() {
                _loadingQuestions = false;
              });
            }
          },
          error: (_, __) {
            if (!mounted) return;
            setState(() {
              _loadingQuestions = false;
            });
          },
          loading: () {},
        );
      },
    );

    // Loading / error states for questions fetch
    if (_loadingQuestions) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questionsAsync.hasError) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.quizTitle ?? 'Quiz')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                'Nie udało się pobrać pytań.',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text('${questionsAsync.error}'),
            ],
          ),
        ),
      );
    }

    if (quizState.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.quizTitle ?? 'Quiz')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.help_outline, size: 48),
              const SizedBox(height: 12),
              Text(
                'Brak pytań w tym quizie.',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }

    // Handle completed state - navigate to result screen
    if (quizState.status == QuizStatus.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToResult(quizState);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizTitle ?? MockQuizData.quizTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitConfirmation(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: QuizTimer(
              timerText: quizState.formattedTime,
              isWarning: quizState.isTimeWarning,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress header
            QuizProgressHeader(
              currentQuestion: quizState.currentQuestionNumber,
              totalQuestions: quizState.totalQuestions,
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question card
                    QuestionCard(
                      question: quizState.currentQuestion,
                      questionNumber: quizState.currentQuestionNumber,
                      totalQuestions: quizState.totalQuestions,
                    ),
                    const SizedBox(height: 24),

                    // Answer section title
                    Text(
                      'Twoja odpowiedź',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Answer widget based on question type
                    _buildAnswerWidget(quizState),
                  ],
                ),
              ),
            ),

            // Bottom action bar
            _buildBottomBar(theme, quizState),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerWidget(QuizSessionState quizState) {
    if (quizState.questions.isEmpty) {
      return const SizedBox.shrink();
    }
    final question = quizState.currentQuestion;
    final controller = ref.read(quizControllerProvider.notifier);

    switch (question.type) {
      case QuestionType.singleChoice:
        return SingleChoiceAnswer(
          options: question.options!,
          selectedOptionId: quizState.getSingleChoiceAnswer(question.id),
          onOptionSelected: (optionId) {
            controller.selectAnswer(question.id, optionId);
          },
        );

      case QuestionType.multipleChoice:
        return MultipleChoiceAnswer(
          options: question.options!,
          selectedOptionIds: quizState.getMultipleChoiceAnswers(question.id),
          onOptionToggled: (optionId) {
            controller.toggleAnswer(question.id, optionId);
          },
        );

      case QuestionType.openText:
        return OpenTextAnswer(
          value: quizState.getOpenTextAnswer(question.id),
          onChanged: (text) {
            controller.submitOpenAnswer(question.id, text);
          },
          hint: question.hint,
        );
    }
  }

  Widget _buildBottomBar(ThemeData theme, QuizSessionState quizState) {
    final controller = ref.read(quizControllerProvider.notifier);
    final hasAnswer = quizState.hasCurrentAnswer;
    final isLastQuestion = quizState.isLastQuestion;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Skip button (shown when no answer)
          if (!hasAnswer)
            TextButton(
              onPressed: () => controller.nextQuestion(),
              child: const Text('Pomiń'),
            ),

          // Previous button (shown when not on first question)
          if (quizState.currentQuestionIndex > 0 && hasAnswer)
            TextButton.icon(
              onPressed: () => controller.previousQuestion(),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Poprzednie'),
            ),

          const Spacer(),

          // Next/Finish button
          FilledButton.icon(
            onPressed: () => controller.nextQuestion(),
            icon: Icon(isLastQuestion ? Icons.check : Icons.arrow_forward),
            label: Text(isLastQuestion ? 'Zakończ' : 'Następne'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              backgroundColor: hasAnswer
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  bool _navigationHandled = false;

  void _navigateToResult(QuizSessionState quizState) {
    // Prevent multiple navigations
    if (_navigationHandled) return;
    _navigationHandled = true;

    // Calculate score using QuizScorer
    final score = QuizScorer.calculateScore(quizState);

    // Parse quiz ID to int
    final quizIdInt = int.tryParse(widget.quizId);
    if (quizIdInt == null) {
      // If quizId is invalid, show error and return
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Błąd: Nieprawidłowe ID quizu'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      Navigator.of(context).pop();
      return;
    }

    // Navigate to result screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizResultPage(
          quizId: quizIdInt,
          quizTitle: widget.quizTitle ?? 'Quiz',
          scorePercent: score.percentage,
          correctAnswers: score.correctCount,
          totalQuestions: score.totalQuestions,
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    final controller = ref.read(quizControllerProvider.notifier);

    // Pause quiz while showing dialog
    controller.pauseQuiz();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, size: 48),
        title: const Text('Wyjść z quizu?'),
        content: const Text(
          'Twój postęp nie zostanie zapisany. Czy na pewno chcesz wyjść?',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              controller.resumeQuiz(); // Resume timer
            },
            child: const Text('Kontynuuj'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Wyjdź'),
          ),
        ],
      ),
    );
  }
}
