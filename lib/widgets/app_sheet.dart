import 'package:flutter/cupertino.dart';

import '../app/app_state.dart';
import 'glass_surface.dart';

class AppSheetFrame extends StatelessWidget {
  const AppSheetFrame({
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 18),
    this.margin = const EdgeInsets.fromLTRB(10, 0, 10, 8),
    this.maxHeightPadding = 20,
    this.scrollable = true,
    this.avoidKeyboard = false,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double maxHeightPadding;
  final bool scrollable;
  final bool avoidKeyboard;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.maybePop(context),
      child: SafeArea(
        top: false,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 210),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.only(
            bottom: avoidKeyboard ? MediaQuery.viewInsetsOf(context).bottom : 0,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final sheet = GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: GlassSurface(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight - maxHeightPadding,
                  ),
                  margin: margin,
                  padding: padding,
                  radius: 22,
                  tint: p.card,
                  opacity: 1,
                  borderColor: p.border.withValues(
                    alpha: state.isDark ? 0.50 : 0.24,
                  ),
                  child: scrollable
                      ? SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: child,
                        )
                      : child,
                ),
              );

              return Align(
                alignment: avoidKeyboard
                    ? Alignment.center
                    : Alignment.bottomCenter,
                child: sheet,
              );
            },
          ),
        ),
      ),
    );
  }
}

class AppKeyboardSheetPosition extends StatelessWidget {
  const AppKeyboardSheetPosition({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.maybePop(context),
      child: SafeArea(
        top: false,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 210),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => Align(
              alignment: const Alignment(0, -0.06),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: (constraints.maxHeight - 20)
                      .clamp(0, double.infinity)
                      .toDouble(),
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
