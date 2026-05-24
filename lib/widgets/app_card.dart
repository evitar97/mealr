import 'package:flutter/cupertino.dart';

import '../app/app_state.dart';
import '../theme/app_typography.dart';
import 'glass_surface.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.color,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return GlassSurface(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: padding,
      radius: 16,
      tint: color ?? p.card,
      borderColor: p.border.withValues(alpha: state.isDark ? 0.58 : 0.30),
      child: child,
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 7),
      child: Text(
        label.toUpperCase(),
        style: MealText.section(
          state.isDark
              ? Color.alphaBlend(p.accent.withValues(alpha: 0.62), p.muted)
              : p.accentDim,
        ),
      ),
    );
  }
}
