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
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: state.isDark ? const Color(0xFF080604) : const Color(0xFFFFF3E2),
        borderRadius: BorderRadius.circular(cornerRadius),
        border: Border.all(color: p.border.withValues(alpha: 0.78), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: p.accent.withValues(alpha: state.isDark ? 0.24 : 0.16),
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
