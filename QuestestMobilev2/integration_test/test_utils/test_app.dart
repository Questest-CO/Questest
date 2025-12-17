import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:questest/core/theme/app_theme.dart';

/// Test wrapper widget that provides all necessary providers for integration tests.
/// Allows overriding specific providers for testing purposes.
class TestApp extends StatelessWidget {
  const TestApp({
    super.key,
    required this.child,
    this.overrides = const [],
  });

  final Widget child;
  final List<Override> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        title: 'Questest Test',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: child,
      ),
    );
  }
}

/// Helper class for common test utilities
class TestHelpers {
  /// Pumps the widget tree and waits for all animations to complete
  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration duration = const Duration(milliseconds: 100),
  }) async {
    await tester.pumpAndSettle(duration);
  }

  /// Enters text into a text field identified by its label
  static Future<void> enterTextByLabel(
    WidgetTester tester,
    String label,
    String text,
  ) async {
    final textField = find.widgetWithText(TextFormField, label);
    await tester.enterText(textField, text);
    await tester.pump();
  }

  /// Taps a button with the given text
  static Future<void> tapButtonWithText(
    WidgetTester tester,
    String buttonText,
  ) async {
    final button = find.widgetWithText(ElevatedButton, buttonText);
    if (button.evaluate().isEmpty) {
      // Try finding in other button types
      final textButton = find.widgetWithText(TextButton, buttonText);
      if (textButton.evaluate().isNotEmpty) {
        await tester.tap(textButton);
      } else {
        final filledButton = find.widgetWithText(FilledButton, buttonText);
        await tester.tap(filledButton);
      }
    } else {
      await tester.tap(button);
    }
    await tester.pump();
  }

  /// Scrolls until an element is visible
  static Future<void> scrollUntilVisible(
    WidgetTester tester,
    Finder finder, {
    double delta = 100,
  }) async {
    await tester.scrollUntilVisible(
      finder,
      delta,
      scrollable: find.byType(Scrollable).first,
    );
  }

  /// Waits for a widget to appear with a timeout
  static Future<bool> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      await tester.pump(const Duration(milliseconds: 100));
      if (finder.evaluate().isNotEmpty) {
        return true;
      }
    }
    return false;
  }
}

