import 'package:flutter/cupertino.dart';

import '../app/app_state.dart';

class MealWeightMark extends StatelessWidget {
  const MealWeightMark({super.key, this.size = 44, this.radius});

  final double size;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final cornerRadius = radius ?? size * 0.28;
    final surfaceColor = state.isDark
        ? Color.alphaBlend(p.accent.withValues(alpha: 0.06), p.card)
        : Color.alphaBlend(p.accent.withValues(alpha: 0.04), p.bg);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(cornerRadius),
        border: Border.all(
          color: p.border.withValues(alpha: state.isDark ? 0.62 : 0.46),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: p.accent.withValues(alpha: state.isDark ? 0.18 : 0.12),
            blurRadius: size * 0.22,
            offset: Offset(0, size * 0.06),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius),
        child: Image.asset(
          state.isDark
              ? 'assets/brand/mealr_dark.png'
              : 'assets/brand/mealr_light.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
