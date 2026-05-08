import 'package:flutter/cupertino.dart';

import 'app_layout.dart';
import 'app_state.dart';
import 'app_strings.dart';
import '../features/onboarding/onboarding_overlay.dart';
import '../features/bmi/bmi_screen.dart';
import '../features/calorie/calorie_screen.dart';
import '../features/food/food_list_screen.dart';
import '../features/profile/profile_screen.dart';
import '../widgets/glass_surface.dart';
import '../widgets/spring_pressable.dart';

class MealWeightApp extends StatefulWidget {
  const MealWeightApp({super.key});

  @override
  State<MealWeightApp> createState() => _MealWeightAppState();
}

class _MealWeightAppState extends State<MealWeightApp> {
  final AppState state = AppState();

  @override
  void initState() {
    super.initState();
    state.loadSavedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          final p = state.palette;
          return CupertinoApp(
            debugShowCheckedModeBanner: false,
            title: 'Mealr',
            theme: CupertinoThemeData(
              brightness: state.isDark ? Brightness.dark : Brightness.light,
              primaryColor: p.accent,
              scaffoldBackgroundColor: p.bg,
              textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(
                  color: p.text,
                  fontFamily: '.SF Pro Text',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            home: MealWeightShell(
              key: ValueKey('${state.theme.id}-${state.isDark}'),
            ),
          );
        },
      ),
    );
  }
}

class MealWeightShell extends StatelessWidget {
  const MealWeightShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return CupertinoPageScaffold(
      backgroundColor: p.bg,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0, 0.34, 0.72, 1],
                    colors: [
                      Color.alphaBlend(
                        p.accent.withValues(alpha: state.isDark ? 0.15 : 0.10),
                        p.bg,
                      ),
                      Color.alphaBlend(
                        p.card.withValues(alpha: state.isDark ? 0.18 : 0.34),
                        p.bg,
                      ),
                      Color.alphaBlend(
                        p.card.withValues(alpha: state.isDark ? 0.08 : 0.16),
                        p.bg,
                      ),
                      p.bg,
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [Expanded(child: _CurrentScreen(tab: state.tab))],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomTabs(state: state),
            ),
            if (state.showOnboarding) const OnboardingOverlay(),
          ],
        ),
      ),
    );
  }
}

class _CurrentScreen extends StatelessWidget {
  const _CurrentScreen({required this.tab});

  final AppTab tab;

  @override
  Widget build(BuildContext context) {
    return switch (tab) {
      AppTab.foods => const FoodListScreen(),
      AppTab.calories => const CalorieScreen(),
      AppTab.bmi => const BmiScreen(),
      AppTab.profile => const ProfileScreen(),
    };
  }
}

class _BottomTabs extends StatelessWidget {
  const _BottomTabs({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final p = state.palette;
    final dockColor = Color.alphaBlend(
      p.card,
      Color.alphaBlend(
        p.accent.withValues(alpha: state.isDark ? 0.05 : 0.02),
        p.bg,
      ),
    );
    final dockBorder = Color.alphaBlend(
      p.accent.withValues(alpha: state.isDark ? 0.30 : 0.14),
      p.border.withValues(alpha: state.isDark ? 0.26 : 0.22),
    );
    return GlassSurface(
      radius: 0,
      padding: EdgeInsets.zero,
      tint: dockColor,
      opacity: state.isDark ? 0.86 : 0.92,
      borderColor: CupertinoColors.transparent,
      blur: 18,
      shadow: false,
      child: Container(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          top: 8,
          bottom: MediaQuery.paddingOf(context).bottom + 6,
        ),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: dockBorder, width: 1)),
        ),
        child: SizedBox(
          height: AppLayout.bottomTabsHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(
                    color: dockColor.withValues(
                      alpha: state.isDark ? 0.22 : 0.16,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      _TabItem(
                        state: state,
                        tab: AppTab.foods,
                        icon: CupertinoIcons.square_grid_2x2,
                        label: 'Meals',
                        color: const Color(0xFF3A9A62),
                      ),
                      _TabItem(
                        state: state,
                        tab: AppTab.calories,
                        icon: CupertinoIcons.flame,
                        label: tx(context, 'Kalória'),
                        color: const Color(0xFFE0842F),
                      ),
                      _TabItem(
                        state: state,
                        tab: AppTab.bmi,
                        icon: CupertinoIcons.chart_bar_square,
                        label: 'BMI',
                        color: const Color(0xFFC2A43B),
                      ),
                      _TabItem(
                        state: state,
                        tab: AppTab.profile,
                        icon: CupertinoIcons.person,
                        label: tx(context, 'Profil'),
                        color: const Color(0xFF58A9C8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.state,
    required this.tab,
    required this.icon,
    required this.label,
    required this.color,
  });

  final AppState state;
  final AppTab tab;
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final p = state.palette;
    final active = state.tab == tab;
    final tabColor = active
        ? color
        : Color.alphaBlend(color.withValues(alpha: 0.42), p.muted);
    return Expanded(
      child: SpringPressable(
        pressedScale: 0.92,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            state.selectTab(tab);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            height: double.infinity,
            decoration: const BoxDecoration(color: CupertinoColors.transparent),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (tab == AppTab.foods)
                      _MealTabGlyph(color: tabColor, size: active ? 27 : 25)
                    else
                      Icon(icon, size: active ? 25 : 23, color: tabColor),
                    const SizedBox(height: 3),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        maxLines: 1,
                        style: TextStyle(
                          color: tabColor,
                          fontSize: 11.5,
                          fontWeight: active
                              ? FontWeight.w800
                              : FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MealTabGlyph extends StatelessWidget {
  const _MealTabGlyph({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _MealTabGlyphPainter(color)),
    );
  }
}

class _MealTabGlyphPainter extends CustomPainter {
  const _MealTabGlyphPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width * 0.085;
    final fill = Paint()
      ..color = color.withValues(alpha: 0.14)
      ..style = PaintingStyle.fill;

    final rim = Rect.fromLTWH(
      size.width * 0.16,
      size.height * 0.56,
      size.width * 0.68,
      size.height * 0.13,
    );
    canvas.drawOval(rim, stroke);
    final bowlPath = Path()
      ..moveTo(size.width * 0.16, size.height * 0.61)
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.94,
        size.width * 0.84,
        size.height * 0.61,
      );
    canvas.drawPath(bowlPath, stroke);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.22, size.height * 0.64)
        ..quadraticBezierTo(
          size.width * 0.50,
          size.height * 0.81,
          size.width * 0.78,
          size.height * 0.64,
        )
        ..lineTo(size.width * 0.74, size.height * 0.71)
        ..quadraticBezierTo(
          size.width * 0.50,
          size.height * 0.86,
          size.width * 0.26,
          size.height * 0.71,
        )
        ..close(),
      fill,
    );

    final forkX = size.width * 0.25;
    canvas.drawLine(
      Offset(forkX, size.height * 0.18),
      Offset(forkX, size.height * 0.56),
      stroke,
    );
    for (final dx in [-0.075, 0.0, 0.075]) {
      canvas.drawLine(
        Offset(forkX + size.width * dx, size.height * 0.14),
        Offset(forkX + size.width * dx, size.height * 0.30),
        stroke,
      );
    }

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.50, size.height * 0.22),
        width: size.width * 0.16,
        height: size.height * 0.22,
      ),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.34),
      Offset(size.width * 0.50, size.height * 0.58),
      stroke,
    );

    canvas.drawLine(
      Offset(size.width * 0.76, size.height * 0.16),
      Offset(size.width * 0.66, size.height * 0.56),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.80, size.height * 0.18),
      Offset(size.width * 0.72, size.height * 0.45),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _MealTabGlyphPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
