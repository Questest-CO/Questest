import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/csv_service.dart';
import '../../models/survey_stats.dart';
import '../../providers/survey_stats_provider.dart';
import '../widgets/bar_chart_card.dart';

/// Screen showing survey statistics with bar charts.
class SurveyStatsPage extends ConsumerWidget {
  const SurveyStatsPage({super.key});

  Future<void> _handleDownloadCsv(BuildContext context, SurveyStats stats) async {
    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Generowanie CSV...'),
            ],
          ),
          duration: Duration(seconds: 2),
          backgroundColor: AppTheme.primaryColor,
        ),
      );

      final csvContent = CsvService.generateSurveyStatsCsv(stats);
      final fileName = 'ankieta_${DateTime.now().millisecondsSinceEpoch}.csv';

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      // Show options sheet
      if (context.mounted) {
        await showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => _CsvOptionsSheet(
            csvContent: csvContent,
            fileName: fileName,
            surveyTitle: stats.surveyTitle,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd generowania CSV: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(surveyStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statystyki ankiety'),
        actions: [
          // CSV Download button
          statsAsync.whenOrNull(
            data: (stats) => IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Pobierz surowe dane (CSV)',
              onPressed: () => _handleDownloadCsv(context, stats),
            ),
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(surveyStatsProvider),
        child: statsAsync.when(
          data: (stats) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: stats.questions.length + 2, // +2 for header and download button
            itemBuilder: (context, index) {
              if (index == 0) {
                return _HeaderCard(
                  title: stats.surveyTitle,
                  totalRespondents: stats.totalRespondents,
                );
              }
              if (index == stats.questions.length + 1) {
                // Download CSV button at bottom
                return Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                  child: _DownloadCsvButton(
                    onPressed: () => _handleDownloadCsv(context, stats),
                  ),
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

/// Download CSV button widget
class _DownloadCsvButton extends StatelessWidget {
  const _DownloadCsvButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor.withOpacity(0.15),
            AppTheme.primaryColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.table_chart,
              color: AppTheme.accentColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Eksportuj surowe dane',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pobierz wszystkie odpowiedzi w formacie CSV do dalszej analizy',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.download, size: 20),
              label: const Text('Pobierz CSV'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet with CSV options
class _CsvOptionsSheet extends StatelessWidget {
  const _CsvOptionsSheet({
    required this.csvContent,
    required this.fileName,
    required this.surveyTitle,
  });

  final String csvContent;
  final String fileName;
  final String surveyTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppTheme.successColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CSV wygenerowany!',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      fileName,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Share option
          _CsvOptionTile(
            icon: Icons.share,
            title: 'Udostępnij',
            subtitle: 'Wyślij plik CSV',
            color: AppTheme.primaryColor,
            onTap: () async {
              Navigator.pop(context);
              await CsvService.shareCsv(csvContent, fileName);
            },
          ),
          const SizedBox(height: 12),

          // Save option
          _CsvOptionTile(
            icon: Icons.save_alt,
            title: 'Zapisz lokalnie',
            subtitle: 'Zapisz plik w dokumentach aplikacji',
            color: AppTheme.accentColor,
            onTap: () async {
              Navigator.pop(context);
              try {
                final path = await CsvService.saveCsvToDownloads(csvContent, fileName);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Zapisano: $path'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Błąd zapisu: $e'),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                }
              }
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _CsvOptionTile extends StatelessWidget {
  const _CsvOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }
}


