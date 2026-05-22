import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_layout.dart';
import 'app_state.dart';
import 'app_strings.dart';
import '../l10n/app_localizations.dart';
import '../features/onboarding/onboarding_overlay.dart';
import '../features/bmi/bmi_screen.dart';
import '../features/calorie/calorie_screen.dart';
import '../features/food/food_list_screen.dart';
import '../features/profile/profile_screen.dart';
import '../widgets/glass_surface.dart';
import '../widgets/mealweight_mark.dart';
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
            locale: state.localeOverride,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            theme: CupertinoThemeData(
              brightness: state.isDark ? Brightness.dark : Brightness.light,
              primaryColor: p.accent,
              scaffoldBackgroundColor: p.bg,
              barBackgroundColor: state.chromeSurface,
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
      backgroundColor: state.chromeSurface,
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
                        p.accent.withValues(alpha: state.isDark ? 0.025 : 0.02),
                        p.bg,
                      ),
                      Color.alphaBlend(
                        p.card.withValues(alpha: state.isDark ? 0.025 : 0.08),
                        p.bg,
                      ),
                      Color.alphaBlend(
                        p.card.withValues(alpha: state.isDark ? 0.015 : 0.04),
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
    final dockColor = state.chromeSurface;
    final dockBorder = state.chromeBorder;
    return GlassSurface(
      radius: 0,
      padding: EdgeInsets.zero,
      tint: dockColor,
      opacity: 1,
      borderColor: CupertinoColors.transparent,
      blur: 0,
      shadow: false,
      child: Container(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          top: 4,
          bottom: MediaQuery.paddingOf(context).bottom + 2,
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
                Positioned.fill(child: ColoredBox(color: dockColor)),
                Padding(
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      _TabItem(
                        state: state,
                        tab: AppTab.foods,
                        icon: CupertinoIcons.square_grid_2x2,
                        label: tx(context, 'Ételek'),
                      ),
                      _TabItem(
                        state: state,
                        tab: AppTab.calories,
                        icon: CupertinoIcons.flame,
                        label: tx(context, 'Kalória'),
                      ),
                      _TabItem(
                        state: state,
                        tab: AppTab.bmi,
                        icon: CupertinoIcons.chart_bar_square,
                        label: 'BMI',
                      ),
                      _TabItem(
                        state: state,
                        tab: AppTab.profile,
                        icon: CupertinoIcons.person,
                        label: tx(context, 'Profil'),
                      ),
                      _ProTabItem(state: state),
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
  });

  final AppState state;
  final AppTab tab;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = state.palette;
    final active = state.tab == tab;
    final inactiveColor = state.isDark
        ? const Color(0xFFA5AAA6)
        : const Color(0xFF757A76);
    final tabColor = active ? p.accent : inactiveColor;
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
              child: Transform.translate(
                offset: const Offset(0, 3),
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
      ),
    );
  }
}

class _ProTabItem extends StatelessWidget {
  const _ProTabItem({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final p = state.palette;
    final labelColor = state.isDark
        ? const Color(0xFFA5AAA6)
        : const Color(0xFF757A76);
    final proColor = state.isPro ? p.accent : labelColor;
    return Expanded(
      child: SpringPressable(
        pressedScale: 0.92,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            showProPaywallSheet(context);
          },
          child: SizedBox(
            height: double.infinity,
            child: Center(
              child: Transform.translate(
                offset: const Offset(0, 3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const MealWeightMark(size: 27, radius: 9),
                          Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              width: 12,
                              height: 12,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: state.chromeSurface,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: proColor.withValues(alpha: 0.72),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                state.isPro
                                    ? CupertinoIcons.check_mark
                                    : CupertinoIcons.lock_fill,
                                size: 7,
                                color: proColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Pro',
                          maxLines: 1,
                          style: TextStyle(
                            color: proColor,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
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
