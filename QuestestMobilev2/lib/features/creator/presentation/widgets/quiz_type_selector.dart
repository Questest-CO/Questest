import 'package:flutter/material.dart';
import '../providers/creator_providers.dart';

/// Segmented button for selecting quiz type
/// Options: Quiz, Ankieta (Survey), Egzamin (Exam)
class QuizTypeSelector extends StatelessWidget {
  final QuizType selectedType;
  final ValueChanged<QuizType> onTypeChanged;

  const QuizTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Typ',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SegmentedButton<QuizType>(
          segments: QuizType.values.map((type) {
            return ButtonSegment<QuizType>(
              value: type,
              label: Text(type.label),
              icon: Icon(_getIconForType(type)),
            );
          }).toList(),
          selected: {selectedType},
          onSelectionChanged: (Set<QuizType> selection) {
            onTypeChanged(selection.first);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.selected)) {
                return colorScheme.primary;
              }
              return colorScheme.surface;
            }),
            foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.selected)) {
                return colorScheme.onPrimary;
              }
              return colorScheme.onSurface;
            }),
          ),
        ),
      ],
    );
  }

  IconData _getIconForType(QuizType type) {
    switch (type) {
      case QuizType.quiz:
        return Icons.quiz_outlined;
      case QuizType.survey:
        return Icons.poll_outlined;
      case QuizType.exam:
        return Icons.school_outlined;
    }
  }
}

