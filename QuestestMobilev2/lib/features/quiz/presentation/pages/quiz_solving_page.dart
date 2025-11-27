import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/quiz_session_state.dart';
import '../../models/quiz_question.dart';
import '../../providers/quiz_controller.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_progress_header.dart';
import '../widgets/single_choice_answer.dart';
import '../widgets/multiple_choice_answer.dart';
import '../widgets/open_text_answer.dart';

/// Main quiz solving screen
/// Displays questions and handles user answers
/// Uses Riverpod for state management
class QuizSolvingPage extends ConsumerStatefulWidget {
  const QuizSolvingPage({super.key});

  @override
  ConsumerState<QuizSolvingPage> createState() => _QuizSolvingPageState();
}

class _QuizSolvingPageState extends ConsumerState<QuizSolvingPage> {
  @override
  void initState() {
    super.initState();
    // Start quiz after first frame to ensure provider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quizControllerProvider.notifier).startQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quizState = ref.watch(quizControllerProvider);

    // Handle completed state
    if (quizState.status == QuizStatus.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCompletionDialog(quizState);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(MockQuizData.quizTitle),
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

  bool _dialogShown = false;

  void _showCompletionDialog(QuizSessionState quizState) {
    if (_dialogShown) return;
    _dialogShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.successColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.celebration,
            size: 48,
            color: AppTheme.successColor,
          ),
        ),
        title: const Text('Quiz ukończony!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Gratulacje! Odpowiedziałeś na wszystkie pytania.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Show summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                      'Pytania', '${quizState.totalQuestions}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                      'Odpowiedzi', '${quizState.answeredCount}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                      'Pozostały czas', quizState.formattedTime),
                ],
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to home
            },
            child: const Text('Zakończ'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
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
