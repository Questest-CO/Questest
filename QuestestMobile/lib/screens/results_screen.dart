import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const Spacer(),
                Text(
                  'Wyniki',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Twój wynik: 85%',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Świetna robota! Zobacz, co jeszcze możesz odkryć.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: colorScheme.tertiary,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.celebration,
                      color: colorScheme.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Gdybyś był pieczywem, byłbyś chrupiącą bagietką! 🥖',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                height: 220,
                width: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 70,
                        startDegreeOffset: -90,
                        borderData: FlBorderData(show: false),
                        sections: [
                          PieChartSectionData(
                            value: 85,
                            color: colorScheme.secondary,
                            title: '85%',
                            radius: 90,
                            titleStyle: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          PieChartSectionData(
                            value: 15,
                            color: Colors.grey.shade300,
                            title: '15%',
                            radius: 80,
                            titleStyle: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        pieTouchData: PieTouchData(enabled: false),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.star_rounded,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Twoje odznaki',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  _AchievementChip(
                    icon: Icons.flash_on,
                    label: 'Szybki Strzał',
                  ),
                  SizedBox(width: 12),
                  _AchievementChip(
                    icon: Icons.military_tech,
                    label: 'Mistrz Historii',
                  ),
                  SizedBox(width: 12),
                  _AchievementChip(
                    icon: Icons.flag,
                    label: 'Perfekcjonista',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              child: const Text('Pobierz PDF z wynikami'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              child: const Text('Udostępnij wynik'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              child: const Text('Zobacz ranking'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AchievementChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      avatar: Icon(
        icon,
        size: 20,
        color: theme.colorScheme.primary,
      ),
      label: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: theme.colorScheme.tertiary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

