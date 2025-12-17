import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/oracle_providers.dart';
import '../../../core/models/oracle/oracle_user_dto.dart';
import '../../../core/models/oracle/filled_questionnaire_model.dart';
import '../models/ranking_entry.dart';

/// Provider that returns leaderboard entries calculated from Oracle data.
/// Fetches users and filled questionnaires, then aggregates scores.
final rankingProvider = FutureProvider<List<RankingEntry>>((ref) async {
  final repository = ref.watch(oracleRepositoryProvider);
  
  // Fetch both data sources concurrently
  final results = await Future.wait([
    repository.getUsers(),
    repository.getFilledQuestionnaires(),
  ]);
  
  final users = results[0] as List<OracleUserDto>;
  final filledQuestionnaires = results[1] as List<FilledQuestionnaireModel>;
  
  // Create user lookup map (filter out users with invalid id)
  final userMap = <int, OracleUserDto>{};
  for (final user in users) {
    if (user.id > 0) { // Skip users with invalid id (-1 or 0)
      userMap[user.id] = user;
    }
  }
  
  // Aggregate scores by user
  final scoreMap = <int, _UserScore>{};
  for (final filled in filledQuestionnaires) {
    final userId = filled.filledBy;
    final score = filled.resultId ?? 0;
    
    if (scoreMap.containsKey(userId)) {
      scoreMap[userId]!.totalScore += score;
      scoreMap[userId]!.quizzesTaken += 1;
    } else {
      scoreMap[userId] = _UserScore(
        userId: userId,
        totalScore: score,
        quizzesTaken: 1,
      );
    }
  }
  
  // Convert to list and sort by total score (descending)
  final sortedScores = scoreMap.values.toList()
    ..sort((a, b) => b.totalScore.compareTo(a.totalScore));
  
  // Map to RankingEntry with position
  final entries = <RankingEntry>[];
  for (int i = 0; i < sortedScores.length; i++) {
    final score = sortedScores[i];
    final user = userMap[score.userId];
    
    // Build display name - prioritize username from API
    String displayName;
    if (user != null) {
      if (user.username != null && user.username!.isNotEmpty) {
        displayName = user.username!;
      } else if (user.firstName != null || user.lastName != null) {
        displayName = '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
      } else if (user.name != null && user.name!.isNotEmpty) {
        displayName = user.name!;
      } else if (user.email != null && user.email!.isNotEmpty) {
        displayName = user.email!.split('@').first;
      } else {
        displayName = 'Użytkownik ${score.userId}';
      }
    } else {
      displayName = 'Użytkownik ${score.userId}';
    }
    
    // Generate avatar URL if not available
    String? avatarUrl = user?.avatarUrl;
    if (avatarUrl == null || avatarUrl.isEmpty) {
      // Use pravatar.cc with user ID for consistent avatars
      avatarUrl = 'https://i.pravatar.cc/150?u=${score.userId}';
    }
    
    entries.add(RankingEntry(
      position: i + 1,
      displayName: displayName,
      points: score.totalScore,
      quizzesPlayed: score.quizzesTaken,
      avatarUrl: avatarUrl,
      userEmail: user?.email,
    ));
  }
  
  // If no data, return empty list
  if (entries.isEmpty) {
    return [];
  }
  
  return entries;
});

/// Internal helper class for aggregating user scores
class _UserScore {
  final int userId;
  int totalScore;
  int quizzesTaken;
  
  _UserScore({
    required this.userId,
    required this.totalScore,
    required this.quizzesTaken,
  });
}
