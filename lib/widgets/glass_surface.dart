import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../app/app_state.dart';

class GlassSurface extends StatelessWidget {
  const GlassSurface({
    required this.child,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.radius = 22,
    this.tint,
    this.borderColor,
    this.blur = 22,
    this.opacity,
    this.shadow = true,
    this.width,
    this.constraints,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double radius;
  final Color? tint;
  final Color? borderColor;
  final double blur;
  final double? opacity;
  final bool shadow;
  final double? width;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final fillOpacity = opacity ?? (state.isDark ? 0.58 : 0.72);
    final fill = (tint ?? p.card).withValues(alpha: fillOpacity);
    final stroke =
        borderColor ?? p.text.withValues(alpha: state.isDark ? 0.10 : 0.18);

    return Container(
      width: width,
      constraints: constraints,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: const Color(
                    0xFF000000,
                  ).withValues(alpha: state.isDark ? 0.28 : 0.10),
                  blurRadius: 28,
                  spreadRadius: -10,
                  offset: const Offset(0, 18),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: stroke, width: 1),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CupertinoColors.white.withValues(
                    alpha: state.isDark ? 0.08 : 0.36,
                  ),
                  fill,
                  p.accent.withValues(alpha: state.isDark ? 0.045 : 0.035),
                ],
                stops: const [0, 0.46, 1],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
