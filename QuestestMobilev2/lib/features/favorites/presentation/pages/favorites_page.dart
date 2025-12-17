import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/providers/quiz_provider.dart';
import '../../../quiz/presentation/pages/quiz_solving_page.dart';
import '../../providers/favorites_providers.dart';

/// Favorites Page - displays user's favorite quizzes
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final quizzesAsync = ref.watch(quizzesProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Ulubione'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          if (favoriteIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Usuń wszystkie',
              onPressed: () => _confirmClearAll(context, ref),
            ),
        ],
      ),
      body: favoriteIds.isEmpty
          ? _buildEmptyState(context)
          : quizzesAsync.when(
              data: (allQuizzes) {
                // Filter to only show favorited quizzes
                final favoriteQuizzes = allQuizzes
                    .where((q) => favoriteIds.contains(q.id.toString()))
                    .toList();

                if (favoriteQuizzes.isEmpty) {
                  // Favorites exist but quizzes not found (might be deleted)
                  return _buildEmptyState(context);
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoriteQuizzes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final quiz = favoriteQuizzes[index];
                    final quizIdStr = quiz.id.toString();
                    
                    return _FavoriteQuizCard(
                      title: quiz.title,
                      subtitle: quiz.subtitle,
                      questionCount: quiz.questionCount,
                      difficulty: quiz.difficulty,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QuizSolvingPage(
                              quizId: quiz.id,
                              quizTitle: quiz.title,
                              timeLimitSeconds: quiz.timeLimit,
                            ),
                          ),
                        );
                      },
                      onRemove: () {
                        ref.read(favoritesProvider.notifier).removeFavorite(quizIdStr);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Usunięto "${quiz.title}" z ulubionych'),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'Cofnij',
                              onPressed: () {
                                ref.read(favoritesProvider.notifier).addFavorite(quizIdStr);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => _buildEmptyState(context),
            ),
    );
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Usuń wszystkie ulubione?'),
        content: const Text('Ta operacja usunie wszystkie quizy z listy ulubionych.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            onPressed: () {
              final favorites = ref.read(favoritesProvider).toList();
              for (final id in favorites) {
                ref.read(favoritesProvider.notifier).removeFavorite(id);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Usunięto wszystkie ulubione'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Usuń wszystkie'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 64,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Brak ulubionych',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Dodaj quizy do ulubionych,\naby szybko je znaleźć',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.touch_app_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Naciśnij ❤️ przy quizie',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Favorite quiz card with modern design
class _FavoriteQuizCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int questionCount;
  final String? difficulty;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoriteQuizCard({
    required this.title,
    required this.subtitle,
    required this.questionCount,
    this.difficulty,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    // Generate color based on title
    final hash = title.hashCode;
    final colors = [
      const Color(0xFF6C5CE7),
      const Color(0xFF00B894),
      const Color(0xFFE17055),
      const Color(0xFF74B9FF),
      const Color(0xFFFF6B9D),
    ];
    final color = colors[hash.abs() % colors.length];

    return Card(
      elevation: 2,
      shadowColor: color.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Color indicator and icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Quiz info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _InfoChip(
                          icon: Icons.quiz_outlined,
                          label: '$questionCount pytań',
                          color: color,
                        ),
                        if (difficulty != null) ...[
                          const SizedBox(width: 8),
                          _InfoChip(
                            icon: Icons.speed_rounded,
                            label: difficulty!,
                            color: _getDifficultyColor(difficulty!),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Favorite button
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                    ),
                    onPressed: onRemove,
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String level) {
    switch (level.toLowerCase()) {
      case 'easy':
      case 'łatwy':
        return AppTheme.successColor;
      case 'medium':
      case 'średni':
        return AppTheme.warningColor;
      case 'hard':
      case 'trudny':
        return AppTheme.errorColor;
      default:
        return Colors.grey;
    }
  }
}

/// Small info chip widget
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
