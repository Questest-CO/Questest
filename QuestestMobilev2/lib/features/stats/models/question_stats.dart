import 'answer_option_stat.dart';

/// Statistics for a single survey question.
class QuestionStats {
  const QuestionStats({
    required this.question,
    required this.options,
    required this.totalResponses,
  });

  /// Question text
  final String question;

  /// Options with counts/percentages
  final List<AnswerOptionStat> options;

  /// Total responses for this question
  final int totalResponses;
}


