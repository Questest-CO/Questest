// Test widgetu Questest
// 
// Podstawowy test sprawdzający czy aplikacja startuje poprawnie

import 'package:flutter_test/flutter_test.dart';
import 'package:questest/main.dart';

void main() {
  testWidgets('Questest app smoke test', (WidgetTester tester) async {
    // Uruchom aplikację
    await tester.pumpWidget(const QuestestApp());
    await tester.pumpAndSettle();

    // Sprawdź czy aplikacja się uruchomiła
    // i wyświetla dolną nawigację
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
