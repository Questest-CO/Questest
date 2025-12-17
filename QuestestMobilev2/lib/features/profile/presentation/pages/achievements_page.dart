import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../providers/profile_providers.dart';

/// Page displaying all user achievements
class AchievementsPage extends ConsumerWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Gradient app bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6C5CE7),
                      Color(0xFF8B7CF7),
                      Color(0xFFA29BFE),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Twoje osiągnięcia',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Stats summary
          SliverToBoxAdapter(
            child: statsAsync.when(
              data: (stats) => _StatsSummary(
                unlockedCount: stats.achievements.length,
                totalCount: _allAchievements.length,
              ),
              loading: () => const _StatsSummary(unlockedCount: 0, totalCount: 0),
              error: (_, __) => const _StatsSummary(unlockedCount: 0, totalCount: 0),
            ),
          ),
          // Unlocked achievements section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppTheme.successColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Odblokowane',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          // Unlocked achievements grid
          statsAsync.when(
            data: (stats) {
              if (stats.achievements.isEmpty) {
                return SliverToBoxAdapter(
                  child: _EmptySection(
                    message: 'Jeszcze nie masz żadnych osiągnięć.\nRozwiązuj quizy, aby je zdobyć!',
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final achievement = stats.achievements[index];
                      return _AchievementCard(
                        achievement: achievement,
                        isUnlocked: true,
                      );
                    },
                    childCount: stats.achievements.length,
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SliverToBoxAdapter(
              child: Center(child: Text('Błąd ładowania')),
            ),
          ),
          // Locked achievements section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      color: Colors.grey[500],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Do zdobycia',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          // Locked achievements grid
          statsAsync.when(
            data: (stats) {
              final unlockedIds = stats.achievements.map((a) => a.id).toSet();
              final lockedAchievements = _allAchievements
                  .where((a) => !unlockedIds.contains(a.id))
                  .toList();
              
              if (lockedAchievements.isEmpty) {
                return SliverToBoxAdapter(
                  child: _EmptySection(
                    message: 'Gratulacje! 🎉\nOdblokowałeś wszystkie osiągnięcia!',
                    isSuccess: true,
                  ),
                );
              }
              
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final achievement = lockedAchievements[index];
                      return _AchievementCard(
                        achievement: achievement,
                        isUnlocked: false,
                      );
                    },
                    childCount: lockedAchievements.length,
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}

/// All possible achievements
final List<Achievement> _allAchievements = [
  Achievement(
    id: 'first_quiz',
    name: 'Pierwszy krok',
    description: 'Ukończ swój pierwszy quiz',
    emoji: '🎯',
    color: const Color(0xFF3498DB),
    isUnlocked: false,
  ),
  Achievement(
    id: 'quiz_5',
    name: 'Na dobrej drodze',
    description: 'Ukończ 5 quizów',
    emoji: '⭐',
    color: const Color(0xFFF39C12),
    isUnlocked: false,
  ),
  Achievement(
    id: 'quiz_10',
    name: 'Quiz Master',
    description: 'Ukończ 10 quizów',
    emoji: '🏆',
    color: const Color(0xFF9B59B6),
    isUnlocked: false,
  ),
  Achievement(
    id: 'quiz_25',
    name: 'Quiz Expert',
    description: 'Ukończ 25 quizów',
    emoji: '👑',
    color: const Color(0xFFE74C3C),
    isUnlocked: false,
  ),
  Achievement(
    id: 'quiz_50',
    name: 'Quiz Legend',
    description: 'Ukończ 50 quizów',
    emoji: '🌟',
    color: const Color(0xFF8E44AD),
    isUnlocked: false,
  ),
  Achievement(
    id: 'points_100',
    name: 'Kolekcjoner',
    description: 'Zdobądź 100 punktów',
    emoji: '💎',
    color: const Color(0xFF1ABC9C),
    isUnlocked: false,
  ),
  Achievement(
    id: 'points_500',
    name: 'Bogacz',
    description: 'Zdobądź 500 punktów',
    emoji: '💰',
    color: const Color(0xFF27AE60),
    isUnlocked: false,
  ),
  Achievement(
    id: 'points_1000',
    name: 'Milioner',
    description: 'Zdobądź 1000 punktów',
    emoji: '🤑',
    color: const Color(0xFF2ECC71),
    isUnlocked: false,
  ),
  Achievement(
    id: 'perfect_score',
    name: 'Perfekcjonista',
    description: 'Zdobądź 100% w quizie',
    emoji: '💯',
    color: const Color(0xFFE91E63),
    isUnlocked: false,
  ),
  Achievement(
    id: 'speed_demon',
    name: 'Błyskawica',
    description: 'Ukończ quiz w mniej niż minutę',
    emoji: '⚡',
    color: const Color(0xFFFF9800),
    isUnlocked: false,
  ),
  Achievement(
    id: 'streak_3',
    name: 'Na fali',
    description: '3 quizy z rzędu bez błędu',
    emoji: '🔥',
    color: const Color(0xFFFF5722),
    isUnlocked: false,
  ),
  Achievement(
    id: 'explorer',
    name: 'Odkrywca',
    description: 'Wypróbuj 5 różnych kategorii',
    emoji: '🧭',
    color: const Color(0xFF00BCD4),
    isUnlocked: false,
  ),
];

/// Stats summary card
class _StatsSummary extends StatelessWidget {
  final int unlockedCount;
  final int totalCount;

  const _StatsSummary({
    required this.unlockedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? unlockedCount / totalCount : 0.0;
    
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                value: unlockedCount.toString(),
                label: 'Odblokowane',
                color: AppTheme.successColor,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[200],
              ),
              _StatItem(
                value: (totalCount - unlockedCount).toString(),
                label: 'Pozostało',
                color: Colors.grey,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[200],
              ),
              _StatItem(
                value: '${(progress * 100).toInt()}%',
                label: 'Postęp',
                color: AppTheme.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
        ),
      ],
    );
  }
}

/// Achievement card widget
class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;

  const _AchievementCard({
    required this.achievement,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAchievementDetails(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked
                ? achievement.color.withValues(alpha: 0.3)
                : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: achievement.color.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji or lock icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? achievement.color.withValues(alpha: 0.1)
                    : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: isUnlocked
                  ? Text(
                      achievement.emoji,
                      style: const TextStyle(fontSize: 32),
                    )
                  : Icon(
                      Icons.lock_rounded,
                      size: 32,
                      color: Colors.grey[400],
                    ),
            ),
            const SizedBox(height: 12),
            // Name
            Text(
              achievement.name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isUnlocked
                        ? AppTheme.textPrimaryColor
                        : Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Description
            Text(
              achievement.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isUnlocked
                        ? AppTheme.textSecondaryColor
                        : Colors.grey[400],
                    fontSize: 11,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showAchievementDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            // Achievement icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? achievement.color.withValues(alpha: 0.1)
                    : Colors.grey[100],
                shape: BoxShape.circle,
                border: Border.all(
                  color: isUnlocked
                      ? achievement.color.withValues(alpha: 0.3)
                      : Colors.grey[300]!,
                  width: 3,
                ),
              ),
              child: isUnlocked
                  ? Text(
                      achievement.emoji,
                      style: const TextStyle(fontSize: 48),
                    )
                  : Icon(
                      Icons.lock_rounded,
                      size: 48,
                      color: Colors.grey[400],
                    ),
            ),
            const SizedBox(height: 20),
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppTheme.successColor.withValues(alpha: 0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isUnlocked ? Icons.check_circle : Icons.lock_outline,
                    size: 16,
                    color: isUnlocked ? AppTheme.successColor : Colors.grey[500],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isUnlocked ? 'Odblokowane' : 'Zablokowane',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isUnlocked
                              ? AppTheme.successColor
                              : Colors.grey[500],
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Name
            Text(
              achievement.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              achievement.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUnlocked
                      ? achievement.color
                      : Colors.grey[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Zamknij'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Empty section widget
class _EmptySection extends StatelessWidget {
  final String message;
  final bool isSuccess;

  const _EmptySection({
    required this.message,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isSuccess
            ? AppTheme.successColor.withValues(alpha: 0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: isSuccess
            ? Border.all(
                color: AppTheme.successColor.withValues(alpha: 0.3),
              )
            : null,
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSuccess ? AppTheme.successColor : Colors.grey[600],
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

