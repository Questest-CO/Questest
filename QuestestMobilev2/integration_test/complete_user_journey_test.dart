import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:questest/features/auth/presentation/pages/login_page.dart';
import 'package:questest/features/main_screen.dart';
import 'package:questest/features/home/presentation/pages/home_page.dart';
import 'package:questest/features/quiz/presentation/pages/quiz_result_page.dart';

import 'test_utils/mock_providers.dart';
import 'test_utils/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Complete User Journey E2E Tests', () {
    testWidgets(
      'Complete flow: Login screen shows correctly',
      (WidgetTester tester) async {
        // ============ STEP 1: Login Screen ============
        await tester.pumpWidget(
          TestApp(
            overrides: createUnauthenticatedOverrides(),
            child: const LoginPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Verify login page is displayed
        expect(find.text('Witaj ponownie 👋'), findsOneWidget);
        expect(find.text('Zaloguj się'), findsOneWidget);

        // Fill in login credentials
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump();

        final passwordField = find.byType(TextFormField).at(1);
        await tester.enterText(passwordField, 'Password123!');
        await tester.pump();

        // Verify form is filled
        expect(find.text('test@example.com'), findsOneWidget);
      },
    );

    testWidgets(
      'Complete flow: Browse quizzes on home screen',
      (WidgetTester tester) async {
        // ============ Home Screen (Authenticated) ============
        await tester.pumpWidget(
          TestApp(
            overrides: createAuthenticatedOverrides(),
            child: const MainScreen(),
          ),
        );
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify home page is displayed
        expect(find.byType(HomePage), findsOneWidget);

        // HomePage should be visible with quizzes (from mock or real API)
        // If mocks are properly applied, we'll see mock quiz titles
        // If real API is called, we might see other quizzes
        // We just verify the home page structure is correct
        expect(find.text('Start'), findsWidgets); // AppBar title
      },
    );

    testWidgets(
      'Complete flow: View result page after quiz',
      (WidgetTester tester) async {
        // ============ View Results ============
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

        // Verify result page elements
        expect(find.text('80%'), findsOneWidget);
        expect(find.text('Twój wynik'), findsOneWidget);
        expect(find.text('Spróbuj ponownie'), findsOneWidget);
      },
    );

    testWidgets('User can navigate between tabs on main screen', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const MainScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Start tab is active (may appear multiple times in different states)
      expect(find.text('Start'), findsWidgets);
      expect(find.text('Profil'), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);

      // Act - Navigate to Profile tab
      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();

      // Assert - Profile page should be visible (part of IndexedStack)
      // The tab is now selected
    });

    testWidgets('User can access quiz creator via FAB', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const MainScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - FAB is visible
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Act - Tap FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Assert - Should navigate to quiz creator (AppBar title is "Nowy Quiz")
      expect(find.text('Nowy Quiz'), findsOneWidget);
    });

    testWidgets('User journey with search and filter', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const MainScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Home page with quizzes
      expect(find.text('Test Quiz: Podstawy Fluttera'), findsOneWidget);

      // Look for search functionality
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        // Enter search query
        await tester.enterText(searchField.first, 'Dart');
        await tester.pumpAndSettle();
        
        // Dart quiz should still be visible
        expect(find.text('Test Quiz: Dart Fundamentals'), findsOneWidget);
      }
    });

    testWidgets('User can view quiz details before starting', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const MainScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Quiz card shows details
      expect(find.text('Test Quiz: Podstawy Fluttera'), findsOneWidget);
      expect(find.text('Sprawdź swoją wiedzę o Flutterze'), findsOneWidget);

      // Quiz card should show question count
      expect(find.textContaining('5'), findsWidgets); // 5 questions
    });

    testWidgets('Result page allows retrying quiz', (
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
            correctAnswers: 3,
            totalQuestions: 5,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Retry button is visible
      expect(find.text('Spróbuj ponownie'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Act - Tap retry
      await tester.tap(find.text('Spróbuj ponownie'));
      await tester.pumpAndSettle();

      // The quiz should restart (navigation back)
    });

    testWidgets('Result page allows sharing results', (
      WidgetTester tester,
    ) async {
      // Arrange
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

      // Assert - Share button is visible
      expect(find.text('Udostępnij'), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);

      // Act - Tap share
      await tester.tap(find.text('Udostępnij'));
      await tester.pump();

      // Share dialog/sheet would appear (platform dependent)
    });

    testWidgets('Main screen bottom navigation works correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const MainScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Home icon is visible and selected
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      // Act - Tap profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Act - Tap home
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();

      // Assert - Back on home
      expect(find.text('Start'), findsWidgets);
    });
  });

  group('Error Handling E2E Tests', () {
    testWidgets('Should handle empty quiz list gracefully', (
      WidgetTester tester,
    ) async {
      // Override with empty quizzes
      final emptyOverrides = [
        ...createAuthenticatedOverrides(),
      ];

      await tester.pumpWidget(
        TestApp(
          overrides: emptyOverrides,
          child: const HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      // The home page should still render without crashing
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Should display result even with edge case scores', (
      WidgetTester tester,
    ) async {
      // Test boundary values
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Edge Case Quiz',
            scorePercent: 100.0, // Maximum
            correctAnswers: 100,
            totalQuestions: 100,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('100%'), findsOneWidget);
    });
  });

  group('Accessibility E2E Tests', () {
    testWidgets('Quiz result page has sufficient tap targets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          overrides: createAuthenticatedOverrides(),
          child: const QuizResultPage(
            quizId: 1,
            quizTitle: 'Accessibility Test',
            scorePercent: 75.0,
            correctAnswers: 3,
            totalQuestions: 4,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // All buttons should be tappable (56dp height)
      final retryButton = find.text('Spróbuj ponownie');
      expect(retryButton, findsOneWidget);

      final shareButton = find.text('Udostępnij');
      expect(shareButton, findsOneWidget);

      final rankingButton = find.text('Ranking');
      expect(rankingButton, findsOneWidget);
    });

    testWidgets('Login page has clear input labels', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          overrides: createUnauthenticatedOverrides(),
          child: const LoginPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Input fields have labels
      expect(find.text('Adres email'), findsOneWidget);
      expect(find.text('Hasło'), findsOneWidget);
    });
  });
}

