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
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mealr',
              style: TextStyle(
                color: p.text,
                fontSize: 29,
                height: 1,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Plan. Prep. Eat.',
              style: TextStyle(
                color: p.muted,
                fontSize: 11,
                height: 1,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
