import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/ranking_entry.dart';
import '../../providers/ranking_providers.dart';
import '../pages/ranking_page.dart';

/// Compact ranking preview used on Home screen.
class RankingPreviewCard extends ConsumerWidget {
  const RankingPreviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankingAsync = ref.watch(rankingProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF5F1FF),
            Color(0xFFE9F7FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.leaderboard,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ranking',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Sprawdź kto zdobywa najwięcej punktów',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => _openRankingPage(context),
                child: const Text('Zobacz ranking'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          rankingAsync.when(
            data: (entries) {
              final top = entries.take(3).toList();
              return Column(
                children: top
                    .map((entry) => _TopEntryTile(
                          entry: entry,
                          isLast: entry == top.last,
                        ))
                    .toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Nie udało się wczytać rankingu: $error',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(rankingProvider),
                    child: const Text('Odśwież'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openRankingPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RankingPage(),
      ),
    );
  }
}

class _TopEntryTile extends StatelessWidget {
  const _TopEntryTile({
    required this.entry,
    required this.isLast,
  });

  final RankingEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _PositionChip(position: entry.position),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 20,
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
                  Text(
                    entry.displayName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
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
            Text(
              '${entry.points} pkt',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 12),
          Divider(
            color: AppTheme.dividerColor.withValues(alpha: 0.5),
            height: 1,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _PositionChip extends StatelessWidget {
  const _PositionChip({required this.position});

  final int position;

  @override
  Widget build(BuildContext context) {
    final bool isMedal = position <= 3;
    final Color bgColor = switch (position) {
      1 => const Color(0xFFFFF4D6),
      2 => const Color(0xFFF1F5F9),
      3 => const Color(0xFFFDECEF),
      _ => AppTheme.surfaceColor,
    };
    final Color textColor = switch (position) {
      1 => const Color(0xFFB27300),
      2 => const Color(0xFF475569),
      3 => const Color(0xFFB42318),
      _ => AppTheme.textPrimaryColor,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMedal
              ? textColor.withValues(alpha: 0.35)
              : AppTheme.dividerColor,
        ),
      ),
      child: Text(
        '#$position',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}


