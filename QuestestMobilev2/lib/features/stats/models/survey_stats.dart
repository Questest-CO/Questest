import 'question_stats.dart';

/// Aggregated statistics for a survey/poll.
class SurveyStats {
  const SurveyStats({
    required this.surveyTitle,
    required this.totalRespondents,
    required this.questions,
  });

  /// Survey title displayed at top of screen
  final String surveyTitle;

  /// Total number of respondents
  final int totalRespondents;

  /// List of per-question statistics
  final List<QuestionStats> questions;
}


