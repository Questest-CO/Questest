import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/oracle_providers.dart';
import '../../home/providers/quiz_provider.dart';

/// Provider for user statistics
final userStatsProvider = FutureProvider<UserStats>((ref) async {
  final repository = ref.watch(oracleRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  try {
    // Fetch filled questionnaires to calculate stats
    final filledQuestionnaires = await repository.getFilledQuestionnaires();
    
    // Filter by current user
    final userQuestionnaires = filledQuestionnaires
        .where((fq) => fq.filledBy == userId && fq.filledBy > 0)
        .toList();
    
    final quizzesCompleted = userQuestionnaires.length;
    
    // Calculate points based on results
    int totalPoints = 0;
    for (final fq in userQuestionnaires) {
      if (fq.resultId != null && fq.resultId! > 0) {
        totalPoints += fq.resultId! * 10; // Example: score * 10 = points
      }
    }
    
    // Generate achievements based on stats
    final achievements = _generateAchievements(quizzesCompleted, totalPoints);
    
    return UserStats(
      quizzesCompleted: quizzesCompleted,
      totalPoints: totalPoints,
      achievements: achievements,
    );
  } catch (e) {
    // Return empty stats on error
    return const UserStats(
      quizzesCompleted: 0,
      totalPoints: 0,
      achievements: [],
    );
  }
});

/// Generate achievements based on user stats
List<Achievement> _generateAchievements(int quizzes, int points) {
  final achievements = <Achievement>[];
  
  // Quiz-based achievements
  if (quizzes >= 1) {
    achievements.add(Achievement(
      id: 'first_quiz',
      name: 'Pierwszy krok',
      description: 'Ukończ swój pierwszy quiz',
      emoji: '🎯',
      color: const Color(0xFF3498DB),
      isUnlocked: true,
    ));
  }
  
  if (quizzes >= 5) {
    achievements.add(Achievement(
      id: 'quiz_5',
      name: 'Na dobrej drodze',
      description: 'Ukończ 5 quizów',
      emoji: '⭐',
      color: const Color(0xFFF39C12),
      isUnlocked: true,
    ));
  }
  
  if (quizzes >= 10) {
    achievements.add(Achievement(
      id: 'quiz_10',
      name: 'Quiz Master',
      description: 'Ukończ 10 quizów',
      emoji: '🏆',
      color: const Color(0xFF9B59B6),
      isUnlocked: true,
    ));
  }
  
  if (quizzes >= 25) {
    achievements.add(Achievement(
      id: 'quiz_25',
      name: 'Quiz Expert',
      description: 'Ukończ 25 quizów',
      emoji: '👑',
      color: const Color(0xFFE74C3C),
      isUnlocked: true,
    ));
  }
  
  // Points-based achievements
  if (points >= 100) {
    achievements.add(Achievement(
      id: 'points_100',
      name: 'Kolekcjoner',
      description: 'Zdobądź 100 punktów',
      emoji: '💎',
      color: const Color(0xFF1ABC9C),
      isUnlocked: true,
    ));
  }
  
  if (points >= 500) {
    achievements.add(Achievement(
      id: 'points_500',
      name: 'Bogacz',
      description: 'Zdobądź 500 punktów',
      emoji: '💰',
      color: const Color(0xFF27AE60),
      isUnlocked: true,
    ));
  }
  
  return achievements;
}

/// User stats model
class UserStats {
  final int quizzesCompleted;
  final int totalPoints;
  final List<Achievement> achievements;
  
  const UserStats({
    required this.quizzesCompleted,
    required this.totalPoints,
    required this.achievements,
  });
}

/// Achievement model
class Achievement {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final Color color;
  final bool isUnlocked;
  
  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.color,
    required this.isUnlocked,
  });
}

/// Notification settings provider
final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((ref) {
  return NotificationSettingsNotifier();
});

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(const NotificationSettings());
  
  void toggleQuizReminders(bool value) {
    state = state.copyWith(quizReminders: value);
  }
  
  void toggleNewQuizzes(bool value) {
    state = state.copyWith(newQuizzes: value);
  }
  
  void toggleAchievements(bool value) {
    state = state.copyWith(achievements: value);
  }
  
  void toggleWeeklyStats(bool value) {
    state = state.copyWith(weeklyStats: value);
  }
}

class NotificationSettings {
  final bool quizReminders;
  final bool newQuizzes;
  final bool achievements;
  final bool weeklyStats;
  
  const NotificationSettings({
    this.quizReminders = true,
    this.newQuizzes = true,
    this.achievements = true,
    this.weeklyStats = false,
  });
  
  NotificationSettings copyWith({
    bool? quizReminders,
    bool? newQuizzes,
    bool? achievements,
    bool? weeklyStats,
  }) {
    return NotificationSettings(
      quizReminders: quizReminders ?? this.quizReminders,
      newQuizzes: newQuizzes ?? this.newQuizzes,
      achievements: achievements ?? this.achievements,
      weeklyStats: weeklyStats ?? this.weeklyStats,
    );
  }
}

/// App settings provider
final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(const AppSettings());
  
  void toggleDarkMode(bool value) {
    state = state.copyWith(darkMode: value);
  }
  
  void setLanguage(String language) {
    state = state.copyWith(language: language);
  }
  
  void toggleSoundEffects(bool value) {
    state = state.copyWith(soundEffects: value);
  }
  
  void toggleHapticFeedback(bool value) {
    state = state.copyWith(hapticFeedback: value);
  }
}

class AppSettings {
  final bool darkMode;
  final String language;
  final bool soundEffects;
  final bool hapticFeedback;
  
  const AppSettings({
    this.darkMode = false,
    this.language = 'Polski',
    this.soundEffects = true,
    this.hapticFeedback = true,
  });
  
  AppSettings copyWith({
    bool? darkMode,
    String? language,
    bool? soundEffects,
    bool? hapticFeedback,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      soundEffects: soundEffects ?? this.soundEffects,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
    );
  }
}

