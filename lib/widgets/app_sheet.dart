import 'package:flutter/cupertino.dart';

import '../app/app_state.dart';
import 'glass_surface.dart';

class AppSheetFrame extends StatelessWidget {
  const AppSheetFrame({
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(18, 18, 18, 20),
    this.margin = const EdgeInsets.fromLTRB(10, 0, 10, 10),
    this.maxHeightPadding = 20,
    this.scrollable = true,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double maxHeightPadding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.maybePop(context),
      child: SafeArea(
        top: false,
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
                radius: 26,
                tint: p.card,
                opacity: 1,
                borderColor: p.border.withValues(
                  alpha: state.isDark ? 0.62 : 0.34,
                ),
                child: child,
              ),
            );

            return Align(
              alignment: Alignment.bottomCenter,
              child: scrollable
                  ? SingleChildScrollView(
                      padding: EdgeInsets.only(top: maxHeightPadding / 2),
                      child: sheet,
                    )
                  : sheet,
            );
          },
        ),
      ),
    );
  }
}
