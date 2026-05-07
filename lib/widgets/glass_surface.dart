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
    final fillOpacity = opacity ?? 1;
    final fill = (tint ?? p.card).withValues(alpha: fillOpacity);
    final stroke =
        borderColor ?? p.border.withValues(alpha: state.isDark ? 0.56 : 0.34);

    final surface = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: stroke, width: 1.15),
      ),
      child: child,
    );
    final shouldBlur = blur > 0 && fillOpacity < 1;

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
                  ).withValues(alpha: state.isDark ? 0.18 : 0.06),
                  blurRadius: 10,
                  spreadRadius: -8,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: shouldBlur
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: surface,
              )
            : surface,
      ),
    );
  }
}
