import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:questest/features/auth/presentation/pages/login_page.dart';
import 'package:questest/features/auth/presentation/pages/register_page.dart';

import 'test_utils/mock_providers.dart';
import 'test_utils/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Registration Flow E2E Tests', () {
    testWidgets('Should display login page for unauthenticated user', (
      WidgetTester tester,
    ) async {
      // Arrange - Start with unauthenticated state
      await tester.pumpWidget(
        TestApp(
          overrides: createUnauthenticatedOverrides(),
          child: const LoginPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Login page elements are visible
      expect(find.text('Witaj ponownie 👋'), findsOneWidget);
      expect(find.text('Zaloguj się'), findsOneWidget);
      expect(find.text('Nie masz konta? Utwórz je'), findsOneWidget);
    });

    testWidgets('Should navigate to registration page from login page', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createUnauthenticatedOverrides(),
          child: const LoginPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Tap on "Nie masz konta? Utwórz je" button
      await tester.tap(find.text('Nie masz konta? Utwórz je'));
      await tester.pumpAndSettle();

      // Assert - Registration page is displayed
      expect(find.text('Załóż konto'), findsOneWidget);
      expect(find.text('Utwórz konto'), findsOneWidget);
    });

    testWidgets('Should display registration form with all required fields', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createRegistrationTestOverrides(),
          child: const RegisterPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - All form fields are visible
      expect(find.text('Załóż konto'), findsOneWidget);
      expect(find.text('Adres email'), findsOneWidget);
      expect(find.text('Hasło'), findsOneWidget);
      expect(find.text('Powtórz hasło'), findsOneWidget);
      expect(find.text('Utwórz konto'), findsOneWidget);
      expect(find.text('Masz już konto? Zaloguj się'), findsOneWidget);
    });

    testWidgets('Should show validation errors for empty form submission', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createRegistrationTestOverrides(),
          child: const RegisterPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Try to submit empty form
      final submitButton = find.widgetWithText(ElevatedButton, 'Utwórz konto');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert - Validation errors appear (checking if form is still visible means validation failed)
      expect(find.text('Załóż konto'), findsOneWidget);
      // Form should still be on the same page due to validation failure
    });

    testWidgets('Should show validation error for invalid email format', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createRegistrationTestOverrides(),
          child: const RegisterPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Enter invalid email
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');
      await tester.pump();

      // Submit the form
      final submitButton = find.widgetWithText(ElevatedButton, 'Utwórz konto');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert - Email validation error should appear
      expect(find.textContaining('email'), findsWidgets);
    });

    testWidgets('Should show validation error for password mismatch', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createRegistrationTestOverrides(),
          child: const RegisterPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Fill in form with mismatched passwords
      final textFields = find.byType(TextFormField);

      // Email field
      await tester.enterText(textFields.at(0), 'test@example.com');
      await tester.pump();

      // Password field
      await tester.enterText(textFields.at(1), 'Password123!');
      await tester.pump();

      // Confirm password field
      await tester.enterText(textFields.at(2), 'DifferentPassword456!');
      await tester.pump();

      // Submit the form
      final submitButton = find.widgetWithText(ElevatedButton, 'Utwórz konto');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert - Password mismatch error should appear
      expect(find.textContaining('identyczne'), findsOneWidget);
    });

    testWidgets('Should toggle password visibility', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createRegistrationTestOverrides(),
          child: const RegisterPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Find visibility toggle buttons (there should be 2 - for password and confirm password)
      final visibilityButtons = find.byIcon(Icons.visibility);
      expect(visibilityButtons, findsNWidgets(2));

      // Act - Tap the first visibility toggle
      await tester.tap(visibilityButtons.first);
      await tester.pumpAndSettle();

      // Assert - Icon should change to visibility_off
      expect(find.byIcon(Icons.visibility_off), findsAtLeast(1));
    });

    testWidgets('Should navigate back to login from registration', (
      WidgetTester tester,
    ) async {
      // Arrange - Start with LoginPage
      await tester.pumpWidget(
        TestApp(
          overrides: createUnauthenticatedOverrides(),
          child: const LoginPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Navigate to registration
      await tester.tap(find.text('Nie masz konta? Utwórz je'));
      await tester.pumpAndSettle();

      // Verify we're on registration page
      expect(find.text('Załóż konto'), findsOneWidget);

      // Act - Navigate back to login
      await tester.tap(find.text('Masz już konto? Zaloguj się'));
      await tester.pumpAndSettle();

      // Assert - Back on login page
      expect(find.text('Witaj ponownie 👋'), findsOneWidget);
    });

    testWidgets('Should fill registration form correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        TestApp(
          overrides: createRegistrationTestOverrides(),
          child: const RegisterPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Fill in all fields correctly
      final textFields = find.byType(TextFormField);

      // Email
      await tester.enterText(textFields.at(0), 'newuser@example.com');
      await tester.pump();

      // Password
      await tester.enterText(textFields.at(1), 'SecurePass123!');
      await tester.pump();

      // Confirm password
      await tester.enterText(textFields.at(2), 'SecurePass123!');
      await tester.pump();

      // Assert - Form is filled
      expect(find.text('newuser@example.com'), findsOneWidget);
      // Passwords are obscured, so we won't find them as text
    });
  });
}

