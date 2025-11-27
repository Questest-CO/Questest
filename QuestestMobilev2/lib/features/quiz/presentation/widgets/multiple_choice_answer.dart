import 'package:flutter/material.dart';
import '../../models/quiz_question.dart';

/// Widget for displaying multiple choice answer options
/// Multiple options can be selected at once
class MultipleChoiceAnswer extends StatelessWidget {
  final List<AnswerOption> options;
  final Set<int> selectedOptionIds;
  final ValueChanged<int> onOptionToggled;

  const MultipleChoiceAnswer({
    super.key,
    required this.options,
    required this.selectedOptionIds,
    required this.onOptionToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: options.map((option) {
        final isSelected = selectedOptionIds.contains(option.id);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _CheckboxTile(
            option: option,
            isSelected: isSelected,
            onTap: () => onOptionToggled(option.id),
          ),
        );
      }).toList(),
    );
  }
}

class _CheckboxTile extends StatelessWidget {
  final AnswerOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _CheckboxTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Checkbox indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: isSelected
                      ? colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              // Answer text
              Expanded(
                child: Text(
                  option.content,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

