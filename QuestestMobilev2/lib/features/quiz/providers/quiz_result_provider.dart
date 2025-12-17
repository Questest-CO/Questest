import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/oracle_providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../home/providers/quiz_provider.dart';

/// Provider for submitting quiz result to the backend
/// Automatically triggers when created
final submitQuizResultProvider = FutureProvider.autoDispose
    .family<void, SubmitQuizResultParams>((ref, params) async {
  final repository = ref.watch(oracleRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);

  try {
    await repository.submitFilledQuestionnaire(
      questionnaireId: params.quizId,
      filledBy: userId,
      resultId: params.scorePercentage.round(),
    );
  } on AppException {
    rethrow;
  }
});

/// Parameters for submitting quiz result
class SubmitQuizResultParams {
  final int quizId;
  final double scorePercentage;

  const SubmitQuizResultParams({
    required this.quizId,
    required this.scorePercentage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubmitQuizResultParams &&
          runtimeType == other.runtimeType &&
          quizId == other.quizId &&
          scorePercentage == other.scorePercentage;

  @override
  int get hashCode => quizId.hashCode ^ scorePercentage.hashCode;
}

