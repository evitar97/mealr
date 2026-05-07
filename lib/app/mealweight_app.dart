import 'package:flutter/cupertino.dart';

import 'app_layout.dart';
import 'app_state.dart';
import 'app_strings.dart';
import '../features/onboarding/onboarding_overlay.dart';
import '../widgets/app_logo.dart';
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
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return CupertinoPageScaffold(
      backgroundColor: p.bg,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.82),
                    radius: 1.18,
                    colors: [
                      Color.alphaBlend(
                        p.accent.withValues(alpha: state.isDark ? 0.17 : 0.16),
                        p.bg,
                      ),
                      Color.alphaBlend(
                        p.card.withValues(alpha: state.isDark ? 0.08 : 0.26),
                        p.bg,
                      ),
                      p.bg,
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                _TopBar(state: state),
                Expanded(child: _CurrentScreen(tab: state.tab)),
              ],
            ),
            Positioned(
              left: 28,
              right: 28,
              bottom: bottomInset + 8,
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final p = state.palette;
    return GlassSurface(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 8,
        left: 20,
        right: 16,
        bottom: 12,
      ),
      radius: 0,
      tint: p.bg,
      opacity: 1,
      blur: 18,
      shadow: false,
      borderColor: p.bg,
      child: Row(
        children: [
          const AppLogo(),
          const Spacer(),
          _NavButton(
            icon: CupertinoIcons.info,
            onPressed: () => _showInfo(context),
          ),
        ],
      ),
    );
  }

  void _showInfo(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      barrierColor: const Color(0x99000000),
      builder: (context) => const _InfoSheet(),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: SpringPressable(
        child: CupertinoButton(
          minimumSize: const Size(40, 40),
          padding: EdgeInsets.zero,
          color: p.resultBg,
          borderRadius: BorderRadius.circular(14),
          onPressed: onPressed,
          child: Icon(icon, size: 18, color: p.accent.withValues(alpha: 0.92)),
        ),
      ),
    );
  }
}

class _BottomTabs extends StatelessWidget {
  const _BottomTabs({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final p = state.palette;
    final dockColor = Color.alphaBlend(
      p.card.withValues(alpha: 1),
      Color.alphaBlend(
        p.accent.withValues(alpha: state.isDark ? 0.06 : 0.02),
        p.bg,
      ),
    );
    final dockBorder = Color.alphaBlend(
      p.accent.withValues(alpha: state.isDark ? 0.38 : 0.18),
      p.border.withValues(alpha: state.isDark ? 0.32 : 0.28),
    );
    return GlassSurface(
      radius: 22,
      padding: EdgeInsets.zero,
      tint: dockColor,
      opacity: 1,
      borderColor: dockBorder,
      blur: 0,
      child: SizedBox(
        height: AppLayout.bottomTabsHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: dockColor)),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _TabItem(
                      state: state,
                      tab: AppTab.foods,
                      icon: CupertinoIcons.list_bullet,
                      label: tx(context, 'Lista'),
                      color: const Color(0xFFB9572C),
                      edge: _TabEdge.first,
                    ),
                    _TabItem(
                      state: state,
                      tab: AppTab.calories,
                      icon: CupertinoIcons.flame,
                      label: tx(context, 'Kalória'),
                      color: const Color(0xFFD98228),
                      edge: _TabEdge.middle,
                    ),
                    _TabItem(
                      state: state,
                      tab: AppTab.bmi,
                      icon: CupertinoIcons.chart_bar_square,
                      label: 'BMI',
                      color: const Color(0xFFA98A2B),
                      edge: _TabEdge.middle,
                    ),
                    _TabItem(
                      state: state,
                      tab: AppTab.profile,
                      icon: CupertinoIcons.person,
                      label: tx(context, 'Profil'),
                      color: const Color(0xFF9D704A),
                      edge: _TabEdge.last,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _TabEdge { first, middle, last }

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.state,
    required this.tab,
    required this.icon,
    required this.label,
    required this.color,
    required this.edge,
  });

  final AppState state;
  final AppTab tab;
  final IconData icon;
  final String label;
  final Color color;
  final _TabEdge edge;

  @override
  Widget build(BuildContext context) {
    final p = state.palette;
    final active = state.tab == tab;
    final tabColor = active
        ? color
        : Color.alphaBlend(
            color.withValues(alpha: state.isDark ? 0.90 : 0.82),
            p.card,
          );
    final contourColor = state.isDark
        ? CupertinoColors.black.withValues(alpha: 0.54)
        : p.text.withValues(alpha: 0.22);
    final radius = switch (edge) {
      _TabEdge.first => const BorderRadius.horizontal(
        left: Radius.circular(18),
        right: Radius.circular(8),
      ),
      _TabEdge.last => const BorderRadius.horizontal(
        left: Radius.circular(8),
        right: Radius.circular(18),
      ),
      _TabEdge.middle => BorderRadius.circular(8),
    };
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
            decoration: BoxDecoration(
              color: active
                  ? Color.alphaBlend(
                      color.withValues(alpha: state.isDark ? 0.18 : 0.16),
                      p.resultBg,
                    )
                  : CupertinoColors.transparent,
              borderRadius: radius,
              border: Border.all(
                color: active
                    ? color.withValues(alpha: state.isDark ? 0.54 : 0.30)
                    : CupertinoColors.transparent,
                width: 1,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: active ? 24 : 22,
                      color: tabColor,
                      shadows: [
                        Shadow(
                          color: contourColor,
                          blurRadius: 0,
                          offset: const Offset(0, 0.7),
                        ),
                        Shadow(
                          color: tabColor.withValues(
                            alpha: active ? 0.20 : 0.12,
                          ),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        maxLines: 1,
                        style: TextStyle(
                          color: tabColor,
                          fontSize: 11.5,
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.w600,
                          letterSpacing: 0,
                          shadows: [
                            Shadow(
                              color: contourColor.withValues(alpha: 0.55),
                              blurRadius: 0,
                              offset: const Offset(0, 0.45),
                            ),
                          ],
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

class _InfoSheet extends StatelessWidget {
  const _InfoSheet();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final bodyColor = state.isDark ? p.muted : p.text.withValues(alpha: 0.74);
    return Container(
      color: CupertinoColors.transparent,
      child: SafeArea(
        child: Center(
          child: GlassSurface(
            constraints: const BoxConstraints(maxWidth: 520),
            margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
            radius: 26,
            tint: state.isDark ? p.card : p.bg,
            opacity: 1,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: p.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          'i',
                          style: TextStyle(
                            color: p.buttonText,
                            fontSize: 26,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          tx(context, 'Hogyan működik?'),
                          style: TextStyle(
                            color: p.text,
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        minimumSize: const Size(34, 34),
                        padding: EdgeInsets.zero,
                        color: p.bg,
                        borderRadius: BorderRadius.circular(20),
                        onPressed: () => Navigator.pop(context),
                        child: Icon(
                          CupertinoIcons.xmark,
                          color: p.muted,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: bodyColor,
                        fontSize: 16,
                        height: 1.48,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: tx(context, 'Főzés során az étel tömege '),
                        ),
                        TextSpan(
                          text: tx(context, 'csökkenhet vagy növekedhet'),
                          style: TextStyle(
                            color: p.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: tx(context, ', de ettől ')),
                        TextSpan(
                          text: tx(context, 'nem változik a kalóriája.'),
                          style: TextStyle(
                            color: p.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: tx(
                            context,
                            ' Ha a kész súlyt írod be a kalóriaszámlálóba, téves értéket kapsz.',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _InfoStepCard(
                    number: '1',
                    title: tx(context, 'Nyers adag'),
                    bodyBeforeBold: tx(
                      context,
                      'Add össze a száraz, nyers hozzávalókat főzés ',
                    ),
                    bold: tx(context, 'előtt'),
                    bodyAfterBold: tx(context, ' – ezt mérd le és írd be.'),
                  ),
                  const SizedBox(height: 10),
                  _InfoStepCard(
                    number: '2',
                    title: tx(context, 'Kész étel súlya'),
                    bodyBeforeBold: tx(
                      context,
                      'Ha megfőzted vagy megsütötted az ételt, mérd le az ',
                    ),
                    bold: tx(context, 'össztömeget'),
                    bodyAfterBold: tx(context, ' és írd be ide.'),
                  ),
                  const SizedBox(height: 10),
                  _InfoStepCard(
                    number: '3',
                    title: tx(context, 'Kimért adag'),
                    bodyBeforeBold: tx(
                      context,
                      'Ha enni szeretnél, mérd le a tányérodra kerülő adagot és írd be – megkapod a ',
                    ),
                    bold: tx(context, 'nyers egyenértéket.'),
                    bodyAfterBold: '',
                    boldAccent: true,
                  ),
                  const SizedBox(height: 14),
                  const _InfoFormulaCard(),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: p.accent,
                      borderRadius: BorderRadius.circular(16),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        tx(context, 'Bezárás'),
                        style: TextStyle(
                          color: p.buttonText,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoStepCard extends StatelessWidget {
  const _InfoStepCard({
    required this.number,
    required this.title,
    required this.bodyBeforeBold,
    required this.bold,
    required this.bodyAfterBold,
    this.boldAccent = false,
  });

  final String number;
  final String title;
  final String bodyBeforeBold;
  final String bold;
  final String bodyAfterBold;
  final bool boldAccent;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final bodyColor = state.isDark ? p.muted : p.text.withValues(alpha: 0.72);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 15),
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.border.withValues(alpha: 0.72)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: p.accent, shape: BoxShape.circle),
            child: Text(
              number,
              style: TextStyle(
                color: p.buttonText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: bodyColor,
                  fontSize: 15,
                  height: 1.42,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: '$title\n',
                    style: TextStyle(
                      color: p.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: bodyBeforeBold),
                  TextSpan(
                    text: bold,
                    style: TextStyle(
                      color: boldAccent ? p.accent : p.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: bodyAfterBold),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoFormulaCard extends StatelessWidget {
  const _InfoFormulaCard();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final bodyColor = state.isDark ? p.muted : p.text.withValues(alpha: 0.72);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.accent.withValues(alpha: 0.38)),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: bodyColor,
            fontSize: 14.5,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(
              text: tx(context, 'Képlet: '),
              style: TextStyle(
                color: p.accent,
                fontSize: 16.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: tx(context, 'nyers ÷ kész × kimért =\nnyers egyenérték\n'),
              style: TextStyle(
                color: p.accent,
                fontSize: 16.5,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            TextSpan(
              text: tx(
                context,
                '→ Ezt a számot írd be a kalóriaszámlálódba\n(pl. MyFitnessPal, Cronometer stb.)',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
