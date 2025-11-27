import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/quiz_question.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_progress_header.dart';
import '../widgets/single_choice_answer.dart';
import '../widgets/multiple_choice_answer.dart';
import '../widgets/open_text_answer.dart';

/// Main quiz solving screen
/// Displays questions and handles user answers
class QuizSolvingPage extends StatefulWidget {
  const QuizSolvingPage({super.key});

  @override
  State<QuizSolvingPage> createState() => _QuizSolvingPageState();
}

class _QuizSolvingPageState extends State<QuizSolvingPage> {
  // Current question index
  int _currentQuestionIndex = 0;

  // Answers storage
  final Map<int, int?> _singleChoiceAnswers = {};
  final Map<int, Set<int>> _multipleChoiceAnswers = {};
  final Map<int, String> _openTextAnswers = {};

  // Get current question
  QuizQuestion get _currentQuestion =>
      MockQuizData.questions[_currentQuestionIndex];

  // Check if we're on the last question
  bool get _isLastQuestion =>
      _currentQuestionIndex >= MockQuizData.questions.length - 1;

  // Check if current question has an answer
  bool get _hasAnswer {
    switch (_currentQuestion.type) {
      case QuestionType.singleChoice:
        return _singleChoiceAnswers[_currentQuestion.id] != null;
      case QuestionType.multipleChoice:
        final answers = _multipleChoiceAnswers[_currentQuestion.id];
        return answers != null && answers.isNotEmpty;
      case QuestionType.openText:
        final answer = _openTextAnswers[_currentQuestion.id];
        return answer != null && answer.trim().isNotEmpty;
    }
  }

  void _handleNextQuestion() {
    if (_isLastQuestion) {
      // Show completion dialog
      _showCompletionDialog();
    } else {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _showCompletionDialog() {
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
                  _buildSummaryRow('Pytania', '${MockQuizData.questions.length}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Odpowiedzi', '${_countAnswers()}'),
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

  int _countAnswers() {
    int count = 0;
    count += _singleChoiceAnswers.values.where((v) => v != null).length;
    count += _multipleChoiceAnswers.values.where((v) => v.isNotEmpty).length;
    count += _openTextAnswers.values.where((v) => v.trim().isNotEmpty).length;
    return count;
  }

  void _handleSingleChoiceSelection(int optionId) {
    setState(() {
      _singleChoiceAnswers[_currentQuestion.id] = optionId;
    });
  }

  void _handleMultipleChoiceToggle(int optionId) {
    setState(() {
      final currentAnswers =
          _multipleChoiceAnswers[_currentQuestion.id] ?? <int>{};

      if (currentAnswers.contains(optionId)) {
        currentAnswers.remove(optionId);
      } else {
        currentAnswers.add(optionId);
      }

      _multipleChoiceAnswers[_currentQuestion.id] = currentAnswers;
    });
  }

  void _handleOpenTextChange(String value) {
    setState(() {
      _openTextAnswers[_currentQuestion.id] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(MockQuizData.quizTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitConfirmation(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: QuizTimer(timerText: '14:59'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress header
            QuizProgressHeader(
              currentQuestion: _currentQuestionIndex + 1,
              totalQuestions: MockQuizData.questions.length,
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
                      question: _currentQuestion,
                      questionNumber: _currentQuestionIndex + 1,
                      totalQuestions: MockQuizData.questions.length,
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
                    _buildAnswerWidget(),
                  ],
                ),
              ),
            ),

            // Bottom action bar
            _buildBottomBar(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerWidget() {
    switch (_currentQuestion.type) {
      case QuestionType.singleChoice:
        return SingleChoiceAnswer(
          options: _currentQuestion.options!,
          selectedOptionId: _singleChoiceAnswers[_currentQuestion.id],
          onOptionSelected: _handleSingleChoiceSelection,
        );

      case QuestionType.multipleChoice:
        return MultipleChoiceAnswer(
          options: _currentQuestion.options!,
          selectedOptionIds:
              _multipleChoiceAnswers[_currentQuestion.id] ?? <int>{},
          onOptionToggled: _handleMultipleChoiceToggle,
        );

      case QuestionType.openText:
        return OpenTextAnswer(
          value: _openTextAnswers[_currentQuestion.id] ?? '',
          onChanged: _handleOpenTextChange,
          hint: _currentQuestion.hint,
        );
    }
  }

  Widget _buildBottomBar(ThemeData theme) {
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
          // Skip button (optional)
          if (!_hasAnswer)
            TextButton(
              onPressed: _handleNextQuestion,
              child: const Text('Pomiń'),
            ),

          const Spacer(),

          // Next/Finish button
          FilledButton.icon(
            onPressed: _handleNextQuestion,
            icon: Icon(_isLastQuestion ? Icons.check : Icons.arrow_forward),
            label: Text(_isLastQuestion ? 'Zakończ' : 'Następne'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              backgroundColor: _hasAnswer
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, size: 48),
        title: const Text('Wyjść z quizu?'),
        content: const Text(
          'Twój postęp nie zostanie zapisany. Czy na pewno chcesz wyjść?',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kontynuuj'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
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

