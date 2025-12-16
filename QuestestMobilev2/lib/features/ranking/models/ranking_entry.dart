/// Single entry in leaderboard / ranking list
class RankingEntry {
  const RankingEntry({
    required this.position,
    required this.displayName,
    required this.points,
    required this.quizzesPlayed,
    this.avatarUrl,
    this.userEmail,
  });

  /// Position in ranking (1-based)
  final int position;

  /// Display name of player
  final String displayName;

  /// Total score / points earned
  final int points;

  /// Number of solved quizzes/exams
  final int quizzesPlayed;

  /// Optional avatar URL
  final String? avatarUrl;

  /// Optional user email to match current user
  final String? userEmail;

  /// Indicates if the ranking entry belongs to current user
  bool belongsTo(String? email) {
    if (email == null || email.isEmpty || userEmail == null) {
      return false;
    }
    return userEmail!.toLowerCase() == email.toLowerCase();
  }
}

