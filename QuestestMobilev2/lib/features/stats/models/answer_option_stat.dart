/// Single answer option statistics (label + count/percentage)
class AnswerOptionStat {
  const AnswerOptionStat({
    required this.label,
    required this.count,
    this.percentage,
  });

  /// Option text displayed on chart
  final String label;

  /// How many respondents chose this option
  final int count;

  /// Optional precomputed percentage (0-100). If null, UI computes it.
  final double? percentage;
}


