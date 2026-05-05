import 'package:flutter/cupertino.dart';

import '../app/app_state.dart';

class MealWeightMark extends StatelessWidget {
  const MealWeightMark({super.key, this.size = 44, this.radius});

  final double size;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    final cornerRadius = radius ?? size * 0.28;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: p.bg.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(cornerRadius),
        border: Border.all(color: p.accent.withValues(alpha: 0.20)),
        boxShadow: [
          BoxShadow(
            color: p.accent.withValues(alpha: 0.12),
            blurRadius: size * 0.18,
            offset: Offset(0, size * 0.04),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius),
        child: Padding(
          padding: EdgeInsets.all(size * 0.12),
          child: Image.asset(
            'assets/brand/mealr_ui_icon.png',
            width: size * 0.76,
            height: size * 0.76,
            fit: BoxFit.contain,
            color: p.accent,
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
