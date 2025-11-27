import 'package:flutter/material.dart';
import '../../models/quiz_question.dart';

/// Widget displaying the question content
/// Shows question number, type indicator, and the question text
class QuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final int questionNumber;
  final int totalQuestions;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question number and type badge row
        Row(
          children: [
            Text(
              'Pytanie $questionNumber z $totalQuestions',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.outline,
              ),
            ),
            const Spacer(),
            _QuestionTypeBadge(type: question.type),
          ],
        ),
        const SizedBox(height: 16),

        // Question content card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primaryContainer.withValues(alpha: 0.3),
                colorScheme.secondaryContainer.withValues(alpha: 0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_outline,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              // Question text
              Text(
                question.content,
                style: theme.textTheme.titleLarge?.copyWith(
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Hint if available
              if (question.hint != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          question.hint!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _QuestionTypeBadge extends StatelessWidget {
  final QuestionType type;

  const _QuestionTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, icon, color) = _getTypeData(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  (String, IconData, Color) _getTypeData(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case QuestionType.singleChoice:
        return ('Jednokrotny', Icons.radio_button_checked, colorScheme.primary);
      case QuestionType.multipleChoice:
        return ('Wielokrotny', Icons.check_box, colorScheme.secondary);
      case QuestionType.openText:
        return ('Otwarte', Icons.edit_note, colorScheme.tertiary);
    }
  }
}

