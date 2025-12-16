import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared_ui/widgets/q_primary_button.dart';

/// "Twój wynik" screen with donut chart and dynamic messages.
class QuizResultPage extends StatelessWidget {
  const QuizResultPage({
    super.key,
    required this.scorePercent,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  /// Score in percentage (0-100)
  final double scorePercent;

  /// Number of correct answers
  final int correctAnswers;

  /// Total number of questions
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double safePercent = scorePercent.clamp(0, 100).toDouble();
    final incorrect = max(totalQuestions - correctAnswers, 0);
    final message = _buildMessage(safePercent);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Twój wynik'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Twój wynik',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${safePercent.toStringAsFixed(0)}%',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Poprawne: $correctAnswers / $totalQuestions',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 16),
              _MessageCard(message: message),
              const SizedBox(height: 24),
              _DonutChart(
                scorePercent: safePercent,
                correct: correctAnswers,
                incorrect: incorrect,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: QPrimaryButton(
                      text: 'Spróbuj ponownie',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: QSecondaryButton(
                      text: 'Udostępnij',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Udostępnianie w przygotowaniu'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              QSecondaryButton(
                text: 'Zobacz ranking',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: AppTheme.surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.accentColor.withValues(alpha: 0.25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_emotions_outlined,
                color: AppTheme.accentColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  const _DonutChart({
    required this.scorePercent,
    required this.correct,
    required this.incorrect,
  });

  final double scorePercent;
  final int correct;
  final int incorrect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double remainingPercent = (100 - scorePercent).toDouble();

    return Center(
      child: SizedBox(
        height: 230,
        width: 230,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                sectionsSpace: 6,
                centerSpaceRadius: 70,
                startDegreeOffset: -90,
                borderData: FlBorderData(show: false),
                sections: [
                  PieChartSectionData(
                    value: scorePercent,
                    color: AppTheme.primaryColor,
                    title: '${scorePercent.toStringAsFixed(0)}%',
                    radius: 90,
                    titleStyle: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  PieChartSectionData(
                    value: remainingPercent,
                    color: AppTheme.dividerColor,
                    title: '${remainingPercent.toStringAsFixed(0)}%',
                    radius: 78,
                    titleStyle: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                pieTouchData: PieTouchData(enabled: false),
              ),
            ),
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$correct / ${correct + incorrect}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Poprawne',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
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

String _buildMessage(double score) {
  if (score >= 90) {
    return 'Gdybyś był pieczywem, byłbyś chrupiącą bagietką! 🥖 Doskonały wynik.';
  } else if (score >= 75) {
    return 'Solidny wynik! Jak świeży croissant – lekkość i forma. 🥐';
  } else if (score >= 60) {
    return 'Całkiem nieźle – jak porządna grahamka. Trochę pracy i będzie top. 🥯';
  } else if (score >= 40) {
    return 'Jesteś na dobrej drodze. Jeszcze kilka wypieków i będzie idealnie. 🍞';
  }
  return 'Początki są najważniejsze. Zbudujmy razem solidny zakwas. 🍞';
}

