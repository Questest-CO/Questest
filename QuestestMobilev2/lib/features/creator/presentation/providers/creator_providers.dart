import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/oracle/category_model.dart';
import '../../../../core/providers/oracle_providers.dart';

/// Quiz type enum for the creator
enum QuizType {
  quiz('Quiz'),
  survey('Ankieta'),
  exam('Egzamin');

  final String label;
  const QuizType(this.label);
}

/// Provider for fetching categories from Oracle DB
/// Uses AsyncValue for proper loading/error/data states
final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repository = ref.watch(oracleRepositoryProvider);
  return repository.getCategories();
});

/// Form state for creator Step 1
class CreatorFormState {
  final QuizType type;
  final String title;
  final String description;
  final CategoryModel? selectedCategory;

  const CreatorFormState({
    this.type = QuizType.quiz,
    this.title = '',
    this.description = '',
    this.selectedCategory,
  });

  /// Check if form is valid (title not empty and category selected)
  bool get isValid => title.trim().isNotEmpty && selectedCategory != null;

  CreatorFormState copyWith({
    QuizType? type,
    String? title,
    String? description,
    CategoryModel? selectedCategory,
  }) {
    return CreatorFormState(
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  String toString() {
    return 'CreatorFormState(type: ${type.label}, title: $title, category: ${selectedCategory?.name})';
  }
}

