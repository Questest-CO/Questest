import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/home_providers.dart';

/// Category filter chips for quiz filtering
class CategoryFilters extends ConsumerWidget {
  const CategoryFilters({super.key});

  static const List<Map<String, String>> categories = [
    {'id': 'all', 'label': 'Wszystko'},
    {'id': 'quiz', 'label': 'Quizy'},
    {'id': 'exam', 'label': 'Egzaminy'},
    {'id': 'my_quizzes', 'label': 'Moje Quizy'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final theme = Theme.of(context);

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category['id'];

          return FilterChip(
            label: Text(category['label']!),
            selected: isSelected,
            onSelected: (selected) {
              ref.read(selectedCategoryProvider.notifier).state =
                  category['id']!;
            },
            backgroundColor: theme.colorScheme.surface,
            selectedColor: theme.colorScheme.primary.withOpacity(0.2),
            checkmarkColor: theme.colorScheme.primary,
            labelStyle: TextStyle(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.textTheme.bodyMedium?.color,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            side: BorderSide(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
              width: isSelected ? 1.5 : 1,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          );
        },
      ),
    );
  }
}
