import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/survey_stats_provider.dart';
import '../widgets/bar_chart_card.dart';

/// Screen showing survey statistics with bar charts.
class SurveyStatsPage extends ConsumerWidget {
  const SurveyStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(surveyStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statystyki ankiety'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(surveyStatsProvider),
        child: statsAsync.when(
          data: (stats) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: stats.questions.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _HeaderCard(
                  title: stats.surveyTitle,
                  totalRespondents: stats.totalRespondents,
                );
              }
              final question = stats.questions[index - 1];
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: BarChartCard(
                  title: question.question,
                  totalResponses: question.totalResponses,
                  options: question.options,
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => _ErrorState(
            message: 'Nie udało się pobrać statystyk.\n$err',
            onRetry: () => ref.invalidate(surveyStatsProvider),
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.title,
    required this.totalRespondents,
  });

  final String title;
  final int totalRespondents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.how_to_vote, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                '$totalRespondents odpowiedzi',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
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
                  message,
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


