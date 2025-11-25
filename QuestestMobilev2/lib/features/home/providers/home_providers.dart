import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/quiz_model.dart';
import 'quiz_provider.dart';

/// Provider for search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for selected category filter
/// Categories: 'all', 'quiz', 'exam', 'my_quizzes'
final selectedCategoryProvider = StateProvider<String>((ref) => 'all');

/// Provider for filtered quizzes based on search and category
final filteredQuizzesProvider = Provider<AsyncValue<List<QuizModel>>>((ref) {
  final quizzesAsync = ref.watch(quizzesProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return quizzesAsync.whenData((quizzes) {
    var filtered = quizzes;

    // Filter by category
    if (selectedCategory != 'all') {
      if (selectedCategory == 'my_quizzes') {
        // TODO: Implement user ownership filtering
        // For now, return empty list as placeholder
        filtered = [];
      } else {
        filtered = filtered
            .where((quiz) => quiz.category == selectedCategory)
            .toList();
      }
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((quiz) => quiz.title.toLowerCase().contains(searchQuery))
          .toList();
    }

    return filtered;
  });
});
