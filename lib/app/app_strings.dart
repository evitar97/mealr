import 'package:flutter/widgets.dart';

import 'app_state.dart';
import 'arb_translations.dart';

String tx(BuildContext context, String source) {
  final state = AppScope.of(context);
  final languageCode = state.resolvedLanguageCode(context);
  return arbTranslations[languageCode]?[source] ??
      arbTranslations['en']?[source] ??
      source;
}

String txBmiCategory(BuildContext context, String category) =>
    switch (category) {
      'Sovány' => tx(context, 'Sovány'),
      'Normál súly' => tx(context, 'Normál súly'),
      'Túlsúlyos' => tx(context, 'Túlsúlyos'),
      'Obezitás' => tx(context, 'Obezitás'),
      _ => category,
    };
