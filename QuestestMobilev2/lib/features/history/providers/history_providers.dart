import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/oracle_providers.dart';
import '../../../core/models/oracle/filled_questionnaire_model.dart';
import '../../home/providers/quiz_provider.dart';

/// Provider for fetching user's quiz history from Oracle
final historyProvider = FutureProvider<List<HistoryItem>>((ref) async {
  final repository = ref.watch(oracleRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  // Fetch all filled questionnaires
  final filledQuestionnaires = await repository.getFilledQuestionnaires();
  
  // Filter by current user and convert to HistoryItem
  final userHistory = filledQuestionnaires
      .where((fq) => fq.filledBy == userId && fq.filledBy > 0)
      .map((fq) => HistoryItem(
            id: fq.id,
            quizId: fq.questionnaireId,
            quizTitle: 'Quiz #${fq.questionnaireId}',
            dateFilled: fq.dateFilled,
            score: fq.resultId,
          ))
      .toList();
  
  // Sort by date descending (newest first)
  userHistory.sort((a, b) {
    if (a.dateFilled == null && b.dateFilled == null) return 0;
    if (a.dateFilled == null) return 1;
    if (b.dateFilled == null) return -1;
    return b.dateFilled!.compareTo(a.dateFilled!);
  });
  
  return userHistory;
});

/// Model representing a single history entry
class HistoryItem {
  final int id;
  final int quizId;
  final String quizTitle;
  final DateTime? dateFilled;
  final int? score;

  const HistoryItem({
    required this.id,
    required this.quizId,
    required this.quizTitle,
    this.dateFilled,
    this.score,
  });
  
  String get formattedDate {
    if (dateFilled == null) return 'Brak daty';
    return '${dateFilled!.day.toString().padLeft(2, '0')}.'
           '${dateFilled!.month.toString().padLeft(2, '0')}.'
           '${dateFilled!.year} '
           '${dateFilled!.hour.toString().padLeft(2, '0')}:'
           '${dateFilled!.minute.toString().padLeft(2, '0')}';
  }
  
  String get scoreText {
    if (score == null) return 'Brak wyniku';
    return '$score%';
  }
}

