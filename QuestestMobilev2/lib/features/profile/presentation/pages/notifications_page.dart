import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../providers/profile_providers.dart';

/// Notifications settings page
class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Powiadomienia'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header illustration
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFF39C12).withOpacity(0.15),
                  const Color(0xFFE74C3C).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF39C12).withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    size: 48,
                    color: Color(0xFFF39C12),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Zarządzaj powiadomieniami',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Wybierz, o czym chcesz być informowany',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Notification options
          _NotificationSection(
            title: 'Powiadomienia o quizach',
            children: [
              _NotificationSwitch(
                icon: Icons.alarm_rounded,
                iconColor: const Color(0xFF3498DB),
                title: 'Przypomnienia o quizach',
                subtitle: 'Przypomnij mi o niedokończonych quizach',
                value: settings.quizReminders,
                onChanged: (value) {
                  ref.read(notificationSettingsProvider.notifier).toggleQuizReminders(value);
                },
              ),
              _NotificationSwitch(
                icon: Icons.new_releases_rounded,
                iconColor: const Color(0xFF9B59B6),
                title: 'Nowe quizy',
                subtitle: 'Powiadom mnie o nowych quizach',
                value: settings.newQuizzes,
                onChanged: (value) {
                  ref.read(notificationSettingsProvider.notifier).toggleNewQuizzes(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          _NotificationSection(
            title: 'Osiągnięcia i statystyki',
            children: [
              _NotificationSwitch(
                icon: Icons.emoji_events_rounded,
                iconColor: const Color(0xFFF39C12),
                title: 'Osiągnięcia',
                subtitle: 'Powiadom mnie o nowych osiągnięciach',
                value: settings.achievements,
                onChanged: (value) {
                  ref.read(notificationSettingsProvider.notifier).toggleAchievements(value);
                },
              ),
              _NotificationSwitch(
                icon: Icons.bar_chart_rounded,
                iconColor: const Color(0xFF1ABC9C),
                title: 'Tygodniowe podsumowanie',
                subtitle: 'Otrzymuj cotygodniowy raport',
                value: settings.weeklyStats,
                onChanged: (value) {
                  ref.read(notificationSettingsProvider.notifier).toggleWeeklyStats(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Recent notifications section
          Text(
            'Ostatnie powiadomienia',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textSecondaryColor,
                ),
          ),
          const SizedBox(height: 16),

          // Example notifications
          _NotificationItem(
            icon: Icons.emoji_events_rounded,
            iconColor: const Color(0xFFF39C12),
            iconBgColor: const Color(0xFFF39C12).withOpacity(0.1),
            title: 'Nowe osiągnięcie!',
            subtitle: 'Zdobyłeś odznakę "Quiz Master"',
            time: '2 godz. temu',
            isUnread: true,
          ),
          _NotificationItem(
            icon: Icons.quiz_rounded,
            iconColor: const Color(0xFF9B59B6),
            iconBgColor: const Color(0xFF9B59B6).withOpacity(0.1),
            title: 'Nowy quiz dostępny',
            subtitle: 'Sprawdź "Historia Polski - Quiz"',
            time: '5 godz. temu',
            isUnread: true,
          ),
          _NotificationItem(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFF3498DB),
            iconBgColor: const Color(0xFF3498DB).withOpacity(0.1),
            title: 'Gratulacje!',
            subtitle: 'Ukończyłeś quiz z wynikiem 95%',
            time: 'Wczoraj',
            isUnread: false,
          ),
          _NotificationItem(
            icon: Icons.trending_up_rounded,
            iconColor: const Color(0xFF1ABC9C),
            iconBgColor: const Color(0xFF1ABC9C).withOpacity(0.1),
            title: 'Tygodniowe podsumowanie',
            subtitle: 'Rozwiązałeś 12 quizów w tym tygodniu',
            time: '2 dni temu',
            isUnread: false,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

/// Notification section container
class _NotificationSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _NotificationSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

/// Notification switch widget
class _NotificationSwitch extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationSwitch({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }
}

/// Notification item widget
class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;

  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: isUnread
            ? Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
                width: 1,
              )
            : null,
        boxShadow: isUnread
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                            ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

