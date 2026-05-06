import 'package:flutter_test/flutter_test.dart';

import 'package:mealweight_flutter/app/mealweight_app.dart';

void main() {
  testWidgets('Mealr app renders the shell', (WidgetTester tester) async {
    await tester.pumpWidget(const MealWeightApp());
    await tester.pump();

    expect(find.text('Mealr'), findsWidgets);
  });
}
