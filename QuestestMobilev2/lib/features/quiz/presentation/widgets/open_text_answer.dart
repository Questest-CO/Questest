import 'package:flutter/material.dart';

/// Widget for displaying open text answer input
/// Allows free-form text entry for essay-type questions
class OpenTextAnswer extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final String? hint;

  const OpenTextAnswer({
    super.key,
    required this.value,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Hint text if provided
        if (hint != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 18,
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hint!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Text input field
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: TextField(
            onChanged: onChanged,
            maxLines: 6,
            minLines: 4,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Wpisz swoją odpowiedź...',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.outline,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, top: 12, right: 8),
                child: Align(
                  alignment: Alignment.topCenter,
                  widthFactor: 1,
                  heightFactor: 6,
                  child: Icon(
                    Icons.edit_note,
                    color: colorScheme.outline,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Character count
        const SizedBox(height: 8),
        Text(
          '${value.length} znaków',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.outline,
          ),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}

