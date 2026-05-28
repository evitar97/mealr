import 'package:flutter/cupertino.dart';

import '../app/app_state.dart';
import '../theme/app_typography.dart';
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
              'Mealful',
              style: MealText.largeTitle(
                p.text,
              ).copyWith(height: 1, letterSpacing: 0),
            ),
            const SizedBox(height: 3),
            Text(
              'Plan. Prep. Eat.',
              style: MealText.section(
                p.muted,
              ).copyWith(height: 1, letterSpacing: 1.05),
            ),
          ],
        ),
      ],
    );
  }
}
