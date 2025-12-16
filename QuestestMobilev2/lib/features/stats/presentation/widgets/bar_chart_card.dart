import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_constants.dart';
import '../../models/answer_option_stat.dart';

/// Simple horizontal bar chart card for survey answers.
class BarChartCard extends StatelessWidget {
  const BarChartCard({
    super.key,
    required this.title,
    required this.totalResponses,
    required this.options,
  });

  /// Question text
  final String title;

  /// Total responses for percentage calculation fallback
  final int totalResponses;

  /// Options with counts/percentages
  final List<AnswerOptionStat> options;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxValue = options.map((o) => o.count).fold<int>(0, (p, c) => c > p ? c : p);
    final resolvedTotal = totalResponses > 0 ? totalResponses : options.fold<int>(0, (p, o) => p + o.count);

    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...options.map((option) {
              final percent = option.percentage ??
                  (resolvedTotal == 0 ? 0 : (option.count / resolvedTotal) * 100);
              final barFraction = maxValue == 0 ? 0.0 : option.count / maxValue;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            option.label,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '${option.count} • ${percent.toStringAsFixed(1)}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final barWidth = constraints.maxWidth * barFraction;
                        return Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppTheme.dividerColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: barWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: AppTheme.primaryGradient,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

