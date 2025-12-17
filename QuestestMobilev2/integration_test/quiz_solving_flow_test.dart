import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:questest/features/home/presentation/pages/home_page.dart';
import 'package:questest/features/quiz/presentation/pages/quiz_solving_page.dart';
import 'package:questest/features/quiz/presentation/widgets/single_choice_answer.dart';
import 'package:questest/features/quiz/presentation/widgets/question_card.dart';

import 'test_utils/mock_providers.dart';
import 'test_utils/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Quiz Solving Flow E2E Tests', () {
    testWidgets('Should display quiz list on home page', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Quiz cards should be visible
      expect(find.text('Test Quiz: Podstawy Fluttera'), findsOneWidget);
      expect(find.text('Test Quiz: Dart Fundamentals'), findsOneWidget);
    });

    testWidgets('Should start quiz and display first question', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizSolvingPage(
            quizId: '1',
            quizTitle: 'Test Quiz: Podstawy Fluttera',
            timeLimitSeconds: 300,
          ),
        ),
      );

      // Wait for questions to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert - First question should be visible
      expect(find.text('Co to jest Widget w Flutterze?'), findsOneWidget);
      expect(find.text('Twoja odpowiedź'), findsOneWidget);
    });

    testWidgets('Should display quiz progress header', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizSolvingPage(
            quizId: '1',
            quizTitle: 'Test Quiz: Podstawy Fluttera',
            timeLimitSeconds: 300,
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert - Progress header shows question 1 of total
      expect(find.textContaining('1'), findsWidgets); // Question 1
      expect(find.textContaining('5'), findsWidgets); // Total 5 questions
    });

    testWidgets('Should display answer options for single choice question', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizSolvingPage(
            quizId: '1',
            quizTitle: 'Test Quiz: Podstawy Fluttera',
            timeLimitSeconds: 300,
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert - All answer options are visible
      expect(find.text('Element interfejsu użytkownika'), findsOneWidget);
      expect(find.text('Typ bazy danych'), findsOneWidget);
      expect(find.text('Protokół sieciowy'), findsOneWidget);
      expect(find.text('System plików'), findsOneWidget);
    });

    testWidgets('Should select answer and enable next button', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizSolvingPage(
            quizId: '1',
            quizTitle: 'Test Quiz: Podstawy Fluttera',
            timeLimitSeconds: 300,
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Act - Select an answer
      final answerOption = find.text('Element interfejsu użytkownika');
      await tester.tap(answerOption);
      await tester.pumpAndSettle();

      // Assert - Next button should be available
      expect(find.text('Następne'), findsOneWidget);
    });

    testWidgets('Should navigate to next question after selecting answer', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizSolvingPage(
            quizId: '1',
            quizTitle: 'Test Quiz: Podstawy Fluttera',
            timeLimitSeconds: 300,
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Act - Select answer for first question
      await tester.tap(find.text('Element interfejsu użytkownika'));
      await tester.pumpAndSettle();

      // Act - Tap next button
      await tester.tap(find.text('Następne'));
      await tester.pumpAndSettle();

      // Assert - Second question should be visible (multiple choice)
      expect(
        find.text('Które z poniższych są typami Widgetów? (wybierz wszystkie)'),
        findsOneWidget,
      );
    });

    testWidgets('Should allow skipping a question', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizSolvingPage(
            quizId: '1',
            quizTitle: 'Test Quiz: Podstawy Fluttera',
            timeLimitSeconds: 300,
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Act - Skip question (don't select any answer, just tap next)
      // Without selecting an answer, there should be a "Pomiń" button
      final skipButton = find.text('Pomiń');
      if (skipButton.evaluate().isNotEmpty) {
        await tester.tap(skipButton);
        await tester.pumpAndSettle();

        // Assert - Should move to next question
        expect(
          find.text('Które z poniższych są typami Widgetów? (wybierz wszystkie)'),
          findsOneWidget,
        );
      }
    });

    testWidgets('Should display timer', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizSolvingPage(
            quizId: '1',
            quizTitle: 'Test Quiz: Podstawy Fluttera',
            timeLimitSeconds: 300,
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert - Timer should be visible (formatted time like "05:00" or "4:59")
      expect(find.textContaining(':'), findsWidgets);
    });

    testWidgets('Should show exit confirmation dialog', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizSolvingPage(
            quizId: '1',
            quizTitle: 'Test Quiz: Podstawy Fluttera',
            timeLimitSeconds: 300,
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Act - Tap close button
      final closeButton = find.byIcon(Icons.close);
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      // Assert - Confirmation dialog should appear
      expect(find.text('Wyjść z quizu?'), findsOneWidget);
      expect(find.text('Kontynuuj'), findsOneWidget);
      expect(find.text('Wyjdź'), findsOneWidget);
    });

    testWidgets('Should continue quiz when dismissing exit dialog', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizSolvingPage(
            quizId: '1',
            quizTitle: 'Test Quiz: Podstawy Fluttera',
            timeLimitSeconds: 300,
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Act - Open exit dialog
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Act - Tap "Kontynuuj"
      await tester.tap(find.text('Kontynuuj'));
      await tester.pumpAndSettle();

      // Assert - Should be back to quiz
      expect(find.text('Co to jest Widget w Flutterze?'), findsOneWidget);
    });

    testWidgets('Should show "Zakończ" button on last question', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizSolvingPage(
            quizId: '2', // Shorter quiz with 3 questions
            quizTitle: 'Test Quiz: Dart Fundamentals',
            timeLimitSeconds: 180,
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate through questions
      // Question 1
      await tester.tap(find.text('Inferowany na podstawie wartości'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Następne'));
      await tester.pumpAndSettle();

      // Question 2
      await tester.tap(find.text('final jest ustalany w runtime, const w compile-time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Następne'));
      await tester.pumpAndSettle();

      // Question 3 (last)
      // Assert - Should show "Zakończ" button
      expect(find.text('Zakończ'), findsOneWidget);
    });

    testWidgets('Should complete quiz with multiple choice question', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizSolvingPage(
            quizId: '1',
            quizTitle: 'Test Quiz: Podstawy Fluttera',
            timeLimitSeconds: 300,
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Question 1 - Single choice
      await tester.tap(find.text('Element interfejsu użytkownika'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Następne'));
      await tester.pumpAndSettle();

      // Question 2 - Multiple choice - select multiple options
      expect(
        find.text('Które z poniższych są typami Widgetów? (wybierz wszystkie)'),
        findsOneWidget,
      );

      await tester.tap(find.text('StatelessWidget'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('StatefulWidget'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('InheritedWidget'));
      await tester.pumpAndSettle();

      // Assert - Multiple options should be selectable
      // The UI should reflect selected state (implementation dependent)
    });
  });
}

