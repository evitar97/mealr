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
import '../widgets/theme_picker_sheet.dart';

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
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      p.bg,
                      Color.alphaBlend(
                        p.accent.withValues(alpha: state.isDark ? 0.055 : 0.08),
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
      opacity: state.isDark ? 0.50 : 0.62,
      blur: 18,
      shadow: false,
      child: Row(
        children: [
          const AppLogo(),
          const Spacer(),
          _NavButton(
            icon: CupertinoIcons.info,
            onPressed: () => _showInfo(context),
          ),
          _NavButton(
            icon: state.isDark ? CupertinoIcons.sun_max : CupertinoIcons.moon,
            onPressed: state.toggleBrightness,
          ),
          _NavButton(
            icon: CupertinoIcons.square_grid_2x2,
            onPressed: () => _showThemePicker(context),
          ),
        ],
      ),
    );
  }

  void _showInfo(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => const _InfoSheet(),
    );
  }

  void _showThemePicker(BuildContext context) {
    showThemePickerSheet(context);
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
      child: CupertinoButton(
        minimumSize: const Size(40, 40),
        padding: EdgeInsets.zero,
        color: p.card.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(22),
        onPressed: onPressed,
        child: Icon(icon, size: 18, color: p.muted.withValues(alpha: 0.88)),
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
      p.card.withValues(alpha: state.isDark ? 0.78 : 0.92),
      Color.alphaBlend(
        p.accent.withValues(alpha: state.isDark ? 0.08 : 0.05),
        p.bg,
      ),
    );
    final dockBorder = Color.alphaBlend(
      p.accent.withValues(alpha: state.isDark ? 0.34 : 0.24),
      p.text.withValues(alpha: state.isDark ? 0.12 : 0.18),
    );
    return GlassSurface(
      radius: 999,
      padding: EdgeInsets.zero,
      tint: dockColor,
      opacity: 0.82,
      borderColor: dockBorder,
      blur: 26,
      child: SizedBox(
        height: AppLayout.bottomTabsHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
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
                      edge: _TabEdge.first,
                    ),
                    _TabItem(
                      state: state,
                      tab: AppTab.calories,
                      icon: CupertinoIcons.flame,
                      label: tx(context, 'Kalória'),
                      edge: _TabEdge.middle,
                    ),
                    _TabItem(
                      state: state,
                      tab: AppTab.bmi,
                      icon: CupertinoIcons.chart_bar_square,
                      label: 'BMI',
                      edge: _TabEdge.middle,
                    ),
                    _TabItem(
                      state: state,
                      tab: AppTab.profile,
                      icon: CupertinoIcons.person,
                      label: tx(context, 'Profil'),
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
    required this.edge,
  });

  final AppState state;
  final AppTab tab;
  final IconData icon;
  final String label;
  final _TabEdge edge;

  @override
  Widget build(BuildContext context) {
    final p = state.palette;
    final active = state.tab == tab;
    final color = active
        ? p.accent
        : Color.alphaBlend(
            p.text.withValues(alpha: state.isDark ? 0.28 : 0.32),
            p.border,
          );
    final radius = switch (edge) {
      _TabEdge.first => const BorderRadius.horizontal(
        left: Radius.circular(999),
        right: Radius.circular(14),
      ),
      _TabEdge.last => const BorderRadius.horizontal(
        left: Radius.circular(14),
        right: Radius.circular(999),
      ),
      _TabEdge.middle => BorderRadius.circular(14),
    };
    return Expanded(
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
                ? p.accent.withValues(alpha: state.isDark ? 0.18 : 0.15)
                : CupertinoColors.transparent,
            borderRadius: radius,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: active ? 23 : 21, color: color),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(
                        color: color,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
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
      color: const Color(0x99000000),
      child: SafeArea(
        child: Center(
          child: GlassSurface(
            constraints: const BoxConstraints(maxWidth: 520),
            margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
            radius: 26,
            tint: state.isDark ? p.card : p.bg,
            opacity: state.isDark ? 0.76 : 0.94,
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
                        TextSpan(text: tx(context, 'Főzés során az étel ')),
                        TextSpan(
                          text: tx(context, 'veszít a tömegéből'),
                          style: TextStyle(
                            color: p.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: tx(context, ', de ')),
                        TextSpan(
                          text: tx(context, 'nem a kalóriájából.'),
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
