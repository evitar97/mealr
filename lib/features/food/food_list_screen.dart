import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../app/app_layout.dart';
import '../../app/app_state.dart';
import '../../app/app_strings.dart';
import '../../models/food_item.dart';
import '../../models/meal_prep_plan.dart';
import '../../models/recipe.dart';
import '../../models/shopping_list.dart';
import '../../services/share_service.dart';
import '../../utils/calculators.dart';
import '../../widgets/app_card.dart';
import '../../widgets/glass_surface.dart';
import '../../widgets/mealweight_mark.dart';
import '../../widgets/spring_pressable.dart';
import 'recipe_library.dart';

const _headlineSerifFamily = 'Georgia';
const _headlineSerifFallback = ['Times New Roman', 'Times'];
final _greetingMottoSeed = DateTime.now().microsecondsSinceEpoch;

TextStyle _headlineSerifStyle({
  required Color color,
  required double fontSize,
  FontWeight fontWeight = FontWeight.w600,
  double? height,
  double? letterSpacing,
}) {
  return TextStyle(
    color: color,
    fontFamily: _headlineSerifFamily,
    fontFamilyFallback: _headlineSerifFallback,
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    letterSpacing: letterSpacing,
  );
}

class FoodListScreen extends StatelessWidget {
  const FoodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final mainFoods = state.foods
        .where((food) => food.category == FoodCategory.main)
        .toList();
    final sideFoods = state.foods
        .where((food) => food.category == FoodCategory.side)
        .toList();
    final canAddFood = state.canAddAnyFood;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        AppLayout.screenBottomPadding,
      ),
      children: [
        const _MealGreeting(),
        const SizedBox(height: 16),
        if (!state.isPro) ...[
          _FreeLimitStrip(
            mainCount: mainFoods.length,
            sideCount: sideFoods.length,
          ),
          const SizedBox(height: 14),
        ],
        SectionLabel(tx(context, 'Főételek')),
        if (mainFoods.isEmpty)
          const _EmptyFoodMessage('No main dishes added yet.'),
        for (final food in mainFoods) FoodTile(food: food),
        SectionLabel(tx(context, 'Köretek')),
        if (sideFoods.isEmpty)
          const _EmptyFoodMessage('No side dishes added yet.'),
        for (final food in sideFoods) FoodTile(food: food),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _ActionPillButton(
                icon: CupertinoIcons.plus,
                label: tx(context, 'Új étel'),
                enabled: canAddFood,
                onPressed: () => showCupertinoModalPopup<void>(
                  context: context,
                  barrierColor: const Color(0x99000000),
                  builder: (_) => const AddFoodSheet(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionPillButton(
                icon: CupertinoIcons.archivebox,
                label: tx(context, 'Meal Prep+'),
                enabled: true,
                onPressed: () => Navigator.of(context).push(
                  CupertinoPageRoute<void>(
                    builder: (_) => const MealPrepScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _ActionPillButton(
          icon: state.isPro
              ? CupertinoIcons.cart_badge_plus
              : CupertinoIcons.lock,
          label: tx(context, 'Bevásárlás+'),
          enabled: state.isPro,
          onPressed: state.isPro
              ? () => Navigator.of(context).push(
                  CupertinoPageRoute<void>(
                    builder: (_) => const ShoppingListScreen(),
                  ),
                )
              : () => showProPaywallSheet(context),
        ),
        const SizedBox(height: 16),
        SectionLabel(tx(context, 'Receptek')),
        const _PeekReveal(
          expandedHeight: 78,
          peekHeight: 59,
          child: _RecipeCategoryStrip(),
        ),
        const SizedBox(height: 12),
        SectionLabel(tx(context, 'Étrendek')),
        const _PeekReveal(
          expandedHeight: 76,
          peekHeight: 46,
          child: _DietPlanStrip(),
        ),
        if (!state.isPro) ...[
          const SizedBox(height: 16),
          const ProCompactUpsellCard(),
        ],
      ],
    );
  }
}

class _PeekReveal extends StatefulWidget {
  const _PeekReveal({
    required this.child,
    required this.expandedHeight,
    required this.peekHeight,
  });

  final Widget child;
  final double expandedHeight;
  final double peekHeight;

  @override
  State<_PeekReveal> createState() => _PeekRevealState();
}

class _PeekRevealState extends State<_PeekReveal> {
  bool _expanded = false;

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeOutCubic,
        height: _expanded ? widget.expandedHeight : widget.peekHeight,
        child: ClipRect(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: IgnorePointer(
                  ignoring: !_expanded,
                  child: OverflowBox(
                    alignment: Alignment.topCenter,
                    minHeight: widget.expandedHeight,
                    maxHeight: widget.expandedHeight,
                    child: SizedBox(
                      height: widget.expandedHeight,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
              if (!_expanded)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 12,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            p.bg.withValues(alpha: 0),
                            p.bg.withValues(alpha: 0.94),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeCategoryStrip extends StatelessWidget {
  const _RecipeCategoryStrip();

  @override
  Widget build(BuildContext context) {
    final categories = [
      _RecipeCategory(
        icon: _RecipeCategoryIcon.breakfast,
        label: tx(context, 'Reggeli'),
        onPressed: () => Navigator.of(context).push(
          CupertinoPageRoute<void>(
            builder: (_) => const RecipeListScreen(
              title: 'Reggeli',
              recipes: breakfastRecipes,
            ),
          ),
        ),
      ),
      _RecipeCategory(
        icon: _RecipeCategoryIcon.lunch,
        label: tx(context, 'Ebéd'),
        onPressed: () => Navigator.of(context).push(
          CupertinoPageRoute<void>(
            builder: (_) =>
                const RecipeListScreen(title: 'Ebéd', recipes: lunchRecipes),
          ),
        ),
      ),
      _RecipeCategory(
        icon: _RecipeCategoryIcon.dinner,
        label: tx(context, 'Vacsora'),
        onPressed: () => Navigator.of(context).push(
          CupertinoPageRoute<void>(
            builder: (_) => const RecipeListScreen(
              title: 'Vacsora',
              recipes: dinnerRecipes,
            ),
          ),
        ),
      ),
      _RecipeCategory(
        icon: _RecipeCategoryIcon.snack,
        label: tx(context, 'Nasi'),
        onPressed: () => Navigator.of(context).push(
          CupertinoPageRoute<void>(
            builder: (_) =>
                const RecipeListScreen(title: 'Nasi', recipes: snackRecipes),
          ),
        ),
      ),
    ];

    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) =>
            _RecipeCategoryPill(category: categories[index]),
      ),
    );
  }
}

class _RecipeCategory {
  const _RecipeCategory({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final _RecipeCategoryIcon icon;
  final String label;
  final VoidCallback? onPressed;
}

enum _RecipeCategoryIcon { breakfast, lunch, dinner, snack }

class _RecipeCategoryPill extends StatelessWidget {
  const _RecipeCategoryPill({required this.category});

  final _RecipeCategory category;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: category.onPressed,
      child: SpringPressable(
        enabled: category.onPressed != null,
        child: Container(
          width: 86,
          padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
          decoration: BoxDecoration(
            color: p.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: p.border.withValues(alpha: 0.82)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: CustomPaint(
                  painter: _RecipeCategoryIconPainter(
                    icon: category.icon,
                    color: _recipeCategoryIconColor(category.icon),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  category.label,
                  maxLines: 1,
                  style: TextStyle(
                    color: p.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _recipeCategoryIconColor(_RecipeCategoryIcon icon) {
  return switch (icon) {
    _RecipeCategoryIcon.breakfast => const Color(0xFF9A6846),
    _RecipeCategoryIcon.lunch => const Color(0xFF4F8B62),
    _RecipeCategoryIcon.dinner => const Color(0xFFC7A040),
    _RecipeCategoryIcon.snack => const Color(0xFFC65F68),
  };
}

class _RecipeCategoryIconPainter extends CustomPainter {
  const _RecipeCategoryIconPainter({required this.icon, required this.color});

  final _RecipeCategoryIcon icon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width * 0.075;
    final fill = Paint()
      ..color = color.withValues(alpha: 0.14)
      ..style = PaintingStyle.fill;

    switch (icon) {
      case _RecipeCategoryIcon.breakfast:
        _paintCup(canvas, size, stroke, fill);
      case _RecipeCategoryIcon.lunch:
        _paintPlate(canvas, size, stroke, fill);
      case _RecipeCategoryIcon.dinner:
        _paintMoon(canvas, size, stroke, fill);
      case _RecipeCategoryIcon.snack:
        _paintBerry(canvas, size, stroke, fill);
    }
  }

  void _paintCup(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final cup = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.18,
        size.height * 0.42,
        size.width * 0.46,
        size.height * 0.30,
      ),
      Radius.circular(size.width * 0.08),
    );
    canvas.drawRRect(cup, fill);
    canvas.drawRRect(cup, stroke);
    canvas.drawArc(
      Rect.fromLTWH(
        size.width * 0.56,
        size.height * 0.45,
        size.width * 0.24,
        size.height * 0.22,
      ),
      -1.2,
      2.4,
      false,
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.16, size.height * 0.78),
      Offset(size.width * 0.70, size.height * 0.78),
      stroke,
    );
    for (final x in [0.32, 0.47]) {
      canvas.drawPath(
        Path()
          ..moveTo(size.width * x, size.height * 0.16)
          ..cubicTo(
            size.width * (x - 0.08),
            size.height * 0.26,
            size.width * (x + 0.08),
            size.height * 0.30,
            size.width * x,
            size.height * 0.38,
          ),
        stroke,
      );
    }
  }

  void _paintPlate(Canvas canvas, Size size, Paint stroke, Paint fill) {
    canvas.drawCircle(size.center(Offset.zero), size.width * 0.24, fill);
    canvas.drawCircle(size.center(Offset.zero), size.width * 0.24, stroke);
    canvas.drawCircle(size.center(Offset.zero), size.width * 0.12, stroke);

    final forkX = size.width * 0.16;
    canvas.drawLine(
      Offset(forkX, size.height * 0.24),
      Offset(forkX, size.height * 0.76),
      stroke,
    );
    for (final dx in [-0.045, 0.0, 0.045]) {
      canvas.drawLine(
        Offset(forkX + size.width * dx, size.height * 0.20),
        Offset(forkX + size.width * dx, size.height * 0.36),
        stroke,
      );
    }

    canvas.drawLine(
      Offset(size.width * 0.84, size.height * 0.22),
      Offset(size.width * 0.84, size.height * 0.76),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.80, size.height * 0.22),
      Offset(size.width * 0.84, size.height * 0.42),
      stroke,
    );
  }

  void _paintMoon(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final moon = Path()
      ..moveTo(size.width * 0.62, size.height * 0.18)
      ..cubicTo(
        size.width * 0.36,
        size.height * 0.30,
        size.width * 0.34,
        size.height * 0.70,
        size.width * 0.64,
        size.height * 0.82,
      )
      ..cubicTo(
        size.width * 0.44,
        size.height * 0.88,
        size.width * 0.18,
        size.height * 0.70,
        size.width * 0.18,
        size.height * 0.48,
      )
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.26,
        size.width * 0.42,
        size.height * 0.10,
        size.width * 0.62,
        size.height * 0.18,
      );
    canvas.drawPath(moon, fill);
    canvas.drawPath(moon, stroke);
  }

  void _paintBerry(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final berry = Path()
      ..moveTo(size.width * 0.50, size.height * 0.27)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.30,
        size.width * 0.20,
        size.height * 0.72,
        size.width * 0.50,
        size.height * 0.86,
      )
      ..cubicTo(
        size.width * 0.80,
        size.height * 0.72,
        size.width * 0.78,
        size.height * 0.30,
        size.width * 0.50,
        size.height * 0.27,
      );
    canvas.drawPath(berry, fill);
    canvas.drawPath(berry, stroke);

    for (final seed in [
      const Offset(0.40, 0.48),
      const Offset(0.56, 0.48),
      const Offset(0.48, 0.62),
      const Offset(0.60, 0.68),
    ]) {
      canvas.drawCircle(
        Offset(size.width * seed.dx, size.height * seed.dy),
        size.width * 0.025,
        Paint()..color = color,
      );
    }

    final leaf = Path()
      ..moveTo(size.width * 0.50, size.height * 0.28)
      ..lineTo(size.width * 0.34, size.height * 0.16)
      ..moveTo(size.width * 0.50, size.height * 0.28)
      ..lineTo(size.width * 0.66, size.height * 0.16)
      ..moveTo(size.width * 0.50, size.height * 0.28)
      ..lineTo(size.width * 0.50, size.height * 0.12);
    canvas.drawPath(leaf, stroke);
  }

  @override
  bool shouldRepaint(covariant _RecipeCategoryIconPainter oldDelegate) {
    return oldDelegate.icon != icon || oldDelegate.color != color;
  }
}

class _DietPlanStrip extends StatelessWidget {
  const _DietPlanStrip();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final plans = [
      _DietPlanOption(
        calories: 1500,
        active: true,
        onPressed: state.isPro
            ? () => Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (_) => const DietPlanTypeScreen(calories: 1500),
                ),
              )
            : () => showProPaywallSheet(context),
      ),
      const _DietPlanOption(calories: 2000),
      const _DietPlanOption(calories: 2500),
      const _DietPlanOption(calories: 3000),
    ];

    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: plans.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) => _DietPlanPill(option: plans[index]),
      ),
    );
  }
}

class _DietPlanOption {
  const _DietPlanOption({
    required this.calories,
    this.active = false,
    this.onPressed,
  });

  final int calories;
  final bool active;
  final VoidCallback? onPressed;
}

class _DietPlanPill extends StatelessWidget {
  const _DietPlanPill({required this.option});

  final _DietPlanOption option;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    final enabled = option.active && option.onPressed != null;
    final locked = enabled && !AppScope.of(context).isPro;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: enabled ? option.onPressed : null,
      child: SpringPressable(
        enabled: enabled,
        child: Container(
          width: 94,
          padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
          decoration: BoxDecoration(
            color: enabled ? p.resultBg : p.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: enabled ? p.resultBorder : p.border.withValues(alpha: 0.8),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${option.calories}',
                style: TextStyle(
                  color: enabled ? p.accent : p.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'kcal',
                style: TextStyle(
                  color: p.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (locked || !enabled) ...[
                const SizedBox(height: 1),
                Text(
                  locked ? tx(context, 'Pro') : tx(context, 'Hamarosan'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: p.muted.withValues(alpha: 0.72),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyFoodMessage extends StatelessWidget {
  const _EmptyFoodMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 20),
      child: Text(
        message,
        style: TextStyle(
          color: p.muted.withValues(alpha: state.isDark ? 0.86 : 0.78),
          fontSize: 14,
          height: 1.25,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MealGreeting extends StatelessWidget {
  const _MealGreeting();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final greeting = _timeGreeting(DateTime.now());
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 10, 2, 0),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: Icon(greeting.icon, color: greeting.color, size: 36),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting.title,
                  style: TextStyle(
                    color: p.text,
                    fontSize: 24,
                    height: 1.05,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  greeting.subtitle,
                  style: TextStyle(
                    color: p.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const MealWeightMark(size: 44, radius: 14),
        ],
      ),
    );
  }
}

({String title, String subtitle, IconData icon, Color color}) _timeGreeting(
  DateTime now,
) {
  final hour = now.hour;
  if (hour >= 5 && hour < 11) {
    final mottos = [
      'Start simple, stay steady.',
      'Plan a calm, strong day.',
      'Build today one meal at a time.',
      'Fuel the morning with intention.',
      'Make the first choice an easy one.',
    ];
    return (
      title: 'Good morning',
      subtitle: _startupMotto(mottos),
      icon: CupertinoIcons.sun_max,
      color: const Color(0xFFC6A34A),
    );
  }
  if (hour >= 11 && hour < 14) {
    final mottos = [
      'Keep your meals on track.',
      'Small choices, solid momentum.',
      'Stay fueled and focused.',
      'Make the next meal easy.',
      'A steady plate keeps the day steady.',
    ];
    return (
      title: 'Good day',
      subtitle: _startupMotto(mottos),
      icon: CupertinoIcons.sun_max_fill,
      color: const Color(0xFF6FA77B),
    );
  }
  if (hour >= 14 && hour < 18) {
    final mottos = [
      'Prep what makes later easier.',
      'Set up dinner before the rush.',
      'A little prep goes a long way.',
      'Keep the afternoon light and useful.',
      'Give your evening a head start.',
    ];
    return (
      title: 'Good afternoon',
      subtitle: _startupMotto(mottos),
      icon: CupertinoIcons.cloud_sun,
      color: const Color(0xFFB98758),
    );
  }
  final mottos = [
    'Wrap up with something nourishing.',
    'Slow down, eat well, rest easy.',
    'Close the day with care.',
    'Tomorrow starts with tonight’s prep.',
    'End the day full, not rushed.',
  ];
  return (
    title: 'Good evening',
    subtitle: _startupMotto(mottos),
    icon: CupertinoIcons.moon_stars,
    color: const Color(0xFF8D94C6),
  );
}

String _startupMotto(List<String> mottos) {
  return mottos[_greetingMottoSeed % mottos.length];
}

const _highProtein1500Plans = [
  DietDayPlan(
    name: 'Erős nap',
    totalCalories: 1495,
    meals: [
      DietMeal(
        label: 'Reggeli',
        name: 'Protein zabkása bogyós gyümölccsel',
        calories: 430,
      ),
      DietMeal(
        label: 'Ebéd',
        name: 'Csirkés rizses fit bowl kisebb adagban',
        calories: 520,
      ),
      DietMeal(label: 'Vacsora', name: 'Könnyű csirkés saláta', calories: 410),
      DietMeal(label: 'Nasi', name: 'Protein joghurt pohár', calories: 135),
    ],
  ),
  DietDayPlan(
    name: 'Fitt nap',
    totalCalories: 1510,
    meals: [
      DietMeal(label: 'Reggeli', name: 'Pulykás tojásos wrap', calories: 470),
      DietMeal(
        label: 'Ebéd',
        name: 'Pulykás bolognai tészta light adagban',
        calories: 500,
      ),
      DietMeal(label: 'Vacsora', name: 'Sonkás sajtos omlett', calories: 420),
      DietMeal(
        label: 'Nasi',
        name: 'Fehérjés puding fél adag gyümölccsel',
        calories: 120,
      ),
    ],
  ),
];

const _glutenFree1500Plans = [
  DietDayPlan(
    name: 'Könnyű nap',
    totalCalories: 1500,
    meals: [
      DietMeal(
        label: 'Reggeli',
        name: 'Görög joghurtos granola pohár gluténmentes granolával',
        calories: 390,
      ),
      DietMeal(
        label: 'Ebéd',
        name: 'Csicseriborsó curry rizzsel',
        calories: 520,
      ),
      DietMeal(label: 'Vacsora', name: 'Sült hal zöldségágyon', calories: 390),
      DietMeal(
        label: 'Nasi',
        name: 'Almaszeletek mogyoróvajjal',
        calories: 200,
      ),
    ],
  ),
  DietDayPlan(
    name: 'Tiszta nap',
    totalCalories: 1490,
    meals: [
      DietMeal(label: 'Reggeli', name: 'Zöldséges omlett', calories: 340),
      DietMeal(label: 'Ebéd', name: 'Lazacos burgonyás ebéd', calories: 600),
      DietMeal(label: 'Vacsora', name: 'Garnélás quinoa bowl', calories: 430),
      DietMeal(label: 'Nasi', name: 'Hummuszos zöldségdoboz', calories: 120),
    ],
  ),
];

const _vegetarian1500Plans = [
  DietDayPlan(
    name: 'Zöld nap',
    totalCalories: 1495,
    meals: [
      DietMeal(
        label: 'Reggeli',
        name: 'Almás fahéjas overnight oats',
        calories: 410,
      ),
      DietMeal(label: 'Ebéd', name: 'Lencsés feta saláta', calories: 480),
      DietMeal(label: 'Vacsora', name: 'Tojásos zöldséges rizs', calories: 455),
      DietMeal(label: 'Nasi', name: 'Túrós bogyós tál', calories: 150),
    ],
  ),
  DietDayPlan(
    name: 'Friss nap',
    totalCalories: 1505,
    meals: [
      DietMeal(label: 'Reggeli', name: 'Túrós zabpalacsinta', calories: 360),
      DietMeal(
        label: 'Ebéd',
        name: 'Tofus zöldséges noodle box',
        calories: 520,
      ),
      DietMeal(
        label: 'Vacsora',
        name: 'Cottage cheese zöldségtál',
        calories: 350,
      ),
      DietMeal(label: 'Nasi', name: 'Banános kakaós falatok', calories: 275),
    ],
  ),
];

const _quick1500Plans = [
  DietDayPlan(
    name: 'Tempós nap',
    totalCalories: 1485,
    meals: [
      DietMeal(
        label: 'Reggeli',
        name: 'Banános mogyoróvajas smoothie',
        calories: 455,
      ),
      DietMeal(
        label: 'Ebéd',
        name: 'Tonhalas kukoricás tésztasaláta',
        calories: 515,
      ),
      DietMeal(
        label: 'Vacsora',
        name: 'Cottage cheese zöldségtál',
        calories: 350,
      ),
      DietMeal(
        label: 'Nasi',
        name: 'Rizsszelet cottage cheese-zel',
        calories: 165,
      ),
    ],
  ),
  DietDayPlan(
    name: 'Sietős nap',
    totalCalories: 1500,
    meals: [
      DietMeal(
        label: 'Reggeli',
        name: 'Görög joghurtos granola pohár',
        calories: 390,
      ),
      DietMeal(label: 'Ebéd', name: 'Csirkés pita tál', calories: 540),
      DietMeal(label: 'Vacsora', name: 'Zöldséges omlett', calories: 340),
      DietMeal(label: 'Nasi', name: 'Tonhalas ropogós falatok', calories: 230),
    ],
  ),
];

const _budget1500Plans = [
  DietDayPlan(
    name: 'Okos nap',
    totalCalories: 1490,
    meals: [
      DietMeal(
        label: 'Reggeli',
        name: 'Almás fahéjas overnight oats',
        calories: 410,
      ),
      DietMeal(
        label: 'Ebéd',
        name: 'Csicseriborsó curry rizzsel',
        calories: 520,
      ),
      DietMeal(label: 'Vacsora', name: 'Tojásos zöldséges rizs', calories: 420),
      DietMeal(
        label: 'Nasi',
        name: 'Almaszeletek mogyoróvajjal',
        calories: 140,
      ),
    ],
  ),
  DietDayPlan(
    name: 'Egyszerű nap',
    totalCalories: 1510,
    meals: [
      DietMeal(label: 'Reggeli', name: 'Zöldséges omlett', calories: 340),
      DietMeal(label: 'Ebéd', name: 'Pulykás bolognai tészta', calories: 520),
      DietMeal(label: 'Vacsora', name: 'Könnyű babos chili', calories: 440),
      DietMeal(label: 'Nasi', name: 'Banános kakaós falatok', calories: 210),
    ],
  ),
];

const _mealPrep1500Plans = [
  DietDayPlan(
    name: 'Dobozolós nap',
    totalCalories: 1500,
    meals: [
      DietMeal(
        label: 'Reggeli',
        name: 'Overnight oats előre bekészítve',
        calories: 410,
      ),
      DietMeal(label: 'Ebéd', name: 'Csirkés rizses fit bowl', calories: 520),
      DietMeal(label: 'Vacsora', name: 'Könnyű babos chili', calories: 440),
      DietMeal(label: 'Nasi', name: 'Protein joghurt pohár', calories: 130),
    ],
  ),
  DietDayPlan(
    name: 'Előre főzős nap',
    totalCalories: 1495,
    meals: [
      DietMeal(
        label: 'Reggeli',
        name: 'Túrós zabpalacsinta előre sütve',
        calories: 360,
      ),
      DietMeal(
        label: 'Ebéd',
        name: 'Marhahúsos bulgur serpenyő',
        calories: 520,
      ),
      DietMeal(
        label: 'Vacsora',
        name: 'Töltött paprika light módra',
        calories: 470,
      ),
      DietMeal(label: 'Nasi', name: 'Hummuszos zöldségdoboz', calories: 145),
    ],
  ),
];

class DietPlanTypeScreen extends StatelessWidget {
  const DietPlanTypeScreen({required this.calories, super.key});

  final int calories;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    final types = [
      _DietTypeOption(
        icon: CupertinoIcons.bolt_fill,
        title: tx(context, 'Magas fehérje'),
        subtitle: tx(context, 'Edzéshez és jobb teltségérzethez'),
        accent: const Color(0xFFD86F35),
        macros: _MacroProfile.highProtein,
        plans: _highProtein1500Plans,
      ),
      _DietTypeOption(
        icon: CupertinoIcons.leaf_arrow_circlepath,
        title: tx(context, 'Gluténmentes'),
        subtitle: tx(context, 'Glutént tartalmazó alapanyagok nélkül'),
        accent: const Color(0xFF8E9E44),
        macros: _MacroProfile.balanced,
        plans: _glutenFree1500Plans,
      ),
      _DietTypeOption(
        icon: CupertinoIcons.leaf_arrow_circlepath,
        title: tx(context, 'Vegetáriánus'),
        subtitle: tx(context, 'Húsmentes napi étrend'),
        accent: const Color(0xFF4F9B62),
        macros: _MacroProfile.plantForward,
        plans: _vegetarian1500Plans,
      ),
      _DietTypeOption(
        icon: CupertinoIcons.clock,
        title: tx(context, 'Gyors'),
        subtitle: tx(context, 'Rövid elkészítési idejű ételekkel'),
        accent: const Color(0xFFC89132),
        macros: _MacroProfile.quick,
        plans: _quick1500Plans,
      ),
      _DietTypeOption(
        icon: CupertinoIcons.money_euro_circle,
        title: tx(context, 'Pénztárcabarát'),
        subtitle: tx(context, 'Egyszerűbb, olcsóbb alapanyagokkal'),
        accent: const Color(0xFFB87A3A),
        macros: _MacroProfile.budget,
        plans: _budget1500Plans,
      ),
      _DietTypeOption(
        icon: CupertinoIcons.archivebox,
        title: tx(context, 'Meal prep alapú'),
        subtitle: tx(context, 'Előre dobozolható napi menü'),
        accent: const Color(0xFF9B7452),
        macros: _MacroProfile.mealPrep,
        plans: _mealPrep1500Plans,
      ),
    ];

    return CupertinoPageScaffold(
      backgroundColor: p.bg,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: p.bg.withValues(alpha: 0.82),
        border: Border(bottom: BorderSide(color: p.border)),
        leading: const _WarmBackButton(),
        middle: Text('$calories kcal'),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            14,
            14,
            14,
            AppLayout.screenBottomPadding,
          ),
          children: [
            AppCard(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx(context, 'Válassz étrend típust'),
                    style: TextStyle(
                      color: p.text,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tx(
                      context,
                      'Válassz egy típust, majd nézd meg a hozzá tartozó napi étrendeket.',
                    ),
                    style: TextStyle(
                      color: p.muted,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SectionLabel(tx(context, 'Étrend típusok')),
            for (final type in types) _DietTypeTile(option: type),
          ],
        ),
      ),
    );
  }
}

class _DietTypeOption {
  const _DietTypeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.macros,
    required this.plans,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final _MacroProfile macros;
  final List<DietDayPlan> plans;
}

class _MacroProfile {
  const _MacroProfile({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  static const highProtein = _MacroProfile(
    protein: 0.36,
    carbs: 0.34,
    fat: 0.30,
  );
  static const balanced = _MacroProfile(protein: 0.28, carbs: 0.44, fat: 0.28);
  static const plantForward = _MacroProfile(
    protein: 0.26,
    carbs: 0.48,
    fat: 0.26,
  );
  static const quick = _MacroProfile(protein: 0.30, carbs: 0.42, fat: 0.28);
  static const budget = _MacroProfile(protein: 0.27, carbs: 0.47, fat: 0.26);
  static const mealPrep = _MacroProfile(protein: 0.32, carbs: 0.40, fat: 0.28);

  final double protein;
  final double carbs;
  final double fat;
}

class _DietTypeTile extends StatelessWidget {
  const _DietTypeTile({required this.option});

  final _DietTypeOption option;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => Navigator.of(context).push(
        CupertinoPageRoute<void>(
          builder: (_) => _DietPlanListScreen(
            title: option.title,
            plans: option.plans,
            macros: option.macros,
          ),
        ),
      ),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            Container(
              width: 5,
              height: 74,
              decoration: BoxDecoration(
                color: option.accent.withValues(alpha: 0.78),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(18),
                ),
              ),
            ),
            const SizedBox(width: 11),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  option.accent.withValues(alpha: 0.12),
                  p.resultBg,
                ),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: option.accent.withValues(alpha: 0.38),
                ),
              ),
              child: Icon(option.icon, color: option.accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: TextStyle(
                      color: p.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: p.muted,
                      fontSize: 13,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(CupertinoIcons.chevron_forward, color: p.muted, size: 18),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}

class _DietPlanListScreen extends StatelessWidget {
  const _DietPlanListScreen({
    required this.title,
    required this.plans,
    required this.macros,
  });

  final String title;
  final List<DietDayPlan> plans;
  final _MacroProfile macros;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoPageScaffold(
      backgroundColor: p.bg,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: p.bg.withValues(alpha: 0.82),
        border: Border(bottom: BorderSide(color: p.border)),
        leading: const _WarmBackButton(),
        middle: Text(title),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            14,
            14,
            14,
            AppLayout.screenBottomPadding,
          ),
          children: [
            SectionLabel(tx(context, '1500 kcal étrendek')),
            for (final plan in plans)
              _DietDayPlanCard(plan: plan, macros: macros),
          ],
        ),
      ),
    );
  }
}

class DietDayPlan {
  const DietDayPlan({
    required this.name,
    required this.totalCalories,
    required this.meals,
  });

  final String name;
  final int totalCalories;
  final List<DietMeal> meals;
}

class DietMeal {
  const DietMeal({
    required this.label,
    required this.name,
    required this.calories,
  });

  final String label;
  final String name;
  final int calories;
}

class _DietDayPlanCard extends StatelessWidget {
  const _DietDayPlanCard({required this.plan, required this.macros});

  final DietDayPlan plan;
  final _MacroProfile macros;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => Navigator.of(context).push(
        CupertinoPageRoute<void>(
          builder: (_) => DietPlanDetailScreen(plan: plan),
        ),
      ),
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: p.resultBg,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: p.resultBorder),
                  ),
                  child: Icon(
                    CupertinoIcons.calendar,
                    color: p.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx(context, plan.name),
                        style: _headlineSerifStyle(
                          color: p.text,
                          fontSize: 18,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${plan.meals.length} ${tx(context, 'étkezés')}',
                        style: TextStyle(
                          color: p.muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: p.resultBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: p.resultBorder),
                  ),
                  child: Text(
                    '${plan.totalCalories} kcal',
                    style: TextStyle(
                      color: p.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(CupertinoIcons.chevron_forward, color: p.muted, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            _MacroBreakdownBar(calories: plan.totalCalories, macros: macros),
          ],
        ),
      ),
    );
  }
}

class _MacroBreakdownBar extends StatelessWidget {
  const _MacroBreakdownBar({required this.calories, required this.macros});

  final int calories;
  final _MacroProfile macros;

  int get proteinGrams => (calories * macros.protein / 4).round();

  int get carbGrams => (calories * macros.carbs / 4).round();

  int get fatGrams => (calories * macros.fat / 9).round();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    const proteinColor = Color(0xFFD56A2D);
    const carbColor = Color(0xFFC09A38);
    const fatColor = Color(0xFF8E6B4E);
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 8,
            child: Row(
              children: [
                _MacroSegment(
                  flex: (macros.protein * 1000).round(),
                  color: proteinColor,
                ),
                _MacroSegment(
                  flex: (macros.carbs * 1000).round(),
                  color: carbColor,
                ),
                _MacroSegment(
                  flex: (macros.fat * 1000).round(),
                  color: fatColor,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            _MacroLabel(
              label: 'P',
              value: '${proteinGrams}g',
              color: proteinColor,
            ),
            const SizedBox(width: 10),
            _MacroLabel(label: 'C', value: '${carbGrams}g', color: carbColor),
            const SizedBox(width: 10),
            _MacroLabel(label: 'F', value: '${fatGrams}g', color: fatColor),
            const Spacer(),
            Text(
              'macro split',
              style: TextStyle(
                color: p.muted.withValues(alpha: state.isDark ? 0.82 : 0.72),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MacroSegment extends StatelessWidget {
  const _MacroSegment({required this.flex, required this.color});

  final int flex;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: ColoredBox(color: color),
    );
  }
}

class _MacroLabel extends StatelessWidget {
  const _MacroLabel({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          '$label $value',
          style: TextStyle(
            color: p.text,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class DietPlanDetailScreen extends StatelessWidget {
  const DietPlanDetailScreen({required this.plan, super.key});

  final DietDayPlan plan;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoPageScaffold(
      backgroundColor: p.bg,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: p.bg.withValues(alpha: 0.82),
        border: Border(bottom: BorderSide(color: p.border)),
        leading: const _WarmBackButton(),
        middle: Text(tx(context, 'Étrend')),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            14,
            14,
            14,
            AppLayout.screenBottomPadding,
          ),
          children: [
            AppCard(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx(context, plan.name),
                    style: _headlineSerifStyle(
                      color: p.text,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _RecipeSummaryRow(
                    label: tx(context, 'Összes kalória'),
                    value: '${plan.totalCalories} kcal',
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      color: p.accent,
                      borderRadius: BorderRadius.circular(14),
                      onPressed: AppScope.of(context).isPro
                          ? () => showCupertinoModalPopup<void>(
                              context: context,
                              barrierColor: const Color(0x99000000),
                              builder: (_) =>
                                  DietPlanShoppingListSheet(plan: plan),
                            )
                          : () => showProPaywallSheet(context),
                      child: Text(
                        tx(context, 'Bevásárláshoz adás'),
                        style: TextStyle(
                          color: p.buttonText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SectionLabel(tx(context, 'Napi bontás')),
            for (final meal in plan.meals) _DietPlanMealCard(meal: meal),
          ],
        ),
      ),
    );
  }
}

class _DietPlanMealCard extends StatelessWidget {
  const _DietPlanMealCard({required this.meal});

  final DietMeal meal;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    final recipe = _recipeForMeal(meal);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: recipe == null
          ? null
          : () => Navigator.of(context).push(
              CupertinoPageRoute<void>(
                builder: (_) => RecipeDetailScreen(recipe: recipe),
              ),
            ),
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: p.bg.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.border),
              ),
              child: Text(
                _dietMealEmoji(meal.label),
                style: const TextStyle(fontSize: 19),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx(context, meal.label),
                    style: TextStyle(
                      color: p.accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tx(context, meal.name),
                    style: TextStyle(
                      color: p.text,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${meal.calories} kcal',
                  style: TextStyle(
                    color: p.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (recipe != null) ...[
                  const SizedBox(height: 5),
                  Icon(
                    CupertinoIcons.chevron_forward,
                    color: p.muted,
                    size: 16,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DietPlanShoppingListSheet extends StatefulWidget {
  const DietPlanShoppingListSheet({required this.plan, super.key});

  final DietDayPlan plan;

  @override
  State<DietPlanShoppingListSheet> createState() =>
      _DietPlanShoppingListSheetState();
}

class _DietPlanShoppingListSheetState extends State<DietPlanShoppingListSheet> {
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.plan.name;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final items = _dietPlanShoppingItems(widget.plan);
    return GlassSurface(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      radius: 26,
      tint: p.card,
      opacity: 1,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tx(context, 'Bevásárlólista mentése'),
                      style: TextStyle(
                        color: p.text,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    minimumSize: const Size(34, 34),
                    padding: EdgeInsets.zero,
                    color: p.bg,
                    borderRadius: BorderRadius.circular(18),
                    onPressed: () => Navigator.pop(context),
                    child: Icon(CupertinoIcons.xmark, color: p.muted, size: 17),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                tx(context, 'Új lista neve'),
                style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: nameController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                style: TextStyle(color: p.text, fontWeight: FontWeight.w600),
                decoration: BoxDecoration(
                  color: p.bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: p.border),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: p.accent,
                  borderRadius: BorderRadius.circular(14),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  onPressed: items.isEmpty
                      ? null
                      : () {
                          state.addShoppingList(
                            name: nameController.text,
                            items: items,
                          );
                          Navigator.pop(context);
                        },
                  child: Text(
                    tx(context, 'Mentés új listaként'),
                    style: TextStyle(
                      color: p.buttonText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (state.shoppingLists.isNotEmpty) ...[
                const SizedBox(height: 16),
                SectionLabel(tx(context, 'Meglévő listához adás')),
                for (final list in state.shoppingLists)
                  _RecipeShoppingTargetRow(
                    list: list,
                    onPressed: items.isEmpty
                        ? () {}
                        : () {
                            state.addItemsToShoppingList(
                              listId: list.id,
                              items: items,
                            );
                            Navigator.pop(context);
                          },
                  ),
              ],
              const SizedBox(height: 12),
              Text(
                tx(context, 'Hozzávalók'),
                style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              for (final item in items.take(10))
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    item.name,
                    style: TextStyle(
                      color: p.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (items.length > 10)
                Text(
                  '+${items.length - 10} ${tx(context, 'tétel')}',
                  style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Recipe? _recipeForMeal(DietMeal meal) {
  final mealName = _normalizeRecipeName(meal.name);
  if (mealName.contains('overnight oats')) {
    return recipeById('overnight_oats_apple');
  }
  for (final recipe in allRecipes) {
    final recipeName = _normalizeRecipeName(recipe.name);
    if (mealName.contains(recipeName) || recipeName.contains(mealName)) {
      return recipe;
    }
  }
  return null;
}

String _normalizeRecipeName(String value) => value.toLowerCase().trim();

List<ShoppingListItem> _dietPlanShoppingItems(DietDayPlan plan) {
  final totals = <String, ({String name, String unit, double amount})>{};
  for (final meal in plan.meals) {
    final recipe = _recipeForMeal(meal);
    if (recipe == null) continue;
    final scale =
        meal.calories / recipe.caloriesPerServing / recipe.baseServings;
    for (final ingredient in recipe.ingredients) {
      final key = '${ingredient.name}|${ingredient.unit}';
      final amount = ingredient.amount * scale;
      final existing = totals[key];
      totals[key] = (
        name: ingredient.name,
        unit: ingredient.unit,
        amount: (existing?.amount ?? 0) + amount,
      );
    }
  }
  return totals.values
      .map(
        (item) => ShoppingListItem(
          name:
              '${item.name} - ${_formatRecipeAmount(item.amount)} ${item.unit}',
        ),
      )
      .toList();
}

String _dietMealEmoji(String label) => switch (label) {
  'Reggeli' => '☕',
  'Ebéd' => '🍽️',
  'Vacsora' => '🌙',
  'Nasi' => '🍓',
  _ => '•',
};

enum _RecipeDietFilter { all, normal, vegan }

class _FoodSubpageScaffold extends StatelessWidget {
  const _FoodSubpageScaffold({required this.children});

  final List<Widget> children;

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
            ListView(
              padding: const EdgeInsets.fromLTRB(
                14,
                10,
                14,
                AppLayout.screenBottomPadding,
              ),
              children: children,
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({
    required this.title,
    required this.recipes,
    super.key,
  });

  final String title;
  final List<Recipe> recipes;

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late final TextEditingController _searchController;
  _RecipeDietFilter _filter = _RecipeDietFilter.all;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final filteredRecipes = widget.recipes.where(_matchesFilters).toList();
    final favorites = filteredRecipes
        .where((recipe) => state.isFavoriteRecipe(recipe.id))
        .toList();
    final regularRecipes = filteredRecipes
        .where((recipe) => !state.isFavoriteRecipe(recipe.id))
        .toList();
    return _FoodSubpageScaffold(
      children: [
        _RecipeSearchAndFilter(
          controller: _searchController,
          filter: _filter,
          onQueryChanged: (value) {
            setState(() {
              _query = value.trim().toLowerCase();
            });
          },
          onFilterChanged: (value) {
            setState(() {
              _filter = value;
            });
          },
        ),
        const SizedBox(height: 14),
        if (favorites.isNotEmpty) ...[
          SectionLabel(tx(context, 'Kedvencek')),
          for (final recipe in favorites) _RecipeTile(recipe: recipe),
          const SizedBox(height: 8),
        ],
        SectionLabel(tx(context, 'Receptek')),
        if (regularRecipes.isEmpty && favorites.isEmpty)
          _EmptyFoodMessage(tx(context, 'Nincs találat.')),
        for (final recipe in regularRecipes) _RecipeTile(recipe: recipe),
      ],
    );
  }

  bool _matchesFilters(Recipe recipe) {
    final matchesDiet = switch (_filter) {
      _RecipeDietFilter.all => true,
      _RecipeDietFilter.normal => !recipe.isVegan,
      _RecipeDietFilter.vegan => recipe.isVegan,
    };
    if (!matchesDiet) return false;
    if (_query.isEmpty) return true;
    return recipe.name.toLowerCase().contains(_query) ||
        recipe.ingredients.any(
          (ingredient) => ingredient.name.toLowerCase().contains(_query),
        );
  }
}

class _RecipeSearchAndFilter extends StatelessWidget {
  const _RecipeSearchAndFilter({
    required this.controller,
    required this.filter,
    required this.onQueryChanged,
    required this.onFilterChanged,
  });

  final TextEditingController controller;
  final _RecipeDietFilter filter;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<_RecipeDietFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Column(
      children: [
        Row(
          children: [
            const _WarmBackButton(size: 48, radius: 16, iconSize: 25),
            const SizedBox(width: 10),
            Expanded(
              child: CupertinoTextField(
                controller: controller,
                onChanged: onQueryChanged,
                placeholder: tx(context, 'Keresés receptek között'),
                prefix: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 12, end: 6),
                  child: Icon(CupertinoIcons.search, color: p.muted, size: 19),
                ),
                suffix: controller.text.isEmpty
                    ? null
                    : CupertinoButton(
                        minimumSize: const Size(34, 34),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          controller.clear();
                          onQueryChanged('');
                        },
                        child: Icon(
                          CupertinoIcons.xmark_circle_fill,
                          color: p.muted,
                          size: 18,
                        ),
                      ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 14,
                ),
                style: TextStyle(
                  color: p.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                placeholderStyle: TextStyle(
                  color: p.muted.withValues(alpha: 0.72),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                decoration: BoxDecoration(
                  color: p.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: p.border),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: CupertinoSlidingSegmentedControl<_RecipeDietFilter>(
            groupValue: filter,
            backgroundColor: p.card,
            thumbColor: p.resultBg,
            padding: const EdgeInsets.all(4),
            children: {
              _RecipeDietFilter.all: _RecipeFilterLabel(tx(context, 'Mind')),
              _RecipeDietFilter.normal: _RecipeFilterLabel(
                tx(context, 'Normál receptek'),
              ),
              _RecipeDietFilter.vegan: _RecipeFilterLabel(tx(context, 'Vegán')),
            },
            onValueChanged: (value) {
              if (value != null) onFilterChanged(value);
            },
          ),
        ),
      ],
    );
  }
}

class _RecipeFilterLabel extends StatelessWidget {
  const _RecipeFilterLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        label,
        style: TextStyle(
          color: p.text,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RecipeTile extends StatelessWidget {
  const _RecipeTile({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final isFavorite = state.isFavoriteRecipe(recipe.id);
    return AppCard(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: CupertinoButton(
              padding: const EdgeInsets.fromLTRB(14, 13, 8, 13),
              onPressed: () => Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (_) => RecipeDetailScreen(recipe: recipe),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: p.bg.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: p.border),
                    ),
                    child: Text(
                      recipe.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx(context, recipe.name),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: p.text,
                            fontSize: 16,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${recipe.caloriesPerServing} kcal/${tx(context, 'adag')} · ${recipe.prepTimeMinutes} ${tx(context, 'perc')}',
                          style: TextStyle(
                            color: p.muted,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          CupertinoButton(
            minimumSize: const Size(38, 38),
            padding: EdgeInsets.zero,
            onPressed: () => state.toggleFavoriteRecipe(recipe.id),
            child: Icon(
              isFavorite ? CupertinoIcons.star_fill : CupertinoIcons.star,
              color: isFavorite ? p.accent : p.muted,
              size: 21,
            ),
          ),
          const SizedBox(width: 4),
          Icon(CupertinoIcons.chevron_forward, color: p.muted, size: 18),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({required this.recipe, super.key});

  final Recipe recipe;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late int servings;
  late final TextEditingController servingsController;

  @override
  void initState() {
    super.initState();
    servings = widget.recipe.baseServings;
    servingsController = TextEditingController(text: servings.toString());
  }

  @override
  void dispose() {
    servingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final recipe = widget.recipe;
    final isFavorite = state.isFavoriteRecipe(recipe.id);
    final totalCalories = recipe.caloriesPerServing * servings;
    return _FoodSubpageScaffold(
      children: [
        const _WarmBackButton(size: 48, radius: 16, iconSize: 25),
        const SizedBox(height: 10),
        AppCard(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: p.bg.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: p.border),
                    ),
                    child: Text(
                      recipe.emoji,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                tx(context, recipe.name),
                                style: TextStyle(
                                  color: p.text,
                                  fontSize: 22,
                                  height: 1.12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            CupertinoButton(
                              minimumSize: const Size(34, 34),
                              padding: EdgeInsets.zero,
                              color: p.bg.withValues(alpha: 0.68),
                              borderRadius: BorderRadius.circular(12),
                              onPressed: () =>
                                  state.toggleFavoriteRecipe(recipe.id),
                              child: Icon(
                                isFavorite
                                    ? CupertinoIcons.star_fill
                                    : CupertinoIcons.star,
                                color: isFavorite ? p.accent : p.muted,
                                size: 19,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${recipe.prepTimeMinutes} ${tx(context, 'perc')} · ${recipe.caloriesPerServing} kcal/${tx(context, 'adag')}',
                          style: TextStyle(
                            color: p.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _RecipeServingsStepper(
                value: servings,
                controller: servingsController,
                onChanged: _setServings,
              ),
              const SizedBox(height: 14),
              _RecipeSummaryRow(
                label: tx(context, 'Összes kalória'),
                value: '$totalCalories kcal',
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  color: p.accent,
                  borderRadius: BorderRadius.circular(14),
                  onPressed: state.isPro
                      ? () => showCupertinoModalPopup<void>(
                          context: context,
                          barrierColor: const Color(0x99000000),
                          builder: (_) => RecipeShoppingListSheet(
                            recipe: recipe,
                            servings: servings,
                          ),
                        )
                      : () => showProPaywallSheet(context),
                  child: Text(
                    tx(context, 'Bevásárláshoz adás'),
                    style: TextStyle(
                      color: p.buttonText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SectionLabel(tx(context, 'Hozzávalók')),
        AppCard(
          child: Column(
            children: [
              for (final ingredient in recipe.ingredients)
                _RecipeIngredientRow(
                  ingredient: ingredient,
                  scale: servings / recipe.baseServings,
                ),
            ],
          ),
        ),
        SectionLabel(tx(context, 'Elkészítés')),
        AppCard(
          child: Column(
            children: [
              for (var index = 0; index < recipe.steps.length; index++)
                _RecipeStepRow(index: index, text: recipe.steps[index]),
            ],
          ),
        ),
        SectionLabel(tx(context, 'Allergének')),
        AppCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final allergen in recipe.allergens)
                _RecipeAllergenChip(label: allergen),
            ],
          ),
        ),
      ],
    );
  }

  void _setServings(int next) {
    final clamped = next.clamp(1, 20);
    if (clamped == servings) {
      servingsController.text = clamped.toString();
      return;
    }
    setState(() {
      servings = clamped;
      servingsController.text = clamped.toString();
    });
  }
}

class RecipeShoppingListSheet extends StatefulWidget {
  const RecipeShoppingListSheet({
    required this.recipe,
    required this.servings,
    super.key,
  });

  final Recipe recipe;
  final int servings;

  @override
  State<RecipeShoppingListSheet> createState() =>
      _RecipeShoppingListSheetState();
}

class _RecipeShoppingListSheetState extends State<RecipeShoppingListSheet> {
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.recipe.name;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final items = _recipeShoppingItems(widget.recipe, widget.servings);
    return GlassSurface(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      radius: 26,
      tint: p.card,
      opacity: 1,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tx(context, 'Bevásárlólista mentése'),
                      style: TextStyle(
                        color: p.text,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    minimumSize: const Size(34, 34),
                    padding: EdgeInsets.zero,
                    color: p.bg,
                    borderRadius: BorderRadius.circular(18),
                    onPressed: () => Navigator.pop(context),
                    child: Icon(CupertinoIcons.xmark, color: p.muted, size: 17),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                tx(context, 'Új lista neve'),
                style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: nameController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                style: TextStyle(color: p.text, fontWeight: FontWeight.w600),
                decoration: BoxDecoration(
                  color: p.bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: p.border),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: p.accent,
                  borderRadius: BorderRadius.circular(14),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  onPressed: () {
                    state.addShoppingList(
                      name: nameController.text,
                      items: items,
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    tx(context, 'Mentés új listaként'),
                    style: TextStyle(
                      color: p.buttonText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (state.shoppingLists.isNotEmpty) ...[
                const SizedBox(height: 16),
                SectionLabel(tx(context, 'Meglévő listához adás')),
                for (final list in state.shoppingLists)
                  _RecipeShoppingTargetRow(
                    list: list,
                    onPressed: () {
                      state.addItemsToShoppingList(
                        listId: list.id,
                        items: items,
                      );
                      Navigator.pop(context);
                    },
                  ),
              ],
              const SizedBox(height: 12),
              Text(
                tx(context, 'Hozzávalók'),
                style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    item.name,
                    style: TextStyle(
                      color: p.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeShoppingTargetRow extends StatelessWidget {
  const _RecipeShoppingTargetRow({required this.list, required this.onPressed});

  final ShoppingList list;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: p.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: p.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                list.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: p.text, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${list.items.length} ${tx(context, 'tétel')}',
              style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeServingsStepper extends StatelessWidget {
  const _RecipeServingsStepper({
    required this.value,
    required this.controller,
    required this.onChanged,
  });

  final int value;
  final TextEditingController controller;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: p.bg.withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              tx(context, 'Adagok száma'),
              style: TextStyle(
                color: p.text,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _RecipeStepButton(
            icon: CupertinoIcons.minus,
            onPressed: () => onChanged(value - 1),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 54,
            child: CupertinoTextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              padding: const EdgeInsets.symmetric(vertical: 9),
              style: TextStyle(
                color: p.text,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              decoration: BoxDecoration(
                color: p.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.border),
              ),
              onChanged: (text) {
                final parsed = int.tryParse(text);
                if (parsed != null) onChanged(parsed);
              },
            ),
          ),
          const SizedBox(width: 8),
          _RecipeStepButton(
            icon: CupertinoIcons.plus,
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _RecipeStepButton extends StatelessWidget {
  const _RecipeStepButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoButton(
      minimumSize: const Size(34, 34),
      padding: EdgeInsets.zero,
      color: p.card,
      borderRadius: BorderRadius.circular(12),
      onPressed: onPressed,
      child: Icon(icon, color: p.accent, size: 17),
    );
  }
}

class _RecipeSummaryRow extends StatelessWidget {
  const _RecipeSummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: p.resultBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.resultBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: p.accent,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeIngredientRow extends StatelessWidget {
  const _RecipeIngredientRow({required this.ingredient, required this.scale});

  final RecipeIngredient ingredient;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    final amount = ingredient.amount * scale;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              ingredient.name,
              style: TextStyle(
                color: p.text,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_formatRecipeAmount(amount)} ${ingredient.unit}',
            style: TextStyle(
              color: p.accent,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeStepRow extends StatelessWidget {
  const _RecipeStepRow({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Padding(
      padding: EdgeInsets.only(bottom: index == 0 ? 12 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: p.accent,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: p.buttonText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: p.text,
                fontSize: 15,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeAllergenChip extends StatelessWidget {
  const _RecipeAllergenChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: p.bg.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: p.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: p.muted,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _formatRecipeAmount(double value) {
  if (value == value.roundToDouble()) return value.round().toString();
  return value.toStringAsFixed(1);
}

List<ShoppingListItem> _recipeShoppingItems(Recipe recipe, int servings) {
  final scale = servings / recipe.baseServings;
  return recipe.ingredients
      .map(
        (ingredient) => ShoppingListItem(
          name:
              '${ingredient.name} - ${_formatRecipeAmount(ingredient.amount * scale)} ${ingredient.unit}',
        ),
      )
      .toList();
}

void showProPaywallSheet(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    barrierColor: const Color(0xCC000000),
    builder: (context) {
      return Container(
        color: CupertinoColors.transparent,
        child: SafeArea(
          top: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.82,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: const ProUpsellCard(),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Color _disabledActionFill(AppState state) {
  final p = state.palette;
  if (state.isDark) return p.resultBg;
  return Color.alphaBlend(p.accent.withValues(alpha: 0.12), p.card);
}

Color _disabledActionText(AppState state) {
  final p = state.palette;
  return state.isDark
      ? p.muted.withValues(alpha: 0.86)
      : p.accentDim.withValues(alpha: 0.94);
}

class _ActionPillButton extends StatelessWidget {
  const _ActionPillButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final disabledFill = _disabledActionFill(state);
    final disabledContent = _disabledActionText(state);
    return SpringPressable(
      enabled: enabled,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        borderRadius: BorderRadius.circular(999),
        color: enabled ? p.accent : disabledFill,
        onPressed: enabled ? onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: enabled
                    ? p.buttonText.withValues(alpha: 0.18)
                    : disabledContent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: enabled
                    ? null
                    : Border.all(
                        color: disabledContent.withValues(alpha: 0.42),
                      ),
              ),
              child: Icon(
                icon,
                color: enabled ? p.buttonText : disabledContent,
                size: 17,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    color: enabled ? p.buttonText : disabledContent,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FreeLimitStrip extends StatelessWidget {
  const _FreeLimitStrip({required this.mainCount, required this.sideCount});

  final int mainCount;
  final int sideCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _LimitMeter(
            label: tx(context, 'Főétel'),
            value: mainCount.clamp(0, 1),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _LimitMeter(
            label: tx(context, 'Köret'),
            value: sideCount.clamp(0, 1),
          ),
        ),
      ],
    );
  }
}

class _LimitMeter extends StatelessWidget {
  const _LimitMeter({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    final filled = value >= 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (filled ? p.accent : p.border).withValues(alpha: 0.72),
        ),
      ),
      child: Row(
        children: [
          if (filled) ...[
            Icon(
              CupertinoIcons.checkmark_circle_fill,
              color: p.accent,
              size: 17,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: p.text,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '$value/1',
            style: TextStyle(
              color: filled ? p.accent : p.muted,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeActionBackground extends StatelessWidget {
  const _SwipeActionBackground({
    required this.icon,
    required this.label,
    required this.color,
    required this.alignment,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    final isStart = alignment == Alignment.centerLeft;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color.alphaBlend(color, p.border)),
      ),
      child: Row(
        mainAxisAlignment: isStart
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (!isStart) Text(label, style: _swipeActionTextStyle()),
          if (!isStart) const SizedBox(width: 9),
          Icon(icon, color: CupertinoColors.white, size: 22),
          if (isStart) const SizedBox(width: 9),
          if (isStart) Text(label, style: _swipeActionTextStyle()),
        ],
      ),
    );
  }

  TextStyle _swipeActionTextStyle() {
    return const TextStyle(
      color: CupertinoColors.white,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );
  }
}

class FoodTile extends StatefulWidget {
  const FoodTile({required this.food, super.key});

  final FoodItem food;

  @override
  State<FoodTile> createState() => _FoodTileState();
}

class _FoodTileState extends State<FoodTile> {
  bool expanded = false;
  bool noteOpen = false;
  late final TextEditingController servedController;
  late final TextEditingController noteController;
  final servedFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    servedController = TextEditingController(
      text: widget.food.servedWeight.toStringAsFixed(1),
    );
    noteController = TextEditingController(text: widget.food.note);
  }

  @override
  void didUpdateWidget(covariant FoodTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.food.servedWeight != widget.food.servedWeight &&
        !servedFocus.hasFocus) {
      servedController.text = widget.food.servedWeight.toStringAsFixed(1);
    }
    if (oldWidget.food.note != widget.food.note &&
        noteController.text != widget.food.note) {
      noteController.text = widget.food.note;
    }
  }

  @override
  void dispose() {
    servedController.dispose();
    servedFocus.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final notesEnabled = state.isPro;
    final sharingEnabled = state.isPro;
    final accent = p.accent;

    return Dismissible(
      key: ValueKey('food-${widget.food.id}'),
      background: _SwipeActionBackground(
        icon: CupertinoIcons.archivebox,
        label: tx(context, 'Meal prep'),
        color: p.accent,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _SwipeActionBackground(
        icon: CupertinoIcons.trash_fill,
        label: 'Delete',
        color: const Color(0xFFC04040),
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        FocusManager.instance.primaryFocus?.unfocus();
        HapticFeedback.mediumImpact();
        if (direction == DismissDirection.startToEnd) {
          _openMealPrepFromFood(context, state);
        } else {
          state.deleteFood(widget.food.id);
        }
        return false;
      },
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              onPressed: () => setState(() => expanded = !expanded),
              child: Row(
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.food.name,
                          style: TextStyle(
                            color: p.text,
                            fontSize: 17,
                            height: 1.1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Added: ${_addedLabel(widget.food.addedLabel)}',
                          style: TextStyle(
                            color: p.muted,
                            fontSize: 13,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expanded
                        ? CupertinoIcons.chevron_up
                        : CupertinoIcons.chevron_down,
                    size: 18,
                    color: p.border,
                  ),
                ],
              ),
            ),
            if (expanded) ...[
              Container(height: 1, color: p.border),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _WeightRow(
                      label: tx(context, 'Nyers adag'),
                      value: grams(widget.food.rawWeight),
                    ),
                    _WeightRow(
                      label: 'Cooked weight',
                      value: grams(widget.food.cookedWeight),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Served portion',
                            style: TextStyle(
                              color: accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 86,
                          child: CupertinoTextField(
                            controller: servedController,
                            focusNode: servedFocus,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onTap: () {
                              servedController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: servedController.text.length,
                              );
                            },
                            textAlign: TextAlign.right,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            style: TextStyle(
                              color: accent,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: BoxDecoration(
                              color: p.bg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: accent, width: 1.5),
                            ),
                            onChanged: (value) => state.updateServedWeight(
                              widget.food.id,
                              double.tryParse(value.replaceAll(',', '.')) ?? 0,
                            ),
                            onEditingComplete: () {
                              servedFocus.unfocus();
                              servedController.text = widget.food.servedWeight
                                  .toStringAsFixed(1);
                            },
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text('g', style: TextStyle(color: p.muted)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: p.resultBg,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: p.resultBorder),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Raw equivalent',
                            style: TextStyle(
                              color: accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            grams(widget.food.rawEquivalent),
                            style: TextStyle(
                              color: accent,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (sharingEnabled || notesEnabled) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          if (sharingEnabled)
                            Expanded(
                              child: _FoodActionButton(
                                icon: CupertinoIcons.square_arrow_up,
                                label: 'Share',
                                color: p.accent,
                                onPressed: () => _shareFood(context),
                              ),
                            ),
                          if (sharingEnabled && notesEnabled)
                            const SizedBox(width: 8),
                          if (notesEnabled)
                            Expanded(
                              child: _FoodActionButton(
                                icon: CupertinoIcons.doc_text,
                                label: 'Note',
                                color: widget.food.hasNote
                                    ? p.noteColor
                                    : p.accent,
                                onPressed: () =>
                                    setState(() => noteOpen = !noteOpen),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
            if (noteOpen && notesEnabled)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: p.bg,
                  border: Border(top: BorderSide(color: p.border)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.doc_text,
                          color: p.noteColor,
                          size: 15,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tx(context, 'Jegyzet'),
                          style: TextStyle(
                            color: p.noteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      controller: noteController,
                      minLines: 3,
                      maxLines: 6,
                      placeholder: 'Write a recipe, tip or reminder...',
                      padding: const EdgeInsets.all(11),
                      style: TextStyle(color: p.text, height: 1.42),
                      placeholderStyle: TextStyle(color: p.muted),
                      decoration: BoxDecoration(
                        color: p.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: p.border),
                      ),
                      onChanged: (value) =>
                          state.updateFoodNote(widget.food.id, value),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openMealPrepFromFood(BuildContext context, AppState state) {
    if (!state.canAddMealPrepPlan) {
      showProPaywallSheet(context);
      return;
    }
    showCupertinoModalPopup<void>(
      context: context,
      barrierColor: const Color(0x99000000),
      builder: (_) => AddMealPrepSheet(initialFood: widget.food),
    );
  }

  Future<void> _shareFood(BuildContext context) async {
    final food = widget.food;
    final text = [
      food.name,
      '${tx(context, 'Nyers adag')}: ${grams(food.rawWeight)}',
      'Cooked weight: ${grams(food.cookedWeight)}',
      'Served portion: ${grams(food.servedWeight)}',
      'Raw equivalent: ${grams(food.rawEquivalent)}',
      if (food.hasNote) 'Note: ${food.note}',
    ].join('\n');
    await const ShareService().shareText(text);
  }
}

String _addedLabel(String label) {
  return switch (label.trim().toLowerCase()) {
    'ma' => 'today',
    'tegnap' => 'yesterday',
    _ => label,
  };
}

class _FoodActionButton extends StatelessWidget {
  const _FoodActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return SpringPressable(
      pressedScale: 0.96,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        color: p.bg,
        borderRadius: BorderRadius.circular(12),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconChip extends StatelessWidget {
  const _IconChip({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: CupertinoButton(
        minimumSize: const Size(36, 36),
        padding: EdgeInsets.zero,
        color: p.bg,
        borderRadius: BorderRadius.circular(10),
        onPressed: onPressed,
        child: Icon(icon, size: 17, color: color),
      ),
    );
  }
}

class _WeightRow extends StatelessWidget {
  const _WeightRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(CupertinoIcons.lock, size: 13, color: p.accent),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: p.muted)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(color: p.textDim, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return CupertinoPageScaffold(
      backgroundColor: p.bg,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: p.bg,
        border: Border(bottom: BorderSide(color: p.border)),
        leading: const _WarmBackButton(),
        middle: Text(tx(context, 'Bevásárlás+')),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            14,
            14,
            14,
            AppLayout.screenBottomPadding,
          ),
          children: [
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                color: p.accent,
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: () => showCupertinoModalPopup<void>(
                  context: context,
                  barrierColor: const Color(0x99000000),
                  builder: (_) => const AddShoppingListSheet(),
                ),
                child: Text(
                  tx(context, 'Új bevásárlólista'),
                  style: TextStyle(
                    color: p.buttonText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SectionLabel(tx(context, 'Elmentett listák')),
            if (state.shoppingLists.isEmpty)
              AppCard(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                child: Text(
                  tx(context, 'Még nincs elmentett bevásárlólistád.'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
                ),
              )
            else
              for (final list in state.shoppingLists.reversed)
                _ShoppingListTile(list: list),
          ],
        ),
      ),
    );
  }
}

class _ShoppingListTile extends StatelessWidget {
  const _ShoppingListTile({required this.list});

  final ShoppingList list;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = AppScope.of(context).palette;
    return AppCard(
      padding: EdgeInsets.zero,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        onPressed: () => showCupertinoModalPopup<void>(
          context: context,
          barrierColor: const Color(0x99000000),
          builder: (_) => ShoppingListDetailSheet(listId: list.id),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: p.resultBg,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: p.resultBorder),
              ),
              child: Icon(CupertinoIcons.cart, color: p.accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: p.text,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _shoppingDate(list.createdAt),
                    style: TextStyle(
                      color: p.muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${list.items.where((item) => item.checked).length}/${list.items.length}',
              style: TextStyle(color: p.accent, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            _IconChip(
              icon: CupertinoIcons.pencil,
              color: p.accent,
              onPressed: () => showCupertinoModalPopup<void>(
                context: context,
                barrierColor: const Color(0x99000000),
                builder: (_) => AddShoppingListSheet(list: list),
              ),
            ),
            _IconChip(
              icon: CupertinoIcons.trash,
              color: CupertinoColors.systemRed,
              onPressed: () => _confirmDeleteShoppingList(
                context: context,
                state: state,
                list: list,
              ),
            ),
            const SizedBox(width: 4),
            Icon(CupertinoIcons.chevron_right, color: p.border, size: 18),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteShoppingList({
    required BuildContext context,
    required AppState state,
    required ShoppingList list,
  }) {
    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(tx(context, 'Bevásárlólista törlése')),
        content: Text(tx(context, 'Biztosan törlöd ezt a bevásárlólistát?')),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(tx(context, 'Mégse')),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              state.deleteShoppingList(list.id);
              Navigator.pop(dialogContext);
            },
            child: Text(tx(context, 'Törlés')),
          ),
        ],
      ),
    );
  }
}

class AddShoppingListSheet extends StatefulWidget {
  const AddShoppingListSheet({this.list, super.key});

  final ShoppingList? list;

  @override
  State<AddShoppingListSheet> createState() => _AddShoppingListSheetState();
}

class _AddShoppingListSheetState extends State<AddShoppingListSheet> {
  final nameController = TextEditingController();
  final itemRows = <_ShoppingDraftItem>[];

  @override
  void initState() {
    super.initState();
    final list = widget.list;
    if (list == null) {
      itemRows.add(_ShoppingDraftItem());
      return;
    }
    nameController.text = list.name;
    itemRows.addAll(
      list.items.map(
        (item) => _ShoppingDraftItem(text: item.name, checked: item.checked),
      ),
    );
    if (itemRows.isEmpty) itemRows.add(_ShoppingDraftItem());
  }

  @override
  void dispose() {
    nameController.dispose();
    for (final row in itemRows) {
      row.dispose();
    }
    super.dispose();
  }

  bool get canSave =>
      nameController.text.trim().isNotEmpty &&
      itemRows.any((row) => row.controller.text.trim().isNotEmpty);

  void _addItemRow() {
    setState(() => itemRows.add(_ShoppingDraftItem()));
  }

  void _removeItemRow(_ShoppingDraftItem row) {
    if (itemRows.length == 1) {
      row.controller.clear();
      setState(() => row.checked = false);
      return;
    }
    setState(() {
      itemRows.remove(row);
      row.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return Container(
      color: CupertinoColors.transparent,
      child: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GlassSurface(
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            radius: 26,
            tint: p.card,
            opacity: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 590),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SheetHeader(
                      icon: CupertinoIcons.cart_badge_plus,
                      title: tx(
                        context,
                        widget.list == null
                            ? 'Új bevásárlólista'
                            : 'Bevásárlólista szerkesztése',
                      ),
                      subtitle: tx(
                        context,
                        'Nevezd el és add hozzá a tételeket',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tx(context, 'Lista neve'),
                      style: TextStyle(
                        color: p.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _Input(
                      controller: nameController,
                      placeholder: tx(context, 'Pl. Hétvégi főzés'),
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tx(context, 'Hozzávalók'),
                      style: TextStyle(
                        color: p.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final row in itemRows)
                      _DraftShoppingItemRow(
                        row: row,
                        onChanged: () => setState(() {}),
                        onRemove: () => _removeItemRow(row),
                      ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _addItemRow,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.plus_circle_fill,
                            color: p.accent,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            tx(context, 'Tétel hozzáadása'),
                            style: TextStyle(
                              color: p.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                            color: p.bg,
                            borderRadius: BorderRadius.circular(14),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              tx(context, 'Mégse'),
                              style: TextStyle(color: p.muted),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: CupertinoButton(
                            color: canSave
                                ? p.accent
                                : _disabledActionFill(state),
                            borderRadius: BorderRadius.circular(14),
                            onPressed: canSave
                                ? () {
                                    final items = [
                                      for (final row in itemRows)
                                        ShoppingListItem(
                                          name: row.controller.text,
                                          checked: row.checked,
                                        ),
                                    ];
                                    final list = widget.list;
                                    if (list == null) {
                                      state.addShoppingList(
                                        name: nameController.text,
                                        items: items,
                                      );
                                    } else {
                                      state.updateShoppingList(
                                        id: list.id,
                                        name: nameController.text,
                                        items: items,
                                      );
                                    }
                                    Navigator.pop(context);
                                  }
                                : null,
                            child: Text(
                              tx(context, 'Mentés'),
                              style: TextStyle(
                                color: canSave
                                    ? p.buttonText
                                    : _disabledActionText(state),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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

class _ShoppingDraftItem {
  _ShoppingDraftItem({String text = '', this.checked = false})
    : controller = TextEditingController(text: text);

  final TextEditingController controller;
  bool checked;

  void dispose() {
    controller.dispose();
  }
}

class _DraftShoppingItemRow extends StatelessWidget {
  const _DraftShoppingItemRow({
    required this.row,
    required this.onChanged,
    required this.onRemove,
  });

  final _ShoppingDraftItem row;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          _ShoppingCheckButton(
            checked: row.checked,
            onPressed: () {
              row.checked = !row.checked;
              onChanged();
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CupertinoTextField(
              controller: row.controller,
              placeholder: tx(context, 'Hozzávaló'),
              onChanged: (_) => onChanged(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              style: TextStyle(
                color: p.text,
                fontWeight: FontWeight.w600,
                decoration: row.checked ? TextDecoration.lineThrough : null,
              ),
              placeholderStyle: TextStyle(color: p.muted),
              decoration: BoxDecoration(
                color: p.bg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: p.border),
              ),
            ),
          ),
          const SizedBox(width: 6),
          _IconChip(
            icon: CupertinoIcons.xmark,
            color: p.muted,
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class ShoppingListDetailSheet extends StatelessWidget {
  const ShoppingListDetailSheet({required this.listId, super.key});

  final String listId;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    ShoppingList? list;
    for (final candidate in state.shoppingLists) {
      if (candidate.id == listId) {
        list = candidate;
        break;
      }
    }
    if (list == null) return const SizedBox.shrink();
    return Container(
      color: CupertinoColors.transparent,
      child: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GlassSurface(
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            radius: 26,
            tint: p.card,
            opacity: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 520),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SheetHeader(
                      icon: CupertinoIcons.cart,
                      title: list.name,
                      subtitle: _shoppingDate(list.createdAt),
                    ),
                    const SizedBox(height: 16),
                    for (var i = 0; i < list.items.length; i++)
                      _ShoppingCheckRow(
                        item: list.items[i],
                        onPressed: () => state.toggleShoppingListItem(
                          listId: list!.id,
                          itemIndex: i,
                        ),
                      ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        color: p.bg,
                        borderRadius: BorderRadius.circular(14),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          tx(context, 'Bezárás'),
                          style: TextStyle(
                            color: p.muted,
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
      ),
    );
  }
}

class _ShoppingCheckRow extends StatelessWidget {
  const _ShoppingCheckRow({required this.item, required this.onPressed});

  final ShoppingListItem item;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: p.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: p.border),
        ),
        child: Row(
          children: [
            _ShoppingCheckButton(checked: item.checked, onPressed: onPressed),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  color: item.checked ? p.muted : p.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: item.checked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShoppingCheckButton extends StatelessWidget {
  const _ShoppingCheckButton({required this.checked, required this.onPressed});

  final bool checked;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoButton(
      minimumSize: const Size(30, 30),
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Icon(
        checked
            ? CupertinoIcons.check_mark_circled_solid
            : CupertinoIcons.circle,
        color: checked ? p.accent : p.border,
        size: 24,
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: p.resultBg,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: p.resultBorder),
          ),
          child: Icon(icon, color: p.accent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: p.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              Text(subtitle, style: TextStyle(color: p.muted, fontSize: 13)),
            ],
          ),
        ),
        CupertinoButton(
          minimumSize: const Size(32, 32),
          padding: EdgeInsets.zero,
          color: p.bg,
          borderRadius: BorderRadius.circular(18),
          onPressed: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.xmark, color: p.muted, size: 17),
        ),
      ],
    );
  }
}

String _shoppingDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}. $month. $day.';
}

class _WarmBackButton extends StatelessWidget {
  const _WarmBackButton({this.size = 46, this.radius = 16, this.iconSize = 24});

  final double size;
  final double radius;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Align(
      alignment: Alignment.centerLeft,
      child: SpringPressable(
        pressedScale: 0.9,
        child: CupertinoButton(
          minimumSize: Size(size, size),
          padding: EdgeInsets.zero,
          color: p.card,
          borderRadius: BorderRadius.circular(radius),
          onPressed: () => Navigator.maybePop(context),
          child: Icon(
            CupertinoIcons.chevron_left,
            color: p.accent,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

class MealPrepScreen extends StatelessWidget {
  const MealPrepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final canCreatePlan = state.foods.isNotEmpty && state.canAddMealPrepPlan;
    return CupertinoPageScaffold(
      backgroundColor: p.bg,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: p.bg,
        border: Border(bottom: BorderSide(color: p.border)),
        leading: const _WarmBackButton(),
        middle: Text(tx(context, 'Meal Prep+')),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            14,
            14,
            14,
            AppLayout.screenBottomPadding,
          ),
          children: [
            if (!state.isPro) ...[
              AppCard(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Text(
                  tx(
                    context,
                    'Ingyenes módban 1 meal prep tervet menthetsz. A további tervekhez Pro szükséges.',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: p.muted,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                color: canCreatePlan ? p.accent : _disabledActionFill(state),
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: state.foods.isEmpty
                    ? null
                    : state.canAddMealPrepPlan
                    ? () => showCupertinoModalPopup<void>(
                        context: context,
                        barrierColor: const Color(0x99000000),
                        builder: (_) => const AddMealPrepSheet(),
                      )
                    : () => showProPaywallSheet(context),
                child: Text(
                  tx(context, 'Új meal prep terv'),
                  style: TextStyle(
                    color: canCreatePlan
                        ? p.buttonText
                        : _disabledActionText(state),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (state.foods.isEmpty) ...[
              const SizedBox(height: 12),
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Text(
                  tx(
                    context,
                    'Először ments el egy ételt a meal prep tervezéshez.',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SectionLabel(tx(context, 'Elmentett meal prep tervek')),
            if (state.mealPrepPlans.isEmpty)
              AppCard(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                child: Text(
                  tx(context, 'Még nincs elmentett meal prep terved.'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
                ),
              )
            else
              for (final plan in state.mealPrepPlans.reversed)
                _MealPrepPlanTile(plan: plan),
          ],
        ),
      ),
    );
  }
}

class _MealPrepPlanTile extends StatelessWidget {
  const _MealPrepPlanTile({required this.plan});

  final MealPrepPlan plan;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return AppCard(
      padding: EdgeInsets.zero,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        onPressed: () => showCupertinoModalPopup<void>(
          context: context,
          barrierColor: const Color(0x99000000),
          builder: (_) => MealPrepDetailSheet(planId: plan.id),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: p.resultBg,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: p.resultBorder),
              ),
              child: Icon(CupertinoIcons.archivebox, color: p.accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: p.text,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    plan.hasSide
                        ? '${plan.foodName} + ${plan.sideFoodName} · ${plan.portionCount} x'
                        : '${plan.foodName} · ${plan.portionCount} x ${grams(plan.portionWeight)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: p.muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${plan.completedBoxes}/${plan.portionCount}',
              style: TextStyle(color: p.accent, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Icon(CupertinoIcons.chevron_right, color: p.border, size: 18),
          ],
        ),
      ),
    );
  }
}

class AddMealPrepSheet extends StatefulWidget {
  const AddMealPrepSheet({this.plan, this.initialFood, super.key});

  final MealPrepPlan? plan;
  final FoodItem? initialFood;

  @override
  State<AddMealPrepSheet> createState() => _AddMealPrepSheetState();
}

class _AddMealPrepSheetState extends State<AddMealPrepSheet> {
  late final TextEditingController nameController;
  late final TextEditingController portionsController;
  late final TextEditingController portionWeightController;
  late final TextEditingController sidePortionWeightController;
  late final TextEditingController noteController;
  late MealPrepMode mode;
  FoodItem? selectedFood;
  FoodItem? selectedSideFood;

  @override
  void initState() {
    super.initState();
    final plan = widget.plan;
    mode = plan?.mode ?? MealPrepMode.divideTotal;
    nameController = TextEditingController(
      text: plan?.name ?? widget.initialFood?.name ?? '',
    );
    portionsController = TextEditingController(
      text: (plan?.portionCount ?? 4).toString(),
    );
    portionWeightController = TextEditingController(
      text: (plan?.portionWeight ?? 250).toStringAsFixed(0),
    );
    sidePortionWeightController = TextEditingController(
      text: (plan?.sidePortionWeight ?? 0).toStringAsFixed(0),
    );
    noteController = TextEditingController(text: plan?.note ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    portionsController.dispose();
    portionWeightController.dispose();
    sidePortionWeightController.dispose();
    noteController.dispose();
    super.dispose();
  }

  int get portionCount => int.tryParse(portionsController.text.trim()) ?? 0;

  double get portionWeight =>
      double.tryParse(
        portionWeightController.text.trim().replaceAll(',', '.'),
      ) ??
      0;

  double get sidePortionWeight =>
      double.tryParse(
        sidePortionWeightController.text.trim().replaceAll(',', '.'),
      ) ??
      0;

  bool get canSave =>
      selectedFood != null &&
      nameController.text.trim().isNotEmpty &&
      portionCount > 0 &&
      (mode == MealPrepMode.divideTotal || portionWeight > 0) &&
      (selectedSideFood == null ||
          mode == MealPrepMode.divideTotal ||
          sidePortionWeight > 0);

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final mainFoods = state.foods
        .where((food) => food.category == FoodCategory.main)
        .toList();
    final sideFoods = state.foods
        .where((food) => food.category == FoodCategory.side)
        .toList();
    final initialFood = widget.initialFood;
    selectedFood ??=
        _findFoodByName(state.foods, widget.plan?.foodName) ??
        (initialFood?.category == FoodCategory.main ? initialFood : null) ??
        (mainFoods.isNotEmpty
            ? mainFoods.first
            : state.foods.isNotEmpty
            ? state.foods.first
            : null);
    if (widget.plan?.sideFoodName != null && selectedSideFood == null) {
      selectedSideFood = _findFoodByName(
        state.foods,
        widget.plan!.sideFoodName,
      );
    } else if (initialFood?.category == FoodCategory.side &&
        selectedSideFood == null) {
      selectedSideFood = initialFood;
    }
    final food = selectedFood;
    final sideFood = selectedSideFood;
    final mainPortionWeight = mode == MealPrepMode.divideTotal
        ? (food == null || portionCount <= 0
              ? 0.0
              : food.cookedWeight / portionCount)
        : portionWeight;
    final totalCooked = mode == MealPrepMode.divideTotal
        ? (food?.cookedWeight ?? 0)
        : portionCount * portionWeight;
    final totalRaw = food == null || food.cookedWeight <= 0
        ? 0.0
        : food.rawWeight / food.cookedWeight * totalCooked;
    final effectiveSidePortionWeight = mode == MealPrepMode.divideTotal
        ? (sideFood == null || portionCount <= 0
              ? 0.0
              : sideFood.cookedWeight / portionCount)
        : sidePortionWeight;
    final sideTotalCooked = mode == MealPrepMode.divideTotal
        ? (sideFood?.cookedWeight ?? 0)
        : sideFood == null
        ? 0.0
        : portionCount * sidePortionWeight;
    final sideTotalRaw = sideFood == null || sideFood.cookedWeight <= 0
        ? 0.0
        : sideFood.rawWeight / sideFood.cookedWeight * sideTotalCooked;
    final multiplier = food == null || food.cookedWeight <= 0
        ? 0.0
        : totalCooked / food.cookedWeight;
    final sideMultiplier = sideFood == null || sideFood.cookedWeight <= 0
        ? 0.0
        : sideTotalCooked / sideFood.cookedWeight;

    return Container(
      color: CupertinoColors.transparent,
      child: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GlassSurface(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
            radius: 26,
            tint: p.card,
            opacity: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 610),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SheetHeader(
                      icon: CupertinoIcons.archivebox,
                      title: tx(
                        context,
                        widget.plan == null
                            ? 'Új meal prep terv'
                            : 'Meal prep terv szerkesztése',
                      ),
                      subtitle: tx(
                        context,
                        'Válassz főételt, köretet és adagold dobozokra',
                      ),
                    ),
                    const SizedBox(height: 10),
                    _Input(
                      controller: nameController,
                      placeholder: tx(context, 'Terv neve'),
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _MealPrepModeButton(
                          label: tx(context, 'Teljes mennyiség elosztása'),
                          active: mode == MealPrepMode.divideTotal,
                          onTap: () =>
                              setState(() => mode = MealPrepMode.divideTotal),
                        ),
                        const SizedBox(width: 8),
                        _MealPrepModeButton(
                          label: tx(context, 'Fix adagméret'),
                          active: mode == MealPrepMode.fixedPortion,
                          onTap: () =>
                              setState(() => mode = MealPrepMode.fixedPortion),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      mode == MealPrepMode.divideTotal
                          ? tx(
                              context,
                              'Az app a mentett kész mennyiséget osztja el az adagok között.',
                            )
                          : tx(
                              context,
                              'Te adod meg, hány gramm kerüljön egy adagba.',
                            ),
                      style: TextStyle(
                        color: p.muted,
                        fontSize: 13,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tx(context, 'Főétel'),
                      style: TextStyle(
                        color: p.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _MealPrepFoodPicker(
                      foods: mainFoods.isEmpty ? state.foods : mainFoods,
                      selected: selectedFood,
                      onSelected: (food) => setState(() => selectedFood = food),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tx(context, 'Köret hozzáadása'),
                      style: TextStyle(
                        color: p.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _MealPrepFoodPicker(
                      foods: sideFoods,
                      selected: selectedSideFood,
                      optionalLabel: tx(context, 'Nincs köret'),
                      onSelected: (food) =>
                          setState(() => selectedSideFood = food),
                      onClear: () => setState(() => selectedSideFood = null),
                    ),
                    if (mode == MealPrepMode.divideTotal)
                      _Input(
                        controller: portionsController,
                        placeholder: tx(context, 'Adagok'),
                        numericTitle: tx(context, 'Adagok'),
                        onChanged: () => setState(() {}),
                      )
                    else ...[
                      Row(
                        children: [
                          Expanded(
                            child: _Input(
                              controller: portionsController,
                              placeholder: tx(context, 'Adagok'),
                              numericTitle: tx(context, 'Adagok'),
                              onChanged: () => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _Input(
                              controller: portionWeightController,
                              placeholder: tx(context, 'Főétel g / adag'),
                              numericTitle: tx(context, 'Főétel g / adag'),
                              onChanged: () => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                      if (selectedSideFood != null)
                        _Input(
                          controller: sidePortionWeightController,
                          placeholder: tx(context, 'Köret g / adag'),
                          numericTitle: tx(context, 'Köret g / adag'),
                          onChanged: () => setState(() {}),
                        ),
                    ],
                    _Input(
                      controller: noteController,
                      placeholder: tx(context, 'Megjegyzés'),
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 4),
                    AppCard(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      color: p.resultBg,
                      child: Column(
                        children: [
                          _MealPrepResultRow(
                            label: tx(context, 'Főétel adag / doboz'),
                            value: grams(mainPortionWeight),
                          ),
                          _MealPrepResultRow(
                            label: tx(context, 'Szükséges kész főétel'),
                            value: grams(totalCooked),
                          ),
                          _MealPrepResultRow(
                            label: tx(context, 'Szükséges nyers főétel'),
                            value: grams(totalRaw),
                          ),
                          _MealPrepResultRow(
                            label: tx(context, 'Főétel recept szorzó'),
                            value: '${multiplier.toStringAsFixed(2)}x',
                          ),
                          if (sideFood != null) ...[
                            _MealPrepResultRow(
                              label: tx(context, 'Köret adag / doboz'),
                              value: grams(effectiveSidePortionWeight),
                            ),
                            _MealPrepResultRow(
                              label: tx(context, 'Szükséges kész köret'),
                              value: grams(sideTotalCooked),
                            ),
                            _MealPrepResultRow(
                              label: tx(context, 'Szükséges nyers köret'),
                              value: grams(sideTotalRaw),
                            ),
                            _MealPrepResultRow(
                              label: tx(context, 'Köret recept szorzó'),
                              value: '${sideMultiplier.toStringAsFixed(2)}x',
                            ),
                          ],
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                            color: p.bg,
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            borderRadius: BorderRadius.circular(14),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              tx(context, 'Mégse'),
                              style: TextStyle(color: p.muted),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: CupertinoButton(
                            color: canSave
                                ? p.accent
                                : _disabledActionFill(state),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            borderRadius: BorderRadius.circular(14),
                            onPressed: canSave
                                ? () {
                                    if (widget.plan == null) {
                                      state.addMealPrepPlan(
                                        name: nameController.text,
                                        food: selectedFood!,
                                        sideFood: selectedSideFood,
                                        mode: mode,
                                        portionCount: portionCount,
                                        portionWeight: mainPortionWeight,
                                        sidePortionWeight:
                                            effectiveSidePortionWeight,
                                        note: noteController.text,
                                      );
                                    } else {
                                      state.updateMealPrepPlan(
                                        id: widget.plan!.id,
                                        name: nameController.text,
                                        food: selectedFood!,
                                        sideFood: selectedSideFood,
                                        mode: mode,
                                        portionCount: portionCount,
                                        portionWeight: mainPortionWeight,
                                        sidePortionWeight:
                                            effectiveSidePortionWeight,
                                        note: noteController.text,
                                      );
                                    }
                                    Navigator.pop(context);
                                  }
                                : null,
                            child: Text(
                              tx(context, 'Mentés'),
                              style: TextStyle(
                                color: canSave
                                    ? p.buttonText
                                    : _disabledActionText(state),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  FoodItem? _findFoodByName(List<FoodItem> foods, String? name) {
    if (name == null) return null;
    for (final food in foods) {
      if (food.name == name) return food;
    }
    return null;
  }
}

class _MealPrepFoodPicker extends StatelessWidget {
  const _MealPrepFoodPicker({
    required this.foods,
    required this.selected,
    required this.onSelected,
    this.optionalLabel,
    this.onClear,
  });

  final List<FoodItem> foods;
  final FoodItem? selected;
  final ValueChanged<FoodItem> onSelected;
  final String? optionalLabel;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    if (foods.isEmpty && optionalLabel == null) {
      return Text(
        tx(context, 'Nincs mentett étel'),
        style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
      );
    }
    return Column(
      children: [
        if (optionalLabel != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _MealPrepFoodOption(
              label: optionalLabel!,
              active: selected == null,
              onPressed: onClear ?? () {},
            ),
          ),
        for (final item in foods)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _MealPrepFoodOption(
              label: item.name,
              active: item.id == selected?.id,
              onPressed: () => onSelected(item),
            ),
          ),
      ],
    );
  }
}

class _MealPrepModeButton extends StatelessWidget {
  const _MealPrepModeButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Expanded(
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        color: active ? p.accent : p.bg,
        borderRadius: BorderRadius.circular(12),
        onPressed: onTap,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: TextStyle(
              color: active ? p.buttonText : p.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _MealPrepFoodOption extends StatelessWidget {
  const _MealPrepFoodOption({
    required this.label,
    required this.active,
    required this.onPressed,
  });

  final String label;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: active ? p.resultBg : p.bg.withValues(alpha: 0.76),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? p.resultBorder : p.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: p.text, fontWeight: FontWeight.w600),
              ),
            ),
            if (active)
              Icon(CupertinoIcons.check_mark_circled_solid, color: p.accent),
          ],
        ),
      ),
    );
  }
}

class _MealPrepResultRow extends StatelessWidget {
  const _MealPrepResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: p.accent, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: TextStyle(color: p.accent, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class MealPrepDetailSheet extends StatelessWidget {
  const MealPrepDetailSheet({required this.planId, super.key});

  final String planId;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    MealPrepPlan? plan;
    for (final candidate in state.mealPrepPlans) {
      if (candidate.id == planId) {
        plan = candidate;
        break;
      }
    }
    if (plan == null) return const SizedBox.shrink();
    return Container(
      color: CupertinoColors.transparent,
      child: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GlassSurface(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
            radius: 26,
            tint: p.card,
            opacity: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 560),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SheetHeader(
                      icon: CupertinoIcons.archivebox,
                      title: plan.name,
                      subtitle:
                          '${plan.hasSide ? '${plan.foodName} + ${plan.sideFoodName}' : plan.foodName} · ${_shoppingDate(plan.createdAt)}',
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                            color: p.bg,
                            borderRadius: BorderRadius.circular(14),
                            onPressed: () => showCupertinoModalPopup<void>(
                              context: context,
                              barrierColor: const Color(0x99000000),
                              builder: (_) => AddMealPrepSheet(plan: plan),
                            ),
                            child: Text(
                              tx(context, 'Szerkesztés'),
                              style: TextStyle(
                                color: p.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CupertinoButton(
                            color: p.deleteBg,
                            borderRadius: BorderRadius.circular(14),
                            onPressed: () {
                              state.deleteMealPrepPlan(plan!.id);
                              Navigator.pop(context);
                            },
                            child: Text(
                              tx(context, 'Törlés'),
                              style: const TextStyle(
                                color: Color(0xFFC04040),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AppCard(
                      color: p.resultBg,
                      child: Column(
                        children: [
                          _MealPrepResultRow(
                            label: tx(context, 'Szükséges kész főétel'),
                            value: grams(plan.totalCookedNeeded),
                          ),
                          _MealPrepResultRow(
                            label: tx(context, 'Szükséges nyers főétel'),
                            value: grams(plan.totalRawNeeded),
                          ),
                          _MealPrepResultRow(
                            label: tx(context, 'Egy adag nyers egyenértéke'),
                            value: grams(plan.rawPerPortion),
                          ),
                          _MealPrepResultRow(
                            label: tx(context, 'Főétel recept szorzó'),
                            value:
                                '${plan.recipeMultiplier.toStringAsFixed(2)}x',
                          ),
                          if (plan.hasSide) ...[
                            _MealPrepResultRow(
                              label: tx(context, 'Szükséges kész köret'),
                              value: grams(plan.sideTotalCookedNeeded),
                            ),
                            _MealPrepResultRow(
                              label: tx(context, 'Szükséges nyers köret'),
                              value: grams(plan.sideTotalRawNeeded),
                            ),
                            _MealPrepResultRow(
                              label: tx(context, 'Köret nyers egyenértéke'),
                              value: grams(plan.sideRawPerPortion),
                            ),
                            _MealPrepResultRow(
                              label: tx(context, 'Köret recept szorzó'),
                              value:
                                  '${plan.sideRecipeMultiplier.toStringAsFixed(2)}x',
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (plan.note.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        plan.note,
                        style: TextStyle(
                          color: p.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Text(
                      tx(context, 'Dobozok'),
                      style: TextStyle(
                        color: p.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    for (var i = 0; i < plan.boxes.length; i++)
                      _MealPrepBoxRow(
                        index: i,
                        checked: plan.boxes[i],
                        onPressed: () => state.toggleMealPrepBox(
                          planId: plan!.id,
                          boxIndex: i,
                        ),
                      ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        color: p.bg,
                        borderRadius: BorderRadius.circular(14),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          tx(context, 'Bezárás'),
                          style: TextStyle(
                            color: p.muted,
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
      ),
    );
  }
}

class _MealPrepBoxRow extends StatelessWidget {
  const _MealPrepBoxRow({
    required this.index,
    required this.checked,
    required this.onPressed,
  });

  final int index;
  final bool checked;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: p.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: p.border),
        ),
        child: Row(
          children: [
            Icon(
              checked
                  ? CupertinoIcons.check_mark_circled_solid
                  : CupertinoIcons.circle,
              color: checked ? p.accent : p.border,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${index + 1}. ${tx(context, 'adag')}',
                style: TextStyle(
                  color: checked ? p.muted : p.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: checked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddFoodSheet extends StatefulWidget {
  const AddFoodSheet({super.key});

  @override
  State<AddFoodSheet> createState() => _AddFoodSheetState();
}

class _AddFoodSheetState extends State<AddFoodSheet> {
  FoodCategory category = FoodCategory.main;
  final name = TextEditingController();
  final raw = TextEditingController();
  final cooked = TextEditingController();
  final served = TextEditingController();
  final nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) nameFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    name.dispose();
    raw.dispose();
    cooked.dispose();
    served.dispose();
    nameFocus.dispose();
    super.dispose();
  }

  double _num(TextEditingController controller) =>
      double.tryParse(controller.text.replaceAll(',', '.')) ?? 0;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final canAddMain = state.canAddFood(FoodCategory.main);
    final canAddSide = state.canAddFood(FoodCategory.side);
    final canAddSelected = state.canAddFood(category);
    final result = rawEquivalent(
      rawWeight: _num(raw),
      cookedWeight: _num(cooked),
      servedWeight: _num(served),
    );

    if (!canAddSelected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (canAddMain) {
          setState(() => category = FoodCategory.main);
        } else if (canAddSide) {
          setState(() => category = FoodCategory.side);
        }
      });
    }

    return GlassSurface(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      radius: 26,
      tint: p.card,
      opacity: 1,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                tx(context, 'Új étel hozzáadása'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: p.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _CategoryButton(
                  label: tx(context, 'Főétel'),
                  active: category == FoodCategory.main,
                  enabled: canAddMain,
                  onTap: () => setState(() => category = FoodCategory.main),
                ),
                const SizedBox(width: 8),
                _CategoryButton(
                  label: tx(context, 'Köret'),
                  active: category == FoodCategory.side,
                  enabled: canAddSide,
                  onTap: () => setState(() => category = FoodCategory.side),
                ),
              ],
            ),
            const SizedBox(height: 6),
            _Input(
              controller: name,
              placeholder: tx(context, 'Étel neve'),
              focusNode: nameFocus,
              autofocus: true,
              onChanged: () => setState(() {}),
            ),
            Row(
              children: [
                Expanded(
                  child: _Input(
                    controller: raw,
                    placeholder: tx(context, 'Nyers g'),
                    numericTitle: tx(context, 'Nyers adag'),
                    onChanged: () => setState(() {}),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: _Input(
                    controller: cooked,
                    placeholder: tx(context, 'Kész g'),
                    numericTitle: tx(context, 'Kész súly'),
                    onChanged: () => setState(() {}),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: _Input(
                    controller: served,
                    placeholder: tx(context, 'Kimért g'),
                    numericTitle: tx(context, 'Kimért adag'),
                    onChanged: () => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              decoration: BoxDecoration(
                color: p.resultBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: p.resultBorder),
              ),
              child: Row(
                children: [
                  Text(
                    tx(context, 'Nyers egyenérték'),
                    style: TextStyle(
                      color: p.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    result <= 0 ? '- g' : grams(result),
                    style: TextStyle(
                      color: p.accent,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    color: p.bg,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    borderRadius: BorderRadius.circular(14),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      tx(context, 'Mégse'),
                      style: TextStyle(color: p.muted),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: CupertinoButton(
                    color: canAddSelected
                        ? p.accent
                        : _disabledActionFill(state),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    borderRadius: BorderRadius.circular(14),
                    onPressed: canAddSelected
                        ? () {
                            state.addFood(
                              name: name.text,
                              category: category,
                              rawWeight: _num(raw),
                              cookedWeight: _num(cooked),
                              servedWeight: _num(served),
                            );
                            Navigator.pop(context);
                          }
                        : null,
                    child: Text(
                      tx(context, 'Mentés'),
                      style: TextStyle(
                        color: canAddSelected
                            ? p.buttonText
                            : _disabledActionText(state),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.label,
    required this.active,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Expanded(
      child: CupertinoButton(
        color: active ? p.accent : p.bg,
        padding: const EdgeInsets.symmetric(vertical: 8),
        borderRadius: BorderRadius.circular(14),
        onPressed: enabled ? onTap : null,
        child: Text(
          label,
          style: TextStyle(
            color: active ? p.buttonText : p.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({
    required this.controller,
    required this.placeholder,
    required this.onChanged,
    this.numericTitle,
    this.focusNode,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String placeholder;
  final VoidCallback onChanged;
  final String? numericTitle;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    final isNumeric = numericTitle != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: CupertinoTextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        placeholder: placeholder,
        keyboardType: isNumeric
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        onChanged: (_) => onChanged(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        style: TextStyle(color: p.text, fontWeight: FontWeight.w600),
        placeholderStyle: TextStyle(color: p.muted),
        decoration: BoxDecoration(
          color: p.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: p.border),
        ),
      ),
    );
  }
}

class ProCompactUpsellCard extends StatelessWidget {
  const ProCompactUpsellCard({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => showProPaywallSheet(context),
      child: GlassSurface(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        radius: 20,
        tint: p.resultBg,
        opacity: 1,
        borderColor: p.resultBorder.withValues(alpha: 0.72),
        child: Row(
          children: [
            const MealWeightMark(size: 42, radius: 13),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx(context, 'Mealr Pro'),
                    style: TextStyle(
                      color: p.text,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    tx(
                      context,
                      'Több mentés, bevásárlólisták, súlykövetés extrák',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: p.muted,
                      fontSize: 13,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: p.accent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tx(context, 'Részletek'),
                    style: TextStyle(
                      color: p.buttonText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    CupertinoIcons.chevron_up,
                    color: p.buttonText,
                    size: 13,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProUpsellCard extends StatelessWidget {
  const ProUpsellCard({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return GlassSurface(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      radius: 26,
      tint: p.resultBg,
      opacity: 1,
      borderColor: p.resultBorder.withValues(alpha: 0.72),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                child: const MealWeightMark(size: 44, radius: 14),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx(context, 'Mealr Pro'),
                      style: TextStyle(
                        color: p.text,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.6,
                      ),
                    ),
                    Text(
                      tx(context, 'Korlátlan mentés és extra funkciók'),
                      style: TextStyle(
                        color: p.muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              CupertinoButton(
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
                color: p.bg,
                borderRadius: BorderRadius.circular(18),
                onPressed: () => Navigator.maybePop(context),
                child: Icon(CupertinoIcons.xmark, color: p.muted, size: 17),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PaywallFeatureSections(),
          const SizedBox(height: 12),
          _PricingCard(),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              color: p.accent,
              borderRadius: BorderRadius.circular(18),
              onPressed: () {},
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tx(context, 'Próbáld ki ingyen 7 napig'),
                  maxLines: 1,
                  style: TextStyle(
                    color: p.buttonText,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            tx(
              context,
              'Az összeget csak a 7. nap után vonjuk le · Bármikor lemondható',
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: p.muted,
              fontSize: 12,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaywallFeatureSections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PaywallFeatureGroup(
          title: tx(context, 'Ingyenes alapok'),
          subtitle: tx(context, 'Amit már most használhatsz'),
          accent: false,
          features: [
            _PaywallFeature(
              icon: CupertinoIcons.square_list,
              title: tx(context, 'Főétel mentés'),
              limit: '1 ${tx(context, 'db')}',
            ),
            _PaywallFeature(
              icon: CupertinoIcons.circle_grid_3x3,
              title: tx(context, 'Köret mentés'),
              limit: '1 ${tx(context, 'db')}',
            ),
            _PaywallFeature(
              icon: CupertinoIcons.archivebox,
              title: tx(context, 'Meal Prep tervező'),
              limit: '1 ${tx(context, 'db')}',
            ),
            _PaywallFeature(
              icon: CupertinoIcons.book,
              title: tx(context, 'Receptek'),
            ),
            _PaywallFeature(
              icon: CupertinoIcons.chart_bar,
              title: tx(context, 'Súlykövetés diagram'),
              limit: '7 ${tx(context, 'nap')}',
            ),
          ],
        ),
        const SizedBox(height: 8),
        _PaywallFeatureGroup(
          title: tx(context, 'Pro-val feloldható extrák'),
          subtitle: tx(context, 'Rendszeres használathoz'),
          accent: true,
          features: [
            _PaywallFeature(
              icon: CupertinoIcons.infinite,
              title: tx(context, 'Korlátlan étel és meal prep mentés'),
            ),
            _PaywallFeature(
              icon: CupertinoIcons.cart_badge_plus,
              title: tx(context, 'Bevásárlás+ listák'),
            ),
            _PaywallFeature(
              icon: CupertinoIcons.calendar,
              title: tx(context, 'Étrendek'),
            ),
            _PaywallFeature(
              icon: CupertinoIcons.share,
              title: tx(context, 'Étel megosztás'),
            ),
            _PaywallFeature(
              icon: CupertinoIcons.chart_bar_alt_fill,
              title: tx(context, '30/60 napos súlydiagram és statisztika'),
            ),
            _PaywallFeature(
              icon: CupertinoIcons.pencil,
              title: tx(context, 'Súlynapló szerkesztés'),
            ),
            _PaywallFeature(
              icon: CupertinoIcons.paintbrush,
              title: tx(context, 'Témák (6 db)'),
            ),
          ],
        ),
      ],
    );
  }
}

class _PaywallFeatureGroup extends StatelessWidget {
  const _PaywallFeatureGroup({
    required this.title,
    required this.subtitle,
    required this.features,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final List<_PaywallFeature> features;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 5),
      decoration: BoxDecoration(
        color: accent ? p.resultBg : p.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accent ? p.resultBorder : p.border,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: accent ? p.accent : p.text,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: p.muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          for (final feature in features) _PaywallFeatureRow(feature: feature),
        ],
      ),
    );
  }
}

class _PaywallFeature {
  const _PaywallFeature({required this.icon, required this.title, this.limit});

  final IconData icon;
  final String title;
  final String? limit;
}

class _PaywallFeatureRow extends StatelessWidget {
  const _PaywallFeatureRow({required this.feature});

  final _PaywallFeature feature;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: p.bg.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: p.border.withValues(alpha: 0.7)),
            ),
            child: Icon(feature.icon, color: p.accent, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              feature.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: p.text,
                fontSize: 13,
                height: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (feature.limit != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: p.bg.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: p.border.withValues(alpha: 0.72)),
              ),
              child: Text(
                feature.limit!,
                style: TextStyle(
                  color: p.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    final radius = BorderRadius.circular(16);
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: radius,
          border: Border.all(color: p.border, width: 1.2),
        ),
        child: Column(
          children: [
            _PricingRow(
              title: tx(context, 'Havi előfizetés'),
              subtitle: tx(context, 'Bármikor lemondható'),
              price: '1.99€',
              suffix: tx(context, '/hó'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Container(height: 1, color: p.border),
            ),
            _PricingRow(
              title: tx(context, 'Éves előfizetés'),
              subtitle: tx(context, '= 1.00€/hó · legjobb ár'),
              price: '11.99€',
              suffix: tx(context, '/év'),
              badge: '−50%',
            ),
          ],
        ),
      ),
    );
  }
}

class _PricingRow extends StatelessWidget {
  const _PricingRow({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.suffix,
    this.badge,
  });

  final String title;
  final String subtitle;
  final String price;
  final String suffix;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: p.text,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: p.noteColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: p.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                  text: price,
                  style: TextStyle(
                    color: p.accent,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: suffix),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
