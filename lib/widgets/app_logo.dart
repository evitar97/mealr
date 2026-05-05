import 'package:flutter/cupertino.dart';

import '../app/app_state.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Text(
      'Mealr',
      style: TextStyle(
        color: p.text,
        fontSize: 29,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.0,
      ),
    );
  }
}
