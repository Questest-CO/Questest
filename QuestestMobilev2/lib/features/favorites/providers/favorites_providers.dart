import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/quiz_model.dart';

/// Provider for managing user's favorite quizzes
/// Uses local state (SharedPreferences would be better for persistence)
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

/// Provider for favorite quizzes list
final favoriteQuizzesProvider = Provider<List<QuizModel>>((ref) {
  // This would need to fetch full quiz data
  // For now returning empty list - favorites are stored as IDs
  return [];
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggleFavorite(String quizId) {
    if (state.contains(quizId)) {
      state = Set.from(state)..remove(quizId);
    } else {
      state = Set.from(state)..add(quizId);
    }
  }

  void addFavorite(String quizId) {
    if (!state.contains(quizId)) {
      state = Set.from(state)..add(quizId);
    }
  }

  void removeFavorite(String quizId) {
    if (state.contains(quizId)) {
      state = Set.from(state)..remove(quizId);
    }
  }

  bool isFavorite(String quizId) {
    return state.contains(quizId);
  }
}

/// Helper provider to check if a specific quiz is favorited
final isFavoriteProvider = Provider.family<bool, String>((ref, quizId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.contains(quizId);
});

