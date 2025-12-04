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

/// Provider for storing the creator form state across steps
final creatorFormStateProvider = StateProvider<CreatorFormState?>((ref) => null);

/// Model for a question draft being created
class QuestionDraft {
  final String id;
  final String content;
  final List<String> answers; // A, B, C, D
  final int correctAnswerIndex; // 0-3

  const QuestionDraft({
    required this.id,
    required this.content,
    required this.answers,
    required this.correctAnswerIndex,
  });

  /// Check if question is valid
  bool get isValid {
    return content.trim().isNotEmpty &&
        answers.where((a) => a.trim().isNotEmpty).length >= 2 &&
        correctAnswerIndex >= 0 &&
        correctAnswerIndex < answers.length &&
        answers[correctAnswerIndex].trim().isNotEmpty;
  }

  QuestionDraft copyWith({
    String? id,
    String? content,
    List<String>? answers,
    int? correctAnswerIndex,
  }) {
    return QuestionDraft(
      id: id ?? this.id,
      content: content ?? this.content,
      answers: answers ?? this.answers,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
    );
  }

  @override
  String toString() {
    return 'QuestionDraft(content: $content, correctAnswer: ${answers[correctAnswerIndex]})';
  }
}

/// Provider for managing the list of question drafts
final questionsDraftProvider = StateProvider<List<QuestionDraft>>((ref) => []);

