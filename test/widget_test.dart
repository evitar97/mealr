import 'package:flutter_test/flutter_test.dart';

import 'package:mealweight_flutter/app/arb_translations.dart';
import 'package:mealweight_flutter/app/mealweight_app.dart';

void main() {
  testWidgets('Mealful app renders the shell', (WidgetTester tester) async {
    await tester.pumpWidget(const MealWeightApp());
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump();

    expect(find.text('Mealful'), findsWidgets);
    expect(find.text('Start'), findsOneWidget);
  });

  test('translated recipe metadata does not leak English into Hungarian UI', () {
    final hungarian = arbTranslations['hu']!;

    expect(hungarian['Easy'], 'Könnyű');
    expect(hungarian['Medium'], 'Közepes');
    expect(hungarian['Advanced'], 'Haladó');
    expect(hungarian['Makrók megoszlása'], 'Makrók megoszlása');
    expect(hungarian['Új'], 'Új');
    expect(arbTranslations['en']!['Új'], 'New');
    expect(arbTranslations['de']!['Új'], 'Neu');
    expect(arbTranslations['es']!['Új'], 'Nuevo');
    expect(hungarian['Hozzáadás'], 'Hozzáadás');
    expect(arbTranslations['en']!['Hozzáadás'], 'Add');
    expect(arbTranslations['de']!['Hozzáadás'], 'Hinzufügen');
    expect(arbTranslations['es']!['Hozzáadás'], 'Añadir');
    expect(hungarian['Indulhat'], 'Kezdés');
    expect(arbTranslations['en']!['Indulhat'], 'Start');
    expect(arbTranslations['de']!['Indulhat'], 'Start');
    expect(arbTranslations['es']!['Indulhat'], 'Empezar');
    expect(arbTranslations['en']!['csipet'], 'pinch');
    expect(arbTranslations['de']!['csipet'], 'Prise');
    expect(arbTranslations['es']!['csipet'], 'pizca');
    expect(hungarian['Új mérés'], 'Új mérés');
    expect(arbTranslations['en']!['Új mérés'], 'New measurement');
    expect(arbTranslations['de']!['Rögzítés'], 'Eintragen');
    expect(arbTranslations['es']!['Rögzítés'], 'Registrar');
    expect(hungarian['Irányadó cél'], 'Irányadó cél');
    expect(arbTranslations['en']!['Mérések'], 'Entries');
    expect(
      arbTranslations['de']!['Rögzíts még egy mérést a trend megjelenítéséhez.'],
      'Füge einen weiteren Eintrag hinzu, um deinen Trend zu sehen.',
    );
    expect(
      arbTranslations['es']!['Csökkenő trend ebben az időszakban'],
      'Tendencia descendente en este periodo',
    );
    expect(hungarian['Toast'], 'Pirítós');
    expect(hungarian['Cream'], 'Krém');
    expect(hungarian['Burgur'], 'Bulgur');
    expect(hungarian['Candy'], 'Cukorka');
    expect(hungarian['Spinach'], 'Spenót');
    expect(hungarian['Dew'], 'Harmat');
    expect(arbTranslations['de']!['Spinach'], 'Spinat');
    expect(arbTranslations['es']!['Dew'], 'Rocío');
    expect(hungarian['ÜDV A MEALFUL-BEN'], 'ÜDV A MEALFUL-BEN');
    expect(arbTranslations['en']!['ÜDV A MEALFUL-BEN'], 'WELCOME TO MEALFUL');
    expect(
      arbTranslations['de']!['HOGYAN SEGÍT A MEALFUL?'],
      'WIE HILFT MEALFUL?',
    );
    expect(
      arbTranslations['es']!['HOGYAN SEGÍT A MEALFUL?'],
      '¿CÓMO AYUDA MEALFUL?',
    );
  });
}
