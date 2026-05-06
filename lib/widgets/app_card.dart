import 'package:flutter/cupertino.dart';

import '../app/app_state.dart';
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
      radius: 18,
      tint: color ?? p.card,
      borderColor: p.border.withValues(alpha: state.isDark ? 0.56 : 0.36),
      child: child,
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: p.accent.withValues(alpha: 0.82),
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
