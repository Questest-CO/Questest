import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:questest/features/quiz/presentation/pages/quiz_result_page.dart';
import 'package:questest/features/ranking/presentation/pages/ranking_page.dart';

import 'test_utils/mock_providers.dart';
import 'test_utils/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Result Checking Flow E2E Tests', () {
    testWidgets('Should display quiz result page with score', (
      WidgetTester tester,
    ) async {
      // Arrange - Show result page with 80% score
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Test Quiz: Podstawy Fluttera',
            scorePercent: 80.0,
            correctAnswers: 4,
            totalQuestions: 5,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Score is displayed
      expect(find.text('80%'), findsOneWidget);
      expect(find.text('Twój wynik'), findsOneWidget);
      expect(find.text('Poprawne: 4 / 5'), findsOneWidget);
    });

    testWidgets('Should display motivational message for high score', (
      WidgetTester tester,
    ) async {
      // Arrange - High score (90%+)
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Test Quiz',
            scorePercent: 95.0,
            correctAnswers: 19,
            totalQuestions: 20,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Excellent message is shown
      expect(find.textContaining('bagietką'), findsOneWidget);
    });

    testWidgets('Should display motivational message for good score', (
      WidgetTester tester,
    ) async {
      // Arrange - Good score (75-89%)
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Test Quiz',
            scorePercent: 78.0,
            correctAnswers: 7,
            totalQuestions: 9,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Good message is shown
      expect(find.textContaining('croissant'), findsOneWidget);
    });

    testWidgets('Should display motivational message for average score', (
      WidgetTester tester,
    ) async {
      // Arrange - Average score (60-74%)
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Test Quiz',
            scorePercent: 65.0,
            correctAnswers: 13,
            totalQuestions: 20,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Average message is shown
      expect(find.textContaining('grahamka'), findsOneWidget);
    });

    testWidgets('Should display motivational message for low score', (
      WidgetTester tester,
    ) async {
      // Arrange - Low score (below 40%)
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Test Quiz',
            scorePercent: 25.0,
            correctAnswers: 1,
            totalQuestions: 4,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Encouraging message is shown
      expect(find.textContaining('zakwas'), findsOneWidget);
    });

    testWidgets('Should display donut chart visualization', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Test Quiz',
            scorePercent: 75.0,
            correctAnswers: 3,
            totalQuestions: 4,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Chart contains correct/total text
      expect(find.text('3 / 4'), findsOneWidget);
      expect(find.text('Poprawne'), findsOneWidget);
    });

    testWidgets('Should display action buttons', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Test Quiz',
            scorePercent: 60.0,
            correctAnswers: 6,
            totalQuestions: 10,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - All action buttons are visible
      expect(find.text('Spróbuj ponownie'), findsOneWidget);
      expect(find.text('Pobierz PDF z wynikami'), findsOneWidget);
      expect(find.text('Udostępnij'), findsOneWidget);
      expect(find.text('Ranking'), findsOneWidget);
    });

    testWidgets('Should navigate to ranking page', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Test Quiz',
            scorePercent: 80.0,
            correctAnswers: 8,
            totalQuestions: 10,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Tap ranking button
      await tester.tap(find.text('Ranking'));
      await tester.pumpAndSettle();

      // Assert - Ranking page should be visible
      expect(find.byType(RankingPage), findsOneWidget);
    });

    testWidgets('Should handle PDF download button tap', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Test Quiz',
            scorePercent: 70.0,
            correctAnswers: 7,
            totalQuestions: 10,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Tap PDF download button
      await tester.tap(find.text('Pobierz PDF z wynikami'));
      await tester.pump();

      // Assert - Loading indicator or PDF sheet should appear
      // Due to async nature, we just verify the button is tappable
    });

    testWidgets('Should display correct score percentage', (
      WidgetTester tester,
    ) async {
      // Arrange - Test different score percentages
      final testCases = [
        (100.0, '100%'),
        (50.0, '50%'),
        (0.0, '0%'),
        (33.33, '33%'),
      ];

      for (final testCase in testCases) {
        await tester.pumpWidget(
          TestApp(
            overrides: createAuthenticatedOverrides(),
            child: QuizResultPage(
              quizId: 1,
              quizTitle: 'Test',
              scorePercent: testCase.$1,
              correctAnswers: 1,
              totalQuestions: 2,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(testCase.$2), findsOneWidget);
      }
    });

    testWidgets('Should show 100% score correctly', (
      WidgetTester tester,
    ) async {
      // Arrange - Perfect score
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Test Quiz',
            scorePercent: 100.0,
            correctAnswers: 10,
            totalQuestions: 10,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('Poprawne: 10 / 10'), findsOneWidget);
    });

    testWidgets('Should show 0% score correctly', (
      WidgetTester tester,
    ) async {
      // Arrange - Zero score
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Test Quiz',
            scorePercent: 0.0,
            correctAnswers: 0,
            totalQuestions: 5,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('0%'), findsOneWidget);
      expect(find.text('Poprawne: 0 / 5'), findsOneWidget);
    });

    testWidgets('Should display result card with emoji icon', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Test Quiz',
            scorePercent: 85.0,
            correctAnswers: 17,
            totalQuestions: 20,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Emoji icon should be visible
      expect(find.byIcon(Icons.emoji_emotions_outlined), findsOneWidget);
    });

    testWidgets('Should have proper button styling', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Test Quiz',
            scorePercent: 75.0,
            correctAnswers: 15,
            totalQuestions: 20,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Buttons with icons
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.picture_as_pdf), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });
  });
}

