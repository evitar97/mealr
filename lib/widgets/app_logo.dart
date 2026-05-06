import 'package:flutter/cupertino.dart';

import '../app/app_state.dart';
import 'mealweight_mark.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MealWeightMark(size: 38, radius: 12),
        const SizedBox(width: 10),
        Text(
          'Mealr',
          style: TextStyle(
            color: p.text,
            fontSize: 29,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
      ],
    );
  }
}
