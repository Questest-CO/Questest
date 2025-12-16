import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../models/ranking_entry.dart';
import '../../providers/ranking_providers.dart';

/// Dedicated screen with full leaderboard.
class RankingPage extends ConsumerWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankingAsync = ref.watch(rankingProvider);
    final authState = ref.watch(authStateChangesProvider);
    final currentEmail = authState.valueOrNull?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(rankingProvider),
        child: rankingAsync.when(
          data: (entries) => ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final isCurrentUser = entry.belongsTo(currentEmail);
              return _RankingTile(
                entry: entry,
                isCurrentUser: isCurrentUser,
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: entries.length,
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => _RankingError(
            error: error,
            onRetry: () => ref.invalidate(rankingProvider),
          ),
        ),
      ),
    );
  }
}

class _RankingTile extends StatelessWidget {
  const _RankingTile({
    required this.entry,
    required this.isCurrentUser,
  });

  final RankingEntry entry;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final bool isMedal = entry.position <= 3;
    final Color badgeColor = switch (entry.position) {
      1 => const Color(0xFFFFD700),
      2 => const Color(0xFFC0C0C0),
      3 => const Color(0xFFCD7F32),
      _ => AppTheme.dividerColor,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppTheme.primaryColor.withValues(alpha: 0.06)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentUser
              ? AppTheme.primaryColor.withValues(alpha: 0.25)
              : AppTheme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          _PositionCircle(
            position: entry.position,
            background: badgeColor,
            highlighted: isMedal,
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 24,
            backgroundImage:
                entry.avatarUrl != null ? NetworkImage(entry.avatarUrl!) : null,
            child: entry.avatarUrl == null
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.displayName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight:
                                  isCurrentUser ? FontWeight.w700 : FontWeight.w600,
                            ),
                      ),
                    ),
                    if (isCurrentUser)
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Ty',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${entry.quizzesPlayed} quizów',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppTheme.textSecondaryColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.points} pkt',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Suma punktów',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PositionCircle extends StatelessWidget {
  const _PositionCircle({
    required this.position,
    required this.background,
    required this.highlighted,
  });

  final int position;
  final Color background;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: background.withValues(alpha: highlighted ? 0.25 : 0.18),
        border: Border.all(
          color: highlighted
              ? background.withValues(alpha: 0.65)
              : AppTheme.dividerColor,
          width: highlighted ? 2 : 1,
        ),
      ),
      child: Center(
        child: Text(
          '$position',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: highlighted ? AppTheme.textPrimaryColor : Colors.black87,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

class _RankingError extends StatelessWidget {
  const _RankingError({
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.errorColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.errorColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: AppTheme.errorColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Nie udało się pobrać rankingu.\n$error',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: onRetry,
                child: const Text('Spróbuj ponownie'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


