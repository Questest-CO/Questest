import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/answer_option_stat.dart';
import '../models/question_stats.dart';
import '../models/survey_stats.dart';

/// Provider for survey statistics (mocked for now).
/// Keeps async contract so it can be swapped to real API later.
final surveyStatsProvider = FutureProvider<SurveyStats>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 200));

  const questions = [
    QuestionStats(
      question: 'Jak oceniasz trudność ankiety?',
      totalResponses: 450,
      options: [
        AnswerOptionStat(label: 'Bardzo łatwa', count: 120),
        AnswerOptionStat(label: 'Raczej łatwa', count: 180),
        AnswerOptionStat(label: 'Średnia', count: 90),
        AnswerOptionStat(label: 'Trudna', count: 40),
        AnswerOptionStat(label: 'Bardzo trudna', count: 20),
      ],
    ),
    QuestionStats(
      question: 'Czy polecisz aplikację Questest znajomym?',
      totalResponses: 450,
      options: [
        AnswerOptionStat(label: 'Zdecydowanie tak', count: 260),
        AnswerOptionStat(label: 'Raczej tak', count: 120),
        AnswerOptionStat(label: 'Nie wiem', count: 40),
        AnswerOptionStat(label: 'Raczej nie', count: 20),
        AnswerOptionStat(label: 'Zdecydowanie nie', count: 10),
      ],
    ),
    QuestionStats(
      question: 'Na jakim urządzeniu najczęściej wypełniasz ankiety?',
      totalResponses: 450,
      options: [
        AnswerOptionStat(label: 'Telefon', count: 320),
        AnswerOptionStat(label: 'Tablet', count: 60),
        AnswerOptionStat(label: 'Laptop', count: 50),
        AnswerOptionStat(label: 'Desktop', count: 20),
      ],
    ),
  ];

  return const SurveyStats(
    surveyTitle: 'Ankieta: doświadczenia użytkowników',
    totalRespondents: 450,
    questions: questions,
  );
});


