import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/creator_providers.dart';
import 'create_quiz_step3_page.dart';

/// Step 2 of the Quiz Creator
/// Questions configuration
class CreateQuizStep2Page extends ConsumerStatefulWidget {
  const CreateQuizStep2Page({super.key});

  @override
  ConsumerState<CreateQuizStep2Page> createState() =>
      _CreateQuizStep2PageState();
}

class _CreateQuizStep2PageState extends ConsumerState<CreateQuizStep2Page> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(creatorFormStateProvider);
    final questions = ref.watch(questionsDraftProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nowy Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Step indicator
                    _buildStepIndicator(theme),
                    const SizedBox(height: 28),

                    // Quiz info card
                    if (formState != null) _buildQuizInfoCard(theme, formState),
                    if (formState != null) const SizedBox(height: 20),

                    // Questions list header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pytania (${questions.length})',
                          style: theme.textTheme.titleLarge,
                        ),
                        FilledButton.icon(
                          onPressed: () => _showAddQuestionDialog(context),
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text('Dodaj pytanie'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Questions list
                    if (questions.isEmpty)
                      _buildEmptyState(theme)
                    else
                      ...questions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final question = entry.value;
                        return _buildQuestionCard(
                          theme,
                          question,
                          index + 1,
                          () => _showEditQuestionDialog(context, question),
                          () => _deleteQuestion(question),
                        );
                      }),
                  ],
                ),
              ),
            ),

            // Bottom action buttons
            _buildBottomActions(theme, context, questions.isNotEmpty),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Krok 2 z 3',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  'Konfiguracja pytań',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizInfoCard(ThemeData theme, CreatorFormState formState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz: ${formState.title}',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Kategoria: ${formState.selectedCategory?.name ?? "Brak"}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Brak pytań',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dodaj pierwsze pytanie, aby kontynuować',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
    ThemeData theme,
    QuestionDraft question,
    int questionNumber,
    VoidCallback onEdit,
    VoidCallback onDelete,
  ) {
    return Dismissible(
      key: Key(question.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.errorColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Usuń pytanie'),
            content: const Text('Czy na pewno chcesz usunąć to pytanie?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Anuluj'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                ),
                child: const Text('Usuń'),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (direction) => onDelete(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$questionNumber',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        question.content,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...question.answers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final answer = entry.value;
                  if (answer.trim().isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == question.correctAnswerIndex
                                ? AppTheme.successColor
                                : theme.colorScheme.surfaceContainerHighest,
                            border: Border.all(
                              color: index == question.correctAnswerIndex
                                  ? AppTheme.successColor
                                  : theme.colorScheme.outline.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: index == question.correctAnswerIndex
                                    ? Colors.white
                                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            answer,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: index == question.correctAnswerIndex
                                  ? AppTheme.successColor
                                  : null,
                              fontWeight: index == question.correctAnswerIndex
                                  ? FontWeight.w600
                                  : null,
                            ),
                          ),
                        ),
                        if (index == question.correctAnswerIndex)
                          Icon(
                            Icons.check_circle,
                            size: 20,
                            color: AppTheme.successColor,
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(
    ThemeData theme,
    BuildContext context,
    bool hasQuestions,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back button
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Wstecz',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Next button
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: hasQuestions
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CreateQuizStep3Page(),
                          ),
                        );
                      }
                    : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: hasQuestions
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.12),
                  foregroundColor: hasQuestions
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dalej',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: hasQuestions
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: hasQuestions
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddQuestionDialog(BuildContext context) {
    _showQuestionDialog(context, null);
  }

  void _showEditQuestionDialog(BuildContext context, QuestionDraft question) {
    _showQuestionDialog(context, question);
  }

  void _showQuestionDialog(BuildContext context, QuestionDraft? existingQuestion) {
    final questionController = TextEditingController(
      text: existingQuestion?.content ?? '',
    );
    final answerControllers = List.generate(
      4,
      (index) => TextEditingController(
        text: existingQuestion?.answers[index] ?? '',
      ),
    );
    int? selectedCorrectAnswer = existingQuestion?.correctAnswerIndex;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(existingQuestion == null ? 'Dodaj pytanie' : 'Edytuj pytanie'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question content
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    labelText: 'Treść pytania',
                    hintText: 'Wprowadź treść pytania',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Answers
                Text(
                  'Odpowiedzi:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                ...List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        // Radio button for correct answer
                        Radio<int>(
                          value: index,
                          groupValue: selectedCorrectAnswer,
                          onChanged: (value) {
                            setDialogState(() {
                              selectedCorrectAnswer = value;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        // Answer label
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedCorrectAnswer == index
                                ? AppTheme.successColor.withValues(alpha: 0.1)
                                : Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                            border: Border.all(
                              color: selectedCorrectAnswer == index
                                  ? AppTheme.successColor
                                  : Theme.of(context)
                                      .colorScheme
                                      .outline
                                      .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: selectedCorrectAnswer == index
                                    ? AppTheme.successColor
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Answer text field
                        Expanded(
                          child: TextField(
                            controller: answerControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Odpowiedź ${String.fromCharCode(65 + index)}',
                              border: const OutlineInputBorder(),
                              suffixIcon: selectedCorrectAnswer == index
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: AppTheme.successColor,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Anuluj'),
            ),
            FilledButton(
              onPressed: () {
                final questionText = questionController.text.trim();
                final answers = answerControllers
                    .map((c) => c.text.trim())
                    .toList();
                final nonEmptyAnswers = answers.where((a) => a.isNotEmpty).length;

                // Validation
                if (questionText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Treść pytania jest wymagana'),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                  return;
                }

                if (nonEmptyAnswers < 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wymagane są co najmniej 2 odpowiedzi'),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                  return;
                }

                if (selectedCorrectAnswer == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wybierz poprawną odpowiedź'),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                  return;
                }

                if (answers[selectedCorrectAnswer!].isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Poprawna odpowiedź nie może być pusta'),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                  return;
                }

                // Create or update question
                final question = QuestionDraft(
                  id: existingQuestion?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  content: questionText,
                  answers: answers,
                  correctAnswerIndex: selectedCorrectAnswer!,
                );

                if (existingQuestion == null) {
                  // Add new question
                  ref.read(questionsDraftProvider.notifier).state = [
                    ...ref.read(questionsDraftProvider),
                    question,
                  ];
                } else {
                  // Update existing question
                  final currentQuestions = ref.read(questionsDraftProvider);
                  final index = currentQuestions.indexWhere((q) => q.id == existingQuestion.id);
                  if (index != -1) {
                    final updatedQuestions = List<QuestionDraft>.from(currentQuestions);
                    updatedQuestions[index] = question;
                    ref.read(questionsDraftProvider.notifier).state = updatedQuestions;
                  }
                }

                Navigator.of(context).pop();
              },
              child: Text(existingQuestion == null ? 'Dodaj' : 'Zapisz'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteQuestion(QuestionDraft question) {
    final currentQuestions = ref.read(questionsDraftProvider);
    ref.read(questionsDraftProvider.notifier).state =
        currentQuestions.where((q) => q.id != question.id).toList();
  }
}
