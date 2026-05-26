import 'package:flutter/cupertino.dart';

import '../../app/app_layout.dart';
import '../../app/app_state.dart';
import '../../app/app_strings.dart';
import '../../models/food_item.dart';
import '../../models/meal_prep_plan.dart';
import '../../models/recipe.dart';
import '../../models/shopping_list.dart';
import '../../services/share_service.dart';
import '../../theme/app_typography.dart';
import '../../utils/app_haptics.dart';
import '../../utils/calculators.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_components.dart';
import '../../widgets/app_sheet.dart';
import '../../widgets/glass_surface.dart';
import '../../widgets/mealweight_mark.dart';
import '../../widgets/spring_pressable.dart';
import 'recipe_library.dart';

final _greetingMottoSeed = DateTime.now().microsecondsSinceEpoch;

const _homeStripItemGap = 8.0;

void _showAddFoodSheet(
  BuildContext context, {
  FoodCategory initialCategory = FoodCategory.main,
  bool allowCategorySelection = true,
}) {
  showCupertinoModalPopup<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: const Color(0x99000000),
    builder: (_) => AddFoodSheet(
      initialCategory: initialCategory,
      allowCategorySelection: allowCategorySelection,
    ),
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
        16,
        16,
        16,
        AppLayout.screenBottomPadding,
      ),
      children: [
        const _MealGreeting(),
        const SizedBox(height: 22),
        _FoodSectionHeader(
          label: tx(context, 'Főételek'),
          freeCount: state.isPro ? null : mainFoods.length.clamp(0, 1),
        ),
        if (mainFoods.isEmpty)
          _EmptyFoodMessage(
            tx(context, 'Még nincs főétel hozzáadva.'),
            actionLabel: tx(context, 'Hozzáadás'),
            onAction: () => _showAddFoodSheet(
              context,
              initialCategory: FoodCategory.main,
              allowCategorySelection: false,
            ),
          ),
        for (final food in mainFoods) FoodTile(food: food),
        _FoodSectionHeader(
          label: tx(context, 'Köretek'),
          freeCount: state.isPro ? null : sideFoods.length.clamp(0, 1),
        ),
        if (sideFoods.isEmpty)
          _EmptyFoodMessage(
            tx(context, 'Még nincs köret hozzáadva.'),
            actionLabel: tx(context, 'Hozzáadás'),
            onAction: () => _showAddFoodSheet(
              context,
              initialCategory: FoodCategory.side,
              allowCategorySelection: false,
            ),
          ),
        for (final food in sideFoods) FoodTile(food: food),
        const SizedBox(height: 11),
        Row(
          children: [
            Expanded(
              child: _ActionPillButton(
                icon: CupertinoIcons.plus,
                label: tx(context, 'Új étel'),
                enabled: canAddFood,
                onPressed: () => _showAddFoodSheet(context),
              ),
            ),
            const SizedBox(width: 9),
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
        const SizedBox(height: 12),
        const _HomeDiscoveryBlock(),
      ],
    );
  }
}

class _HomeDiscoveryBlock extends StatelessWidget {
  const _HomeDiscoveryBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(tx(context, 'Receptek')),
        const _RecipeCategoryStrip(),
        const SizedBox(height: 12),
        SectionLabel(tx(context, 'Étrendek')),
        const _DietPlanStrip(),
      ],
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
      height: 82,
      child: Row(
        children: [
          for (var index = 0; index < categories.length; index++) ...[
            if (index > 0) const SizedBox(width: _homeStripItemGap),
            Expanded(child: _RecipeCategoryPill(category: categories[index])),
          ],
        ],
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
    final state = AppScope.of(context);
    final p = state.palette;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: category.onPressed,
      child: SpringPressable(
        enabled: category.onPressed != null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          decoration: BoxDecoration(
            color: p.card,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: p.border.withValues(alpha: state.isDark ? 0.58 : 0.30),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 29,
                height: 29,
                child: CustomPaint(
                  painter: _RecipeCategoryIconPainter(
                    icon: category.icon,
                    color: _recipeCategoryIconColor(category.icon),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  category.label,
                  maxLines: 1,
                  style: MealText.bodyStrong(p.text).copyWith(fontSize: 13),
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
        _paintCloche(canvas, size, stroke, fill);
      case _RecipeCategoryIcon.snack:
        _paintChips(canvas, size, stroke, fill);
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

  void _paintCloche(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final dome = Path()
      ..moveTo(size.width * 0.17, size.height * 0.66)
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.41,
        size.width * 0.34,
        size.height * 0.30,
        size.width * 0.50,
        size.height * 0.30,
      )
      ..cubicTo(
        size.width * 0.66,
        size.height * 0.30,
        size.width * 0.80,
        size.height * 0.41,
        size.width * 0.83,
        size.height * 0.66,
      )
      ..close();
    canvas.drawPath(dome, fill);
    canvas.drawPath(dome, stroke);
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.68),
      Offset(size.width * 0.88, size.height * 0.68),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.23, size.height * 0.76),
      Offset(size.width * 0.77, size.height * 0.76),
      stroke,
    );
    canvas.drawArc(
      Rect.fromLTWH(
        size.width * 0.43,
        size.height * 0.19,
        size.width * 0.14,
        size.height * 0.13,
      ),
      3.14,
      3.14,
      false,
      stroke,
    );
  }

  void _paintChips(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final bag = Path()
      ..moveTo(size.width * 0.27, size.height * 0.17)
      ..lineTo(size.width * 0.73, size.height * 0.17)
      ..lineTo(size.width * 0.78, size.height * 0.76)
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.84,
        size.width * 0.22,
        size.height * 0.76,
      )
      ..close();
    canvas.drawPath(bag, fill);
    canvas.drawPath(bag, stroke);
    canvas.drawLine(
      Offset(size.width * 0.28, size.height * 0.27),
      Offset(size.width * 0.72, size.height * 0.27),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.69),
      Offset(size.width * 0.75, size.height * 0.69),
      stroke,
    );
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.37,
        size.height * 0.38,
        size.width * 0.27,
        size.height * 0.20,
      ),
      stroke,
    );
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
      _DietPlanOption(
        calories: 2000,
        active: true,
        onPressed: state.isPro
            ? () => Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (_) => const DietPlanTypeScreen(calories: 2000),
                ),
              )
            : () => showProPaywallSheet(context),
      ),
      _DietPlanOption(
        calories: 2500,
        active: true,
        onPressed: state.isPro
            ? () => Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (_) => const DietPlanTypeScreen(calories: 2500),
                ),
              )
            : () => showProPaywallSheet(context),
      ),
      _DietPlanOption(
        calories: 3000,
        active: true,
        onPressed: state.isPro
            ? () => Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (_) => const DietPlanTypeScreen(calories: 3000),
                ),
              )
            : () => showProPaywallSheet(context),
      ),
    ];

    return SizedBox(
      height: 84,
      child: Row(
        children: [
          for (var index = 0; index < plans.length; index++) ...[
            if (index > 0) const SizedBox(width: _homeStripItemGap),
            Expanded(child: _DietPlanPill(option: plans[index])),
          ],
        ],
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
    final state = AppScope.of(context);
    final p = state.palette;
    final enabled = option.active && option.onPressed != null;
    final locked = enabled && !state.isPro;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: enabled ? option.onPressed : null,
      child: SpringPressable(
        enabled: enabled,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
          decoration: BoxDecoration(
            color: p.card,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: enabled
                  ? p.border.withValues(alpha: state.isDark ? 0.62 : 0.34)
                  : p.border.withValues(alpha: state.isDark ? 0.48 : 0.26),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${option.calories}',
                style: MealText.sheetTitle(
                  enabled ? p.accent : p.text,
                ).copyWith(fontSize: 19, letterSpacing: -0.2),
              ),
              const SizedBox(height: 1),
              Text('kcal', style: MealText.captionStrong(p.muted)),
              if (locked || !enabled) ...[
                const SizedBox(height: 1),
                Text(
                  locked ? tx(context, 'Pro') : tx(context, 'Hamarosan'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: MealText.captionStrong(
                    p.muted.withValues(alpha: 0.72),
                  ).copyWith(fontSize: 9.5, height: 1),
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
  const _EmptyFoodMessage(
    this.message, {
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final emptyColor = p.muted.withValues(alpha: state.isDark ? 0.82 : 0.76);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(2, 6, 4, 30),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: emptyColor, size: 15),
            const SizedBox(width: 8),
          ],
          Expanded(child: Text(message, style: MealText.callout(emptyColor))),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(width: 8),
            CupertinoButton(
              minimumSize: const Size(0, 30),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: p.card,
              borderRadius: BorderRadius.circular(999),
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: MealText.captionStrong(p.accent),
              ),
            ),
          ],
        ],
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
      padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
      child: Row(
        children: [
          SizedBox(
            width: 38,
            height: 38,
            child: Icon(greeting.icon, color: greeting.color, size: 29),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx(context, greeting.title),
                  style: MealText.title(p.text).copyWith(letterSpacing: 0),
                ),
                const SizedBox(height: 3),
                Text(
                  tx(context, greeting.subtitle),
                  style: MealText.caption(p.muted),
                ),
              ],
            ),
          ),
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
      'Kezdj egyszerűen, maradj következetes.',
      'Tervezz egy nyugodt, erős napot.',
      'Építsd fel a mai napot étkezésről étkezésre.',
      'Indítsd tudatosan a reggelt.',
      'Legyen az első döntés könnyű.',
    ];
    return (
      title: 'Jó reggelt',
      subtitle: _startupMotto(mottos),
      icon: CupertinoIcons.sun_max,
      color: const Color(0xFFC6A34A),
    );
  }
  if (hour >= 11 && hour < 14) {
    final mottos = [
      'Tartsd kézben az étkezéseidet.',
      'Kis döntések, stabil lendület.',
      'Maradj feltöltve és fókuszban.',
      'Legyen egyszerű a következő étkezés.',
      'Egy kiegyensúlyozott tányér stabilan tartja a napot.',
    ];
    return (
      title: 'Szép napot',
      subtitle: _startupMotto(mottos),
      icon: CupertinoIcons.sun_max_fill,
      color: const Color(0xFFC6A34A),
    );
  }
  if (hour >= 14 && hour < 18) {
    final mottos = [
      'Készítsd elő, ami később könnyít.',
      'Tervezd meg a vacsorát még a rohanás előtt.',
      'Egy kis előkészítés sokat számít.',
      'Legyen a délután könnyű és hasznos.',
      'Adj előnyt az estédnek.',
    ];
    return (
      title: 'Jó délutánt',
      subtitle: _startupMotto(mottos),
      icon: CupertinoIcons.cloud_sun,
      color: const Color(0xFFB98758),
    );
  }
  final mottos = [
    'Zárd a napot valami táplálóval.',
    'Lassíts, egyél jól, pihenj könnyen.',
    'Zárd gondoskodással a napot.',
    'A holnap a ma esti előkészítéssel indul.',
    'Zárd a napot jóllakottan, nem rohanva.',
  ];
  return (
    title: 'Jó estét',
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

enum _DietPlanKind {
  highProtein,
  glutenFree,
  vegetarian,
  quick,
  budget,
  mealPrep,
}

List<DietDayPlan> _dietPlansFor(int calories, _DietPlanKind kind) {
  if (calories == 1500) {
    final basePlans = switch (kind) {
      _DietPlanKind.highProtein => _highProtein1500Plans,
      _DietPlanKind.glutenFree => _glutenFree1500Plans,
      _DietPlanKind.vegetarian => _vegetarian1500Plans,
      _DietPlanKind.quick => _quick1500Plans,
      _DietPlanKind.budget => _budget1500Plans,
      _DietPlanKind.mealPrep => _mealPrep1500Plans,
    };
    return [
      for (final plan in basePlans) _retargetDietPlan(plan, calories),
      ..._generatedDietPlansFor(
        calories: calories,
        kind: kind,
        startIndex: 6,
        count: 2,
      ),
    ];
  }

  final calorieOffset = switch (calories) {
    2000 => 0,
    2500 => 2,
    3000 => 4,
    _ => 0,
  };
  return _generatedDietPlansFor(
    calories: calories,
    kind: kind,
    startIndex: calorieOffset,
    count: 4,
  );
}

List<DietDayPlan> _generatedDietPlansFor({
  required int calories,
  required _DietPlanKind kind,
  required int startIndex,
  required int count,
}) {
  final names = switch (kind) {
    _DietPlanKind.highProtein => [
      'Izmos nap',
      'Sportos nap',
      'Erő plusz nap',
      'Aktív nap',
      'Fehérje fókusz nap',
      'Teljesítmény nap',
      'Stabil erő nap',
      'Fit lendület nap',
    ],
    _DietPlanKind.glutenFree => [
      'Tiszta energia nap',
      'Könnyed nap',
      'Mentes lendület nap',
      'Friss mentes nap',
      'Nyugodt energia nap',
      'Kímélő nap',
      'Tiszta ritmus nap',
      'Laza mentes nap',
    ],
    _DietPlanKind.vegetarian => [
      'Növényi nap',
      'Zöld lendület nap',
      'Veggie erő nap',
      'Kert nap',
      'Zöld fókusz nap',
      'Húsmentes lendület nap',
      'Friss zöld nap',
      'Növényi ritmus nap',
    ],
    _DietPlanKind.quick => [
      'Villám nap',
      'Pörgős nap',
      'Gyors rutin nap',
      'Tempós tál nap',
      'Sietős lendület nap',
      'Egyszerű tempó nap',
      'Rövid konyha nap',
      'Gyors fókusz nap',
    ],
    _DietPlanKind.budget => [
      'Takarékos nap',
      'Alap nap',
      'Okos kosár nap',
      'Egyszerű lendület nap',
      'Pénztárca plusz nap',
      'Praktikus nap',
      'Olcsó okos nap',
      'Kiadós alap nap',
    ],
    _DietPlanKind.mealPrep => [
      'Heti doboz nap',
      'Előkészített nap',
      'Kész doboz nap',
      'Tervezett nap',
      'Rendezett doboz nap',
      'Előre haladó nap',
      'Heti ritmus nap',
      'Dobozolt lendület nap',
    ],
  };
  final pools = switch (kind) {
    _DietPlanKind.highProtein => [
      [
        'Pulykás tojásos wrap',
        'Protein zabkása bogyós gyümölccsel',
        'Banános mogyoróvajas smoothie',
        'Sós cottage cheese tál',
        'Lazacos krémsajtos bagel',
        'Túrós zabpalacsinta',
        'Lazacos spenótos omlett tányér',
        'Pulykás cottage reggeli doboz',
      ],
      [
        'Csirkés rizses fit bowl',
        'Pulykás bolognai tészta',
        'Marhahúsos bulgur serpenyő',
        'Sertésszűz kuszkusszal',
        'Lazacos burgonyás ebéd',
        'Tonhalas kukoricás tésztasaláta',
        'Mediterrán pulykás bulgur',
        'Marhahúsos pita ebéd',
      ],
      [
        'Görög csirkés tányér',
        'Sonkás sajtos omlett',
        'Töltött paprika light módra',
        'Pulykagolyók cukkinispagettivel',
        'Garnélás quinoa bowl',
        'Sült hal zöldségágyon',
        'Lazacos zöldbabos vacsora',
        'Marhás cukkinis rizs',
      ],
      [
        'Protein joghurt pohár',
        'Fehérjés puding',
        'Főtt tojás avokádóval',
        'Mini csirkés wrap',
        'Tonhalas ropogós falatok',
        'Túrós bogyós tál',
        'Avokádós tonhalas tojásfalat',
        'Pulykás sajtos tekercsek',
      ],
    ],
    _DietPlanKind.glutenFree => [
      [
        'Zöldséges omlett',
        'Görög joghurtos granola pohár gluténmentes granolával',
        'Banános mogyoróvajas smoothie',
        'Sós cottage cheese tál',
        'Főtt tojás avokádóval',
        'Protein zabkása bogyós gyümölccsel',
        'Shakshuka reggeli tál',
        'Quinoás joghurtos reggeli',
      ],
      [
        'Lazacos burgonyás ebéd',
        'Csicseriborsó curry rizzsel',
        'Csirkés rizses fit bowl',
        'Lencsés feta saláta',
        'Könnyű csirkés saláta',
        'Tojásos zöldséges rizs',
        'Görög lazacos quinoa tál',
        'Tonhalas babos burgonyasaláta',
      ],
      [
        'Sült hal zöldségágyon',
        'Garnélás quinoa bowl',
        'Görög csirkés tányér',
        'Cottage cheese zöldségtál',
        'Könnyű babos chili',
        'Sonkás sajtos omlett',
        'Spenótos kókuszos csicseriborsó',
        'Garnélás cottage saláta',
      ],
      [
        'Almaszeletek mogyoróvajjal',
        'Hummuszos zöldségdoboz',
        'Protein joghurt pohár',
        'Túrós bogyós tál',
        'Fehérjés puding',
        'Banános kakaós falatok',
        'Lazacos uborkás falatok',
        'Mini burgonyás tzatziki doboz',
      ],
    ],
    _DietPlanKind.vegetarian => [
      [
        'Almás fahéjas overnight oats',
        'Túrós zabpalacsinta',
        'Görög joghurtos granola pohár',
        'Zöldséges omlett',
        'Sós cottage cheese tál',
        'Banános mogyoróvajas smoothie',
        'Kakaós chia zabpohár',
        'Fetás bulgur reggeli tál',
      ],
      [
        'Lencsés feta saláta',
        'Tofus zöldséges noodle box',
        'Csicseriborsó curry rizzsel',
        'Tojásos zöldséges rizs',
        'Könnyű babos chili',
        'Lencsés feta saláta',
        'Lencsés zöldséges rizses egytál',
        'Tofus csicseriborsó curry',
      ],
      [
        'Tojásos zöldséges rizs',
        'Cottage cheese zöldségtál',
        'Könnyű babos chili',
        'Lencsés feta saláta',
        'Zöldséges omlett',
        'Túrós zabpalacsinta',
        'Meleg lencsés feta tányér',
        'Tofus quinoás vacsoratál',
      ],
      [
        'Túrós bogyós tál',
        'Banános kakaós falatok',
        'Almaszeletek mogyoróvajjal',
        'Hummuszos zöldségdoboz',
        'Rizsszelet cottage cheese-zel',
        'Fehérjés puding',
        'Quinoás bogyós snack pohár',
        'Fetás paradicsomos abonett',
      ],
    ],
    _DietPlanKind.quick => [
      [
        'Banános mogyoróvajas smoothie',
        'Görög joghurtos granola pohár',
        'Pulykás tojásos wrap',
        'Sós cottage cheese tál',
        'Tojásos avokádós pirítós',
        'Protein zabkása bogyós gyümölccsel',
        'Tonhalas reggeli pirítós',
        'Hummuszos tojásos pita',
      ],
      [
        'Tonhalas kukoricás tésztasaláta',
        'Csirkés pita tál',
        'Könnyű csirkés saláta',
        'Lencsés feta saláta',
        'Tofus zöldséges noodle box',
        'Csirkés rizses fit bowl',
        'Garnélás rizstészta wok',
        'Csirkés kuszkuszos doboz',
      ],
      [
        'Zöldséges omlett',
        'Cottage cheese zöldségtál',
        'Görög csirkés tányér',
        'Sonkás sajtos omlett',
        'Sült hal zöldségágyon',
        'Tojásos zöldséges rizs',
        'Csirkés rizstészta leveses tál',
        'Sonkás tojásos abonett tál',
      ],
      [
        'Tonhalas ropogós falatok',
        'Rizsszelet cottage cheese-zel',
        'Protein joghurt pohár',
        'Mini csirkés wrap',
        'Fehérjés puding',
        'Almaszeletek mogyoróvajjal',
        'Kakaós skyr ropogóssal',
        'Hummuszos rizsszelet torony',
      ],
    ],
    _DietPlanKind.budget => [
      [
        'Almás fahéjas overnight oats',
        'Zöldséges omlett',
        'Túrós zabpalacsinta',
        'Görög joghurtos granola pohár',
        'Pulykás tojásos wrap',
        'Sós cottage cheese tál',
        'Almás túrós sült zab',
        'Tojásos rizses reggeli serpenyő',
      ],
      [
        'Csicseriborsó curry rizzsel',
        'Pulykás bolognai tészta',
        'Lencsés feta saláta',
        'Tofus zöldséges noodle box',
        'Tonhalas kukoricás tésztasaláta',
        'Csirkés rizses fit bowl',
        'Pulykával töltött cukkini',
        'Lencsés zöldséges rizses egytál',
      ],
      [
        'Könnyű babos chili',
        'Tojásos zöldséges rizs',
        'Töltött paprika light módra',
        'Cottage cheese zöldségtál',
        'Pulykagolyók cukkinispagettivel',
        'Sonkás sajtos omlett',
        'Chilis pulykával töltött paprika',
        'Meleg lencsés feta tányér',
      ],
      [
        'Banános kakaós falatok',
        'Almaszeletek mogyoróvajjal',
        'Rizsszelet cottage cheese-zel',
        'Hummuszos zöldségdoboz',
        'Főtt tojás avokádóval',
        'Protein joghurt pohár',
        'Meleg banános zabfalatok',
        'Csicseriborsós ropogós doboz',
      ],
    ],
    _DietPlanKind.mealPrep => [
      [
        'Overnight oats előre bekészítve',
        'Túrós zabpalacsinta előre sütve',
        'Protein zabkása bogyós gyümölccsel',
        'Pulykás tojásos wrap',
        'Almás fahéjas overnight oats',
        'Sós cottage cheese tál',
        'Almás túrós sült zab',
        'Kakaós chia zabpohár',
      ],
      [
        'Csirkés rizses fit bowl',
        'Marhahúsos bulgur serpenyő',
        'Pulykás bolognai tészta',
        'Csicseriborsó curry rizzsel',
        'Lazacos burgonyás ebéd',
        'Sertésszűz kuszkusszal',
        'Csirkés kuszkuszos doboz',
        'Mediterrán pulykás bulgur',
      ],
      [
        'Könnyű babos chili',
        'Töltött paprika light módra',
        'Görög csirkés tányér',
        'Tojásos zöldséges rizs',
        'Sült hal zöldségágyon',
        'Pulykagolyók cukkinispagettivel',
        'Sertésszűz kuszkusz salátával',
        'Chilis pulykával töltött paprika',
      ],
      [
        'Protein joghurt pohár',
        'Hummuszos zöldségdoboz',
        'Fehérjés puding',
        'Mini csirkés wrap',
        'Túrós bogyós tál',
        'Rizsszelet cottage cheese-zel',
        'Fetás paradicsomos abonett',
        'Mini burgonyás tzatziki doboz',
      ],
    ],
  };

  return List<DietDayPlan>.generate(count, (index) {
    final mealCalories = _mealCaloriesFor(calories, index);
    final recipeIndex = (startIndex + index) % names.length;
    return DietDayPlan(
      name: names[recipeIndex],
      totalCalories: mealCalories.reduce((a, b) => a + b),
      meals: [
        DietMeal(
          label: 'Reggeli',
          name: pools[0][recipeIndex],
          calories: mealCalories[0],
        ),
        DietMeal(
          label: 'Ebéd',
          name: pools[1][recipeIndex],
          calories: mealCalories[1],
        ),
        DietMeal(
          label: 'Vacsora',
          name: pools[2][recipeIndex],
          calories: mealCalories[2],
        ),
        DietMeal(
          label: 'Nasi',
          name: pools[3][recipeIndex],
          calories: mealCalories[3],
        ),
      ],
    );
  });
}

List<int> _mealCaloriesFor(int calories, int variant) {
  final pattern = variant % 4;
  final breakfastRatio = switch (pattern) {
    0 => 0.27,
    1 => 0.25,
    2 => 0.24,
    _ => 0.28,
  };
  final lunchRatio = switch (pattern) {
    0 => 0.35,
    1 => 0.34,
    2 => 0.36,
    _ => 0.33,
  };
  final dinnerRatio = switch (pattern) {
    0 => 0.28,
    1 => 0.30,
    2 => 0.29,
    _ => 0.27,
  };
  final breakfast = (calories * breakfastRatio).round();
  final lunch = (calories * lunchRatio).round();
  final dinner = (calories * dinnerRatio).round();
  final snack = calories - breakfast - lunch - dinner;
  return [breakfast, lunch, dinner, snack];
}

DietDayPlan _retargetDietPlan(DietDayPlan plan, int targetCalories) {
  final currentTotal = plan.meals.fold<int>(
    0,
    (total, meal) => total + meal.calories,
  );
  if (currentTotal == targetCalories) {
    return plan;
  }
  final scaledMeals = <DietMeal>[];
  var usedCalories = 0;
  for (var index = 0; index < plan.meals.length; index++) {
    final meal = plan.meals[index];
    final calories = index == plan.meals.length - 1
        ? targetCalories - usedCalories
        : (meal.calories * targetCalories / currentTotal).round();
    usedCalories += calories;
    scaledMeals.add(
      DietMeal(label: meal.label, name: meal.name, calories: calories),
    );
  }
  return DietDayPlan(
    name: plan.name,
    totalCalories: targetCalories,
    meals: scaledMeals,
  );
}

class DietPlanTypeScreen extends StatelessWidget {
  const DietPlanTypeScreen({required this.calories, super.key});

  final int calories;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final types = [
      _DietTypeOption(
        icon: CupertinoIcons.bolt_fill,
        title: tx(context, 'Magas fehérje'),
        subtitle: tx(context, 'Edzéshez és jobb teltségérzethez'),
        accent: const Color(0xFFD86F35),
        calories: calories,
        macros: _MacroProfile.highProtein,
        plans: _dietPlansFor(calories, _DietPlanKind.highProtein),
      ),
      _DietTypeOption(
        icon: CupertinoIcons.leaf_arrow_circlepath,
        title: tx(context, 'Gluténmentes'),
        subtitle: tx(context, 'Glutént tartalmazó alapanyagok nélkül'),
        accent: const Color(0xFF8E9E44),
        calories: calories,
        macros: _MacroProfile.balanced,
        plans: _dietPlansFor(calories, _DietPlanKind.glutenFree),
      ),
      _DietTypeOption(
        icon: CupertinoIcons.leaf_arrow_circlepath,
        title: tx(context, 'Vegetáriánus'),
        subtitle: tx(context, 'Húsmentes napi étrend'),
        accent: const Color(0xFF4F9B62),
        calories: calories,
        macros: _MacroProfile.plantForward,
        plans: _dietPlansFor(calories, _DietPlanKind.vegetarian),
      ),
      _DietTypeOption(
        icon: CupertinoIcons.clock,
        title: tx(context, 'Gyors'),
        subtitle: tx(context, 'Rövid elkészítési idejű ételekkel'),
        accent: const Color(0xFFC89132),
        calories: calories,
        macros: _MacroProfile.quick,
        plans: _dietPlansFor(calories, _DietPlanKind.quick),
      ),
      _DietTypeOption(
        icon: CupertinoIcons.money_euro_circle,
        title: tx(context, 'Pénztárcabarát'),
        subtitle: tx(context, 'Egyszerűbb, olcsóbb alapanyagokkal'),
        accent: const Color(0xFFB87A3A),
        calories: calories,
        macros: _MacroProfile.budget,
        plans: _dietPlansFor(calories, _DietPlanKind.budget),
      ),
      _DietTypeOption(
        icon: CupertinoIcons.archivebox,
        title: tx(context, 'Meal prep alapú'),
        subtitle: tx(context, 'Előre dobozolható napi menü'),
        accent: const Color(0xFF9B7452),
        calories: calories,
        macros: _MacroProfile.mealPrep,
        plans: _dietPlansFor(calories, _DietPlanKind.mealPrep),
      ),
    ];

    return CupertinoPageScaffold(
      backgroundColor: p.bg,
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        backgroundColor: state.headerSurface,
        border: null,
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
              padding: const EdgeInsets.fromLTRB(13, 13, 13, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx(context, 'Válassz étrend típust'),
                    style: TextStyle(
                      color: p.text,
                      fontSize: 19,
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
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: p.resultBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: p.resultBorder),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          CupertinoIcons.info_circle,
                          color: p.accent,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tx(
                              context,
                              'Az étrendek általános iránymutatásként szolgálnak, és nem helyettesítik a dietetikus vagy orvos által összeállított személyre szabott étrendet. Egészségügyi állapot, allergia, várandósság vagy speciális cél esetén kérj szakembertől segítséget, és saját felelősséggel használd őket.',
                            ),
                            style: TextStyle(
                              color: p.muted,
                              fontSize: 12.5,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
    required this.calories,
    required this.macros,
    required this.plans,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final int calories;
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

class _MacroTotals {
  const _MacroTotals({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final double protein;
  final double carbs;
  final double fat;

  double get proteinCalories => protein * 4;
  double get carbCalories => carbs * 4;
  double get fatCalories => fat * 9;
  double get totalCalories => proteinCalories + carbCalories + fatCalories;

  _MacroTotals scale(double factor) => _MacroTotals(
    protein: protein * factor,
    carbs: carbs * factor,
    fat: fat * factor,
  );

  _MacroTotals operator +(_MacroTotals other) => _MacroTotals(
    protein: protein + other.protein,
    carbs: carbs + other.carbs,
    fat: fat + other.fat,
  );
}

const _zeroMacroTotals = _MacroTotals(protein: 0, carbs: 0, fat: 0);

_MacroTotals _macroTotalsForPlan(DietDayPlan plan, _MacroProfile fallback) {
  var totals = _zeroMacroTotals;
  for (final meal in plan.meals) {
    final recipe = _recipeForMeal(meal);
    if (recipe == null) {
      totals += _macroTotalsForPlanCalories(meal.calories, fallback);
      continue;
    }
    final recipeTotals = _macroTotalsForRecipe(recipe);
    if (recipeTotals.totalCalories <= 0) {
      totals += _macroTotalsForPlanCalories(meal.calories, fallback);
      continue;
    }
    final scale =
        meal.calories / recipe.caloriesPerServing / recipe.baseServings;
    totals += recipeTotals.scale(scale);
  }
  return totals.totalCalories > 0
      ? totals
      : _macroTotalsForPlanCalories(_dietPlanTotalCalories(plan), fallback);
}

_MacroTotals _macroTotalsForPlanCalories(int calories, _MacroProfile profile) {
  return _MacroTotals(
    protein: calories * profile.protein / 4,
    carbs: calories * profile.carbs / 4,
    fat: calories * profile.fat / 9,
  );
}

_MacroTotals _macroTotalsForRecipe(Recipe recipe) {
  var totals = _zeroMacroTotals;
  for (final ingredient in recipe.ingredients) {
    final macros = _macroTotalsForIngredient(ingredient);
    totals += macros;
  }
  return totals;
}

_MacroTotals _macroTotalsForIngredient(RecipeIngredient ingredient) {
  final name = ingredient.name.toLowerCase();
  final amount = ingredient.amount;
  final unit = ingredient.unit;
  if (unit == 'csipet') return _zeroMacroTotals;
  if (unit == 'db') {
    if (name.contains('tojás')) {
      return const _MacroTotals(protein: 6.3, carbs: 0.4, fat: 5).scale(amount);
    }
    if (name.contains('rizsszelet')) {
      return const _MacroTotals(
        protein: 0.7,
        carbs: 7.2,
        fat: 0.2,
      ).scale(amount);
    }
    return _zeroMacroTotals;
  }

  final divisor = unit == 'ml' ? 100.0 : 100.0;
  final per100 = _macroPer100ForIngredient(name);
  return per100.scale(amount / divisor);
}

_MacroTotals _macroPer100ForIngredient(String name) {
  if (name.contains('csirkemell') || name.contains('sült csirkemell')) {
    return const _MacroTotals(protein: 23, carbs: 0, fat: 2);
  }
  if (name.contains('pulyka') || name.contains('pulykasonka')) {
    return const _MacroTotals(protein: 21, carbs: 1, fat: 5);
  }
  if (name.contains('marhahús')) {
    return const _MacroTotals(protein: 21, carbs: 0, fat: 8);
  }
  if (name.contains('sertésszűz')) {
    return const _MacroTotals(protein: 22, carbs: 0, fat: 4);
  }
  if (name.contains('lazac')) {
    return const _MacroTotals(protein: 20, carbs: 0, fat: 13);
  }
  if (name.contains('tonhal')) {
    return const _MacroTotals(protein: 24, carbs: 0, fat: 1);
  }
  if (name.contains('garnéla')) {
    return const _MacroTotals(protein: 20, carbs: 1, fat: 1);
  }
  if (name.contains('halfilé')) {
    return const _MacroTotals(protein: 19, carbs: 0, fat: 2);
  }
  if (name.contains('tofu')) {
    return const _MacroTotals(protein: 13, carbs: 2, fat: 8);
  }
  if (name.contains('szójagranulátum')) {
    return const _MacroTotals(protein: 50, carbs: 30, fat: 1);
  }
  if (name.contains('fehérjepor')) {
    return const _MacroTotals(protein: 75, carbs: 8, fat: 5);
  }
  if (name.contains('skyr') || name.contains('görög joghurt')) {
    return const _MacroTotals(protein: 10, carbs: 4, fat: 2);
  }
  if (name == 'joghurt' || name.contains('joghurtos')) {
    return const _MacroTotals(protein: 5, carbs: 5, fat: 3);
  }
  if (name.contains('cottage')) {
    return const _MacroTotals(protein: 12, carbs: 3, fat: 4);
  }
  if (name.contains('túró')) {
    return const _MacroTotals(protein: 14, carbs: 4, fat: 5);
  }
  if (name.contains('feta')) {
    return const _MacroTotals(protein: 14, carbs: 4, fat: 21);
  }
  if (name.contains('sajt') || name.contains('krémsajt')) {
    return const _MacroTotals(protein: 18, carbs: 3, fat: 18);
  }
  if (name.contains('tej vagy növényi ital') || name == 'tej') {
    return const _MacroTotals(protein: 3.4, carbs: 5, fat: 1.5);
  }
  if (name.contains('zab')) {
    return const _MacroTotals(protein: 13, carbs: 60, fat: 7);
  }
  if (name.contains('granola')) {
    return const _MacroTotals(protein: 10, carbs: 62, fat: 15);
  }
  if (name == 'rizs') {
    return const _MacroTotals(protein: 7, carbs: 78, fat: 1);
  }
  if (name.contains('főtt rizs')) {
    return const _MacroTotals(protein: 2.7, carbs: 28, fat: 0.3);
  }
  if (name.contains('rizstészta')) {
    return const _MacroTotals(protein: 6, carbs: 80, fat: 1);
  }
  if (name.contains('tészta')) {
    return const _MacroTotals(protein: 13, carbs: 70, fat: 2);
  }
  if (name.contains('bulgur')) {
    return const _MacroTotals(protein: 12, carbs: 76, fat: 1.5);
  }
  if (name.contains('kuszkusz')) {
    return const _MacroTotals(protein: 12, carbs: 72, fat: 1.5);
  }
  if (name.contains('quinoa')) {
    return const _MacroTotals(protein: 14, carbs: 64, fat: 6);
  }
  if (name.contains('burgonya')) {
    return const _MacroTotals(protein: 2, carbs: 17, fat: 0.1);
  }
  if (name.contains('kenyér') ||
      name.contains('pita') ||
      name.contains('tortilla') ||
      name.contains('bagel') ||
      name.contains('abonett') ||
      name.contains('keksz') ||
      name.contains('zsemlemorzsa')) {
    return const _MacroTotals(protein: 10, carbs: 50, fat: 5);
  }
  if (name.contains('csicseriborsó') || name.contains('hummusz')) {
    return const _MacroTotals(protein: 8, carbs: 20, fat: 6);
  }
  if (name.contains('lencse') || name.contains('vörösbab')) {
    return const _MacroTotals(protein: 8, carbs: 20, fat: 1);
  }
  if (name.contains('kukorica') || name.contains('zöldborsó')) {
    return const _MacroTotals(protein: 4, carbs: 18, fat: 1);
  }
  if (name.contains('kókusztej')) {
    return const _MacroTotals(protein: 2, carbs: 3, fat: 17);
  }
  if (name.contains('avokádó')) {
    return const _MacroTotals(protein: 2, carbs: 9, fat: 15);
  }
  if (name.contains('mogyoróvaj')) {
    return const _MacroTotals(protein: 25, carbs: 20, fat: 50);
  }
  if (name.contains('mandula') ||
      name.contains('dió') ||
      name.contains('tökmag') ||
      name.contains('chia') ||
      name.contains('szezámmag')) {
    return const _MacroTotals(protein: 18, carbs: 15, fat: 45);
  }
  if (name.contains('olívaolaj')) {
    return const _MacroTotals(protein: 0, carbs: 0, fat: 100);
  }
  if (name.contains('méz') || name.contains('juharszirup')) {
    return const _MacroTotals(protein: 0, carbs: 82, fat: 0);
  }
  if (name.contains('banán')) {
    return const _MacroTotals(protein: 1, carbs: 23, fat: 0.3);
  }
  if (name.contains('alma') ||
      name.contains('bogyós') ||
      name.contains('eper')) {
    return const _MacroTotals(protein: 0.6, carbs: 12, fat: 0.3);
  }
  if (name.contains('paradicsomszósz') || name.contains('paradicsompüré')) {
    return const _MacroTotals(protein: 2, carbs: 8, fat: 0.5);
  }
  if (name.contains('zöldség') ||
      name.contains('saláta') ||
      name.contains('uborka') ||
      name.contains('paradicsom') ||
      name.contains('paprika') ||
      name.contains('répa') ||
      name.contains('cukkini') ||
      name.contains('spenót') ||
      name.contains('brokkoli') ||
      name.contains('zöldbab')) {
    return const _MacroTotals(protein: 2, carbs: 5, fat: 0.3);
  }
  if (name.contains('kakaópor')) {
    return const _MacroTotals(protein: 20, carbs: 14, fat: 14);
  }
  return _zeroMacroTotals;
}

class _DietTypeTile extends StatelessWidget {
  const _DietTypeTile({required this.option});

  final _DietTypeOption option;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => Navigator.of(context).push(
        CupertinoPageRoute<void>(
          builder: (_) => _DietPlanListScreen(
            title: option.title,
            calories: option.calories,
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
              height: 64,
              decoration: BoxDecoration(
                color: option.accent.withValues(alpha: 0.78),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(14),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  option.accent.withValues(alpha: 0.12),
                  p.resultBg,
                ),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: option.accent.withValues(alpha: 0.38),
                ),
              ),
              child: Icon(option.icon, color: option.accent, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.title, style: MealText.bodyStrong(p.text)),
                  const SizedBox(height: 4),
                  Text(
                    option.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: MealText.caption(p.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(CupertinoIcons.chevron_forward, color: p.muted, size: 16),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class _DietPlanListScreen extends StatelessWidget {
  const _DietPlanListScreen({
    required this.title,
    required this.calories,
    required this.plans,
    required this.macros,
  });

  final String title;
  final int calories;
  final List<DietDayPlan> plans;
  final _MacroProfile macros;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return CupertinoPageScaffold(
      backgroundColor: p.bg,
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        backgroundColor: state.headerSurface,
        border: null,
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
            SectionLabel('$calories kcal ${tx(context, 'étrendek')}'),
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
    final state = AppScope.of(context);
    final p = state.palette;
    final totalCalories = _dietPlanTotalCalories(plan);
    final macroTotals = _macroTotalsForPlan(plan, macros);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => Navigator.of(context).push(
        CupertinoPageRoute<void>(
          builder: (_) => DietPlanDetailScreen(plan: plan),
        ),
      ),
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: p.resultBg,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: p.resultBorder.withValues(alpha: 0.75),
                    ),
                  ),
                  child: Icon(
                    CupertinoIcons.calendar,
                    color: p.accent,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx(context, plan.name),
                        style: TextStyle(
                          color: p.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${plan.meals.length} ${tx(context, 'étkezés')}',
                        style: TextStyle(
                          color: p.muted,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: p.resultBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: p.resultBorder.withValues(alpha: 0.75),
                    ),
                  ),
                  child: Text(
                    '$totalCalories kcal',
                    style: TextStyle(
                      color: p.accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(CupertinoIcons.chevron_forward, color: p.muted, size: 16),
              ],
            ),
            const SizedBox(height: 12),
            _MacroBreakdownBar(totals: macroTotals),
          ],
        ),
      ),
    );
  }
}

class _MacroBreakdownBar extends StatelessWidget {
  const _MacroBreakdownBar({required this.totals});

  final _MacroTotals totals;

  int get proteinGrams => totals.protein.round();

  int get carbGrams => totals.carbs.round();

  int get fatGrams => totals.fat.round();

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
            height: 6,
            child: Row(
              children: [
                _MacroSegment(
                  flex: totals.proteinCalories.round().clamp(1, 10000),
                  color: proteinColor,
                ),
                _MacroSegment(
                  flex: totals.carbCalories.round().clamp(1, 10000),
                  color: carbColor,
                ),
                _MacroSegment(
                  flex: totals.fatCalories.round().clamp(1, 10000),
                  color: fatColor,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
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
              tx(context, 'Makrók megoszlása'),
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
    final state = AppScope.of(context);
    final p = state.palette;
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
    final state = AppScope.of(context);
    final p = state.palette;
    final totalCalories = _dietPlanTotalCalories(plan);
    return CupertinoPageScaffold(
      backgroundColor: p.bg,
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        backgroundColor: state.headerSurface,
        border: null,
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
              padding: const EdgeInsets.fromLTRB(13, 13, 13, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx(context, plan.name),
                    style: TextStyle(
                      color: p.text,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _RecipeSummaryRow(
                    label: tx(context, 'Összes kalória'),
                    value: '$totalCalories kcal',
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      color: p.accent,
                      borderRadius: BorderRadius.circular(12),
                      onPressed: AppScope.of(context).isPro
                          ? withAppActionHaptic(
                              () => showCupertinoModalPopup<void>(
                                context: context,
                                barrierDismissible: true,
                                barrierColor: const Color(0x99000000),
                                builder: (_) =>
                                    DietPlanShoppingListSheet(plan: plan),
                              ),
                            )
                          : withAppActionHaptic(
                              () => showProPaywallSheet(context),
                            ),
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
    final state = AppScope.of(context);
    final p = state.palette;
    final recipe = _recipeForMeal(meal);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: recipe == null
          ? null
          : () => Navigator.of(context).push(
              CupertinoPageRoute<void>(
                builder: (_) =>
                    DietRecipeDetailScreen(recipe: recipe, meal: meal),
              ),
            ),
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: p.bg.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: p.border.withValues(alpha: 0.62)),
              ),
              child: Text(
                _dietMealEmoji(meal.label),
                style: const TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx(context, meal.label),
                    style: TextStyle(
                      color: p.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tx(context, meal.name),
                    style: TextStyle(
                      color: p.text,
                      height: 1.25,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (recipe != null) ...[
                  const SizedBox(height: 4),
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
    return AppSheetFrame(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      avoidKeyboard: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tx(context, 'Bevásárlólista mentése'),
                  style: MealText.sheetTitle(p.text),
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
            style: MealText.captionStrong(p.muted),
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            controller: nameController,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            style: MealText.bodyStrong(p.text),
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
              color: state.primaryActionSurface,
              borderRadius: BorderRadius.circular(14),
              padding: const EdgeInsets.symmetric(vertical: 13),
              onPressed: items.isEmpty
                  ? null
                  : withAppActionHaptic(() {
                      state.addShoppingList(
                        name: nameController.text,
                        items: items,
                      );
                      Navigator.pop(context);
                    }),
              child: Text(
                tx(context, 'Mentés új listaként'),
                style: MealText.button(p.buttonText),
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
            style: MealText.captionStrong(p.muted),
          ),
          const SizedBox(height: 8),
          for (final item in items.take(10))
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(item.name, style: MealText.bodyStrong(p.text)),
            ),
          if (items.length > 10)
            Text(
              '+${items.length - 10} ${tx(context, 'tétel')}',
              style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
            ),
        ],
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

int _dietPlanTotalCalories(DietDayPlan plan) =>
    plan.meals.fold<int>(0, (total, meal) => total + meal.calories);

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
              '${item.name} - ${_formatIngredientAmount(item.amount, item.unit)} ${item.unit}',
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
      backgroundColor: state.headerSurface,
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
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                16,
                10,
                16,
                AppLayout.screenBottomPadding,
              ),
              children: children,
            ),
          ),
        ],
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
        const SizedBox(height: 12),
        const _RecipeGuidanceNote(),
        const SizedBox(height: 14),
        if (favorites.isNotEmpty) ...[
          SectionLabel(tx(context, 'Kedvencek')),
          for (final recipe in favorites) _RecipeTile(recipe: recipe),
          const SizedBox(height: 8),
        ],
        SectionLabel(tx(context, 'Receptek')),
        if (regularRecipes.isEmpty && favorites.isEmpty)
          _EmptyFoodMessage(
            tx(context, 'Nincs találat.'),
            icon: CupertinoIcons.search,
          ),
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

class _RecipeGuidanceNote extends StatelessWidget {
  const _RecipeGuidanceNote();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: p.resultBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.resultBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.info_circle, color: p.accent, size: 17),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tx(
                context,
                'Az étrendek általános iránymutatásként szolgálnak, és nem helyettesítik a dietetikus vagy orvos által összeállított személyre szabott étrendet. Egészségügyi állapot, allergia, várandósság vagy speciális cél esetén kérj szakembertől segítséget, és saját felelősséggel használd őket.',
              ),
              style: TextStyle(
                color: p.muted,
                fontSize: 12,
                height: 1.32,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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
            const _WarmBackButton(),
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
    final state = AppScope.of(context);
    final p = state.palette;
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

class _RecipeDietChip extends StatelessWidget {
  const _RecipeDietChip({required this.isVegan});

  final bool isVegan;

  @override
  Widget build(BuildContext context) {
    return _RecipeInfoChip(
      label: isVegan ? tx(context, 'Vegán') : tx(context, 'Normál receptek'),
      icon: isVegan
          ? CupertinoIcons.check_mark_circled
          : CupertinoIcons.circle_grid_hex,
    );
  }
}

class _RecipeInfoChip extends StatelessWidget {
  const _RecipeInfoChip({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: state.isDark
            ? Color.alphaBlend(p.accent.withValues(alpha: 0.06), p.card)
            : p.resultBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: p.resultBorder.withValues(alpha: 0.58)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: p.accent, size: 12),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: MealText.section(
              p.accent,
            ).copyWith(letterSpacing: 0, fontSize: 10.5),
          ),
        ],
      ),
    );
  }
}

class _RecipeMacroStrip extends StatelessWidget {
  const _RecipeMacroStrip({required this.recipe, required this.servings});

  final Recipe recipe;
  final int servings;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    final protein = recipe.proteinEstimate * servings;
    final carbs = recipe.carbsEstimate * servings;
    final fat = recipe.fatEstimate * servings;
    return Container(
      padding: const EdgeInsets.fromLTRB(11, 9, 11, 9),
      decoration: BoxDecoration(
        color: p.bg.withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.border.withValues(alpha: 0.62)),
      ),
      child: Row(
        children: [
          _MacroMini(
            label: 'P',
            value: '${protein}g',
            color: const Color(0xFFD8722C),
          ),
          const SizedBox(width: 10),
          _MacroMini(
            label: 'C',
            value: '${carbs}g',
            color: const Color(0xFFD4AA32),
          ),
          const SizedBox(width: 10),
          _MacroMini(
            label: 'F',
            value: '${fat}g',
            color: const Color(0xFFA98A68),
          ),
        ],
      ),
    );
  }
}

class _MacroMini extends StatelessWidget {
  const _MacroMini({
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
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
              padding: const EdgeInsets.fromLTRB(12, 11, 7, 11),
              onPressed: () => Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (_) =>
                      RecipeDetailScreen(recipe: recipe, initialServings: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: recipe.imageAsset == null ? 42 : 52,
                    height: recipe.imageAsset == null ? 42 : 52,
                    decoration: BoxDecoration(
                      color: p.bg.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: p.border.withValues(alpha: 0.70),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.center,
                    child: recipe.imageAsset == null
                        ? Text(
                            recipe.emoji,
                            style: const TextStyle(fontSize: 22),
                          )
                        : Image.asset(
                            recipe.imageAsset!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(width: 10),
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
                            fontSize: 14.5,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${recipe.caloriesPerServing} kcal/${tx(context, 'adag')} · ${recipe.prepTimeMinutes} ${tx(context, 'perc')}',
                          style: TextStyle(
                            color: p.muted,
                            fontSize: 12.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _RecipeDietChip(isVegan: recipe.isVegan),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          CupertinoButton(
            minimumSize: const Size(34, 34),
            padding: EdgeInsets.zero,
            onPressed: () => state.toggleFavoriteRecipe(recipe.id),
            child: Icon(
              isFavorite ? CupertinoIcons.star_fill : CupertinoIcons.star,
              color: isFavorite ? p.accent : p.muted,
              size: 19,
            ),
          ),
          const SizedBox(width: 2),
          Icon(CupertinoIcons.chevron_forward, color: p.muted, size: 16),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({
    required this.recipe,
    this.initialServings,
    super.key,
  });

  final Recipe recipe;
  final int? initialServings;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late int servings;
  late final TextEditingController servingsController;

  @override
  void initState() {
    super.initState();
    servings = (widget.initialServings ?? 1).clamp(1, 20);
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
    final softSurface = p.bg.withValues(alpha: state.isDark ? 0.58 : 0.72);
    return _FoodSubpageScaffold(
      children: [
        AppCard(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: SpringPressable(
                      pressedScale: 0.96,
                      child: CupertinoButton(
                        minimumSize: const Size(38, 38),
                        padding: EdgeInsets.zero,
                        color: softSurface,
                        borderRadius: BorderRadius.circular(12),
                        onPressed: () => Navigator.maybePop(context),
                        child: Icon(
                          CupertinoIcons.chevron_left,
                          color: p.accent,
                          size: 19,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx(context, recipe.name),
                          style: MealText.sheetTitle(
                            p.text,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${recipe.prepTimeMinutes} ${tx(context, 'perc')} · ${recipe.caloriesPerServing} kcal/${tx(context, 'adag')}',
                          style: MealText.caption(p.muted),
                        ),
                        const SizedBox(height: 7),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _RecipeDietChip(isVegan: recipe.isVegan),
                            _RecipeInfoChip(
                              label: tx(context, recipe.difficultyLabel),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    minimumSize: const Size(32, 32),
                    padding: EdgeInsets.zero,
                    color: softSurface,
                    borderRadius: BorderRadius.circular(11),
                    onPressed: () => state.toggleFavoriteRecipe(recipe.id),
                    child: Icon(
                      isFavorite
                          ? CupertinoIcons.star_fill
                          : CupertinoIcons.star,
                      color: isFavorite ? p.accent : p.muted,
                      size: 18,
                    ),
                  ),
                ],
              ),
              if (recipe.imageAsset != null) ...[
                const SizedBox(height: 11),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AspectRatio(
                    aspectRatio: 2.15,
                    child: Image.asset(
                      recipe.imageAsset!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 11),
              _RecipeServingsStepper(
                value: servings,
                controller: servingsController,
                onChanged: _setServings,
              ),
              const SizedBox(height: 8),
              _RecipeSummaryRow(
                label: tx(context, 'Összes kalória'),
                value: '$totalCalories kcal',
              ),
              const SizedBox(height: 8),
              _RecipeMacroStrip(recipe: recipe, servings: servings),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  color: p.accent,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: state.isPro
                      ? withAppActionHaptic(
                          () => showCupertinoModalPopup<void>(
                            context: context,
                            barrierDismissible: true,
                            barrierColor: const Color(0x99000000),
                            builder: (_) => RecipeShoppingListSheet(
                              recipe: recipe,
                              servings: servings,
                            ),
                          ),
                        )
                      : withAppActionHaptic(() => showProPaywallSheet(context)),
                  child: Text(
                    tx(context, 'Bevásárláshoz adás'),
                    style: MealText.button(p.buttonText),
                  ),
                ),
              ),
            ],
          ),
        ),
        SectionLabel(tx(context, 'Részletek')),
        AppCard(
          child: Column(
            children: [
              _RecipeSummaryRow(
                label: tx(context, 'Nehézség'),
                value: tx(context, recipe.difficultyLabel),
              ),
              const SizedBox(height: 8),
              _RecipeSummaryRow(
                label: tx(context, 'Étrend típus'),
                value: recipe.isVegan
                    ? tx(context, 'Vegán')
                    : tx(context, 'Normál receptek'),
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

class DietRecipeDetailScreen extends StatelessWidget {
  const DietRecipeDetailScreen({
    required this.recipe,
    required this.meal,
    super.key,
  });

  final Recipe recipe;
  final DietMeal meal;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final softSurface = p.bg.withValues(alpha: state.isDark ? 0.58 : 0.72);
    final scale =
        meal.calories / recipe.caloriesPerServing / recipe.baseServings;
    final servingEquivalent = meal.calories / recipe.caloriesPerServing;
    return _FoodSubpageScaffold(
      children: [
        AppCard(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: SpringPressable(
                      pressedScale: 0.96,
                      child: CupertinoButton(
                        minimumSize: const Size(38, 38),
                        padding: EdgeInsets.zero,
                        color: softSurface,
                        borderRadius: BorderRadius.circular(12),
                        onPressed: () => Navigator.maybePop(context),
                        child: Icon(
                          CupertinoIcons.chevron_left,
                          color: p.accent,
                          size: 19,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx(context, recipe.name),
                          style: MealText.sheetTitle(
                            p.text,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${tx(context, meal.label)} · ${recipe.prepTimeMinutes} ${tx(context, 'perc')}',
                          style: MealText.caption(p.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              _RecipeSummaryRow(
                label: tx(context, 'Összes kalória'),
                value: '${meal.calories} kcal',
              ),
              const SizedBox(height: 7),
              Text(
                '${_formatRecipeAmount(servingEquivalent)} ${tx(context, 'adag')}',
                style: MealText.caption(p.muted),
              ),
            ],
          ),
        ),
        SectionLabel(tx(context, 'Hozzávalók')),
        AppCard(
          child: Column(
            children: [
              for (final ingredient in recipe.ingredients)
                _RecipeIngredientRow(ingredient: ingredient, scale: scale),
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
    final items = _recipeShoppingItems(context, widget.recipe, widget.servings);
    return AppSheetFrame(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      avoidKeyboard: true,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
              onPressed: withAppActionHaptic(() {
                state.addShoppingList(name: nameController.text, items: items);
                Navigator.pop(context);
              }),
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
                  state.addItemsToShoppingList(listId: list.id, items: items);
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
                style: TextStyle(color: p.text, fontWeight: FontWeight.w600),
              ),
            ),
        ],
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
      onPressed: withAppActionHaptic(onPressed),
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
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
      decoration: BoxDecoration(
        color: p.bg.withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: p.border.withValues(alpha: 0.62)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              tx(context, 'Adagok száma'),
              style: MealText.bodyStrong(p.text),
            ),
          ),
          _RecipeStepButton(
            icon: CupertinoIcons.minus,
            onPressed: () => onChanged(value - 1),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 46,
            child: CupertinoTextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              padding: const EdgeInsets.symmetric(vertical: 7),
              style: MealText.button(p.text),
              decoration: BoxDecoration(
                color: p.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: p.border.withValues(alpha: 0.70)),
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
      minimumSize: const Size(30, 30),
      padding: EdgeInsets.zero,
      color: p.card,
      borderRadius: BorderRadius.circular(10),
      onPressed: withAppActionHaptic(onPressed),
      child: Icon(icon, color: p.accent, size: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: p.resultBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.resultBorder.withValues(alpha: 0.72)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: MealText.callout(
                p.muted,
              ).copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Text(value, style: MealText.button(p.accent)),
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
    final note = _ingredientKitchenNote(context, ingredient, amount);
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx(context, ingredient.name),
                  style: MealText.bodyStrong(p.text),
                ),
                if (note != null) ...[
                  const SizedBox(height: 3),
                  Text(note, style: MealText.caption(p.muted)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              '${_formatIngredientAmount(amount, ingredient.unit)} ${tx(context, ingredient.unit)}',
              style: MealText.bodyStrong(p.accent),
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
    final hint = _recipeStepHint(context, text);
    return Padding(
      padding: EdgeInsets.only(bottom: index == 0 ? 11 : 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: p.accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${index + 1}',
              style: MealText.captionStrong(p.buttonText),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx(context, text), style: MealText.body(p.text)),
                if (hint != null) ...[
                  const SizedBox(height: 5),
                  Text(hint, style: MealText.caption(p.muted)),
                ],
              ],
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: p.bg.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: p.border.withValues(alpha: 0.62)),
      ),
      child: Text(tx(context, label), style: MealText.caption(p.muted)),
    );
  }
}

String? _ingredientKitchenNote(
  BuildContext context,
  RecipeIngredient ingredient,
  double amount,
) {
  final languageCode = AppScope.of(context).resolvedLanguageCode(context);
  final name = ingredient.name.toLowerCase();
  final unit = ingredient.unit;
  String approx(String hu, String en, String de, String es) {
    return switch (languageCode) {
      'hu' => hu,
      'de' => de,
      'es' => es,
      _ => en,
    };
  }

  if (unit == 'db') {
    if (name.contains('tojás')) {
      return approx(
        'M-es tojással számolva, kb. 53-63 g/db héjjal együtt.',
        'Calculated with medium eggs, about 53-63 g each with shell.',
        'Mit Eiern Größe M gerechnet, ca. 53-63 g pro Stück mit Schale.',
        'Calculado con huevos medianos, aprox. 53-63 g cada uno con cáscara.',
      );
    }
    return approx(
      'Kb. ${_formatRecipeAmount(amount)} darab.',
      'About ${_formatRecipeAmount(amount)} piece(s).',
      'Ca. ${_formatRecipeAmount(amount)} Stück.',
      'Aprox. ${_formatRecipeAmount(amount)} unidad(es).',
    );
  }
  if (unit == 'csipet') {
    return approx(
      'Ízlés szerint, kb. egy nagyobb csipet.',
      'To taste, about one generous pinch.',
      'Nach Geschmack, etwa eine großzügige Prise.',
      'Al gusto, aprox. una pizca generosa.',
    );
  }
  if (unit == 'ml') {
    if (amount <= 15) {
      final teaspoons = amount / 5;
      return approx(
        'Kb. ${_formatRecipeAmount(teaspoons)} teáskanál.',
        'About ${_formatRecipeAmount(teaspoons)} tsp.',
        'Ca. ${_formatRecipeAmount(teaspoons)} TL.',
        'Aprox. ${_formatRecipeAmount(teaspoons)} cucharadita(s).',
      );
    }
    final tablespoons = amount / 15;
    return approx(
      'Kb. ${_formatRecipeAmount(tablespoons)} evőkanál vagy ${_formatRecipeAmount(amount / 100)} dl.',
      'About ${_formatRecipeAmount(tablespoons)} tbsp or ${_formatRecipeAmount(amount / 100)} dl.',
      'Ca. ${_formatRecipeAmount(tablespoons)} EL oder ${_formatRecipeAmount(amount / 100)} dl.',
      'Aprox. ${_formatRecipeAmount(tablespoons)} cucharada(s) o ${_formatRecipeAmount(amount / 100)} dl.',
    );
  }
  if (unit != 'g') return null;

  if (name.contains('rizstészta')) {
    return approx(
      'Szárazon mérd ki; általában 5-8 perc áztatás vagy főzés elég.',
      'Measure dry; usually 5-8 minutes soaking or cooking is enough.',
      'Trocken abwiegen; meist reichen 5-8 Minuten Einweichen oder Kochen.',
      'Pésalo en seco; normalmente bastan 5-8 minutos de remojo o cocción.',
    );
  }
  if (name == 'rizs' || name.contains('főtt rizs')) {
    return approx(
      'Száraz rizsnél kb. kétszeres vízzel számolj; főtt rizsnél kész súlyt mérsz.',
      'For dry rice use about twice as much water; cooked rice is weighed ready-made.',
      'Bei trockenem Reis etwa doppelt so viel Wasser nehmen; gekochten Reis fertig wiegen.',
      'Para arroz seco usa aprox. el doble de agua; el arroz cocido se pesa ya hecho.',
    );
  }
  if (name.contains('bulgur')) {
    return approx(
      'Szárazon mérd ki, kb. kétszeres forró vízzel puhul meg.',
      'Measure dry; it softens with about twice as much hot water.',
      'Trocken abwiegen; mit etwa doppelt so viel heißem Wasser quellen lassen.',
      'Pésalo en seco; se hidrata con aprox. el doble de agua caliente.',
    );
  }
  if (name.contains('kuszkusz')) {
    return approx(
      'Szárazon mérd ki, kb. azonos mennyiségű forró vízzel párold.',
      'Measure dry and steam with roughly the same amount of hot water.',
      'Trocken abwiegen und mit etwa gleicher Menge heißem Wasser quellen lassen.',
      'Pésalo en seco y usa aprox. la misma cantidad de agua caliente.',
    );
  }
  if (name.contains('quinoa')) {
    return approx(
      'Szárazon mérd ki, mosd át, majd kb. kétszeres vízzel főzd.',
      'Measure dry, rinse, then cook with about twice as much water.',
      'Trocken abwiegen, abspülen und mit etwa doppelt so viel Wasser kochen.',
      'Pésala en seco, enjuágala y cocina con aprox. el doble de agua.',
    );
  }
  if (name == 'tészta' || name.contains('teljes kiőrlésű tészta')) {
    return approx(
      'Szárazon mérd ki; bő, sós vízben főzd a csomagolás ideje szerint.',
      'Measure dry; cook in plenty of salted water according to the package time.',
      'Trocken abwiegen; in reichlich Salzwasser nach Packungszeit kochen.',
      'Pésala en seco; cuece en abundante agua salada según el envase.',
    );
  }
  if (name.contains('burgonya')) {
    return approx(
      'Kb. közepes burgonyákból számolva; főzve 15-20 perc, sütve 25-35 perc.',
      'Based on medium potatoes; boil 15-20 min or roast 25-35 min.',
      'Mit mittelgroßen Kartoffeln gerechnet; 15-20 Min. kochen oder 25-35 Min. backen.',
      'Calculado con patatas medianas; hierve 15-20 min u hornea 25-35 min.',
    );
  }
  if (name.contains('tzatziki')) {
    return approx(
      'Készen is használható. Házi verzióhoz keverj sűrű görög joghurtot reszelt, kinyomkodott uborkával, kevés citromlével, fokhagymával, sóval és borssal.',
      'Ready-made is fine. For a homemade version, mix thick Greek yogurt with grated squeezed cucumber, a little lemon juice, garlic, salt, and pepper.',
      'Fertig gekauft ist in Ordnung. Für hausgemachte Variante dicken griechischen Joghurt mit geriebener, ausgedrückter Gurke, etwas Zitronensaft, Knoblauch, Salz und Pfeffer mischen.',
      'Puede ser comprado. Para hacerlo en casa, mezcla yogur griego espeso con pepino rallado y escurrido, un poco de limón, ajo, sal y pimienta.',
    );
  }
  if (name.contains('joghurtos öntet') || name.contains('joghurtos szósz')) {
    return approx(
      'Házi öntethez keverj natúr vagy görög joghurtot kevés citromlével, mustárral vagy fokhagymával, sóval és borssal; a megadott mennyiséget a kész öntetből mérd ki.',
      'For a homemade dressing, mix plain or Greek yogurt with a little lemon juice, mustard or garlic, salt, and pepper; measure the listed amount from the finished dressing.',
      'Für ein hausgemachtes Dressing Natur- oder griechischen Joghurt mit etwas Zitronensaft, Senf oder Knoblauch, Salz und Pfeffer mischen; die angegebene Menge vom fertigen Dressing abwiegen.',
      'Para un aderezo casero, mezcla yogur natural o griego con un poco de limón, mostaza o ajo, sal y pimienta; pesa la cantidad indicada ya preparada.',
    );
  }

  if (name.contains('banán')) {
    final pieces = amount / 120;
    return approx(
      'Kb. ${_formatRecipeAmount(pieces)} közepes banán.',
      'About ${_formatRecipeAmount(pieces)} medium banana(s).',
      'Ca. ${_formatRecipeAmount(pieces)} mittelgroße Banane(n).',
      'Aprox. ${_formatRecipeAmount(pieces)} plátano(s) mediano(s).',
    );
  }
  if (name.contains('alma')) {
    final pieces = amount / 150;
    return approx(
      'Kb. ${_formatRecipeAmount(pieces)} közepes alma.',
      'About ${_formatRecipeAmount(pieces)} medium apple(s).',
      'Ca. ${_formatRecipeAmount(pieces)} mittelgroße Äpfel.',
      'Aprox. ${_formatRecipeAmount(pieces)} manzana(s) mediana(s).',
    );
  }
  if (name.contains('eper')) {
    final pieces = amount / 15;
    return approx(
      'Kb. ${_formatRecipeAmount(pieces)} szem eper.',
      'About ${_formatRecipeAmount(pieces)} strawberries.',
      'Ca. ${_formatRecipeAmount(pieces)} Erdbeeren.',
      'Aprox. ${_formatRecipeAmount(pieces)} fresa(s).',
    );
  }
  if (name.contains('bogyós')) {
    return approx(
      'Kb. egy kisebb maréknyi adag.',
      'About a small handful.',
      'Etwa eine kleine Handvoll.',
      'Aprox. un puñado pequeño.',
    );
  }
  if (name.contains('méz') || name.contains('juharszirup')) {
    final teaspoons = amount / 7;
    return approx(
      'Kb. ${_formatRecipeAmount(teaspoons)} teáskanál.',
      'About ${_formatRecipeAmount(teaspoons)} tsp.',
      'Ca. ${_formatRecipeAmount(teaspoons)} TL.',
      'Aprox. ${_formatRecipeAmount(teaspoons)} cucharadita(s).',
    );
  }
  if (name.contains('fahéj') ||
      name.contains('kakaó') ||
      name.contains('chia')) {
    final teaspoons = amount / 3;
    return approx(
      'Kb. ${_formatRecipeAmount(teaspoons)} teáskanál.',
      'About ${_formatRecipeAmount(teaspoons)} tsp.',
      'Ca. ${_formatRecipeAmount(teaspoons)} TL.',
      'Aprox. ${_formatRecipeAmount(teaspoons)} cucharadita(s).',
    );
  }
  if (name.contains('olívaolaj') || name.contains('mustár')) {
    final tablespoons = amount / 15;
    return approx(
      'Kb. ${_formatRecipeAmount(tablespoons)} evőkanál.',
      'About ${_formatRecipeAmount(tablespoons)} tbsp.',
      'Ca. ${_formatRecipeAmount(tablespoons)} EL.',
      'Aprox. ${_formatRecipeAmount(tablespoons)} cucharada(s).',
    );
  }
  if (name.contains('zab')) {
    return approx(
      'Szárazon mérd ki; melegítés után 3-5 perc pihentetéstől krémesebb lesz.',
      'Measure dry; after heating, resting 3-5 minutes makes it creamier.',
      'Trocken abwiegen; nach dem Erhitzen 3-5 Minuten quellen lassen.',
      'Pésala en seco; tras calentar, reposa 3-5 minutos para más cremosidad.',
    );
  }
  if (name.contains('granola')) {
    return approx(
      'Kész, ropogós alapanyag, csak mérd ki és tálaláskor add hozzá.',
      'Ready crunchy ingredient; just measure and add when serving.',
      'Fertige knusprige Zutat; nur abwiegen und beim Servieren zugeben.',
      'Ingrediente crujiente listo; solo pésalo y añádelo al servir.',
    );
  }
  if (name.contains('uborka') ||
      name.contains('paradicsom') ||
      name.contains('paprika') ||
      name.contains('répa') ||
      name.contains('cukkini')) {
    return approx(
      'Kb. egy kisebb adag feldarabolt zöldség.',
      'About a small portion of chopped vegetables.',
      'Etwa eine kleine Portion geschnittenes Gemüse.',
      'Aprox. una porción pequeña de verdura troceada.',
    );
  }
  if (name.contains('sajt') ||
      name.contains('túró') ||
      name.contains('joghurt') ||
      name.contains('cottage')) {
    return approx(
      'Konyhai mérlegen a legpontosabb kimérni.',
      'Best measured on a kitchen scale.',
      'Am genauesten mit einer Küchenwaage abwiegen.',
      'Lo más preciso es pesarlo con una báscula de cocina.',
    );
  }
  return approx(
    'A pontos kalóriához mérlegen mérd ki.',
    'Use a kitchen scale for the most accurate calories.',
    'Für genaue Kalorien mit der Küchenwaage abwiegen.',
    'Para calorías precisas, pésalo con una báscula.',
  );
}

String? _recipeStepHint(BuildContext context, String step) {
  final languageCode = AppScope.of(context).resolvedLanguageCode(context);
  final lower = step.toLowerCase();
  String local(String hu, String en, String de, String es) {
    return switch (languageCode) {
      'hu' => hu,
      'de' => de,
      'es' => es,
      _ => en,
    };
  }

  if (lower.contains('rizstésztát')) {
    return local(
      'Általában 5-8 perc forró vizes áztatás elég; ha főzöd, csak addig, amíg rugalmas, de nem pépes.',
      'Usually 5-8 minutes in hot water is enough; if boiling, cook only until flexible, not mushy.',
      'Meist reichen 5-8 Minuten in heißem Wasser; beim Kochen nur garen, bis sie elastisch, nicht matschig ist.',
      'Normalmente bastan 5-8 minutos en agua caliente; si la cueces, que quede flexible, no blanda.',
    );
  }
  if (lower.contains('tésztát főzd')) {
    return local(
      'Bő, sós vízben főzd, általában 8-11 percig; al dente állagnál szűrd le.',
      'Cook in plenty of salted water, usually 8-11 minutes; drain when al dente.',
      'In reichlich Salzwasser meist 8-11 Minuten kochen; al dente abgießen.',
      'Cuece en abundante agua salada, normalmente 8-11 minutos; escurre al dente.',
    );
  }
  if (lower.contains('rizst főzd')) {
    return local(
      'Száraz rizshez kb. kétszeres víz kell. Fedő alatt, alacsony lángon főzd 12-15 percig, majd pihentesd 5 percet.',
      'Use about twice as much water as dry rice. Simmer covered on low heat for 12-15 minutes, then rest 5 minutes.',
      'Für trockenen Reis etwa doppelt so viel Wasser nehmen. Zugedeckt 12-15 Minuten leise kochen, dann 5 Minuten ruhen lassen.',
      'Usa aprox. el doble de agua que de arroz seco. Cocina tapado a fuego bajo 12-15 min y reposa 5 min.',
    );
  }
  if (lower.contains('bulgurt főzd')) {
    return local(
      'A bulgurhoz kb. kétszeres forró víz kell. Fedd le 10-12 percre, majd villával lazítsd át.',
      'Use about twice as much hot water as bulgur. Cover for 10-12 minutes, then fluff with a fork.',
      'Für Bulgur etwa doppelt so viel heißes Wasser nehmen. 10-12 Minuten abdecken, dann mit der Gabel lockern.',
      'Usa aprox. el doble de agua caliente que de bulgur. Tapa 10-12 min y suelta con un tenedor.',
    );
  }
  if (lower.contains('kuszkuszt')) {
    return local(
      'A kuszkuszhoz kb. azonos mennyiségű forró víz elég. Fedd le 5-8 percre, majd lazítsd át.',
      'Use roughly the same amount of hot water as couscous. Cover for 5-8 minutes, then fluff.',
      'Für Couscous reicht etwa die gleiche Menge heißes Wasser. 5-8 Minuten abdecken, dann lockern.',
      'Usa aprox. la misma cantidad de agua caliente que de cuscús. Tapa 5-8 min y suelta.',
    );
  }
  if (lower.contains('quinoát főzd')) {
    return local(
      'A quinoát főzés előtt öblítsd át. Kb. kétszeres vízzel, fedő alatt 12-15 percig főzd.',
      'Rinse quinoa before cooking. Use about twice as much water and simmer covered for 12-15 minutes.',
      'Quinoa vor dem Kochen abspülen. Mit etwa doppelt so viel Wasser zugedeckt 12-15 Minuten kochen.',
      'Enjuaga la quinoa antes de cocinar. Usa aprox. el doble de agua y cuece tapada 12-15 min.',
    );
  }
  if (lower.contains('burgonyát főzd') ||
      lower.contains('burgonyát főzd vagy süsd')) {
    return local(
      'Kockázva főzve kb. 15-20 perc alatt puhul meg; sütőben 200 fokon 25-35 perc kellhet.',
      'Diced potatoes soften in about 15-20 minutes boiling; roasting at 200 C can take 25-35 minutes.',
      'Gewürfelt braucht sie gekocht ca. 15-20 Minuten; im Ofen bei 200 Grad etwa 25-35 Minuten.',
      'En dados se cuece en 15-20 min; al horno a 200 grados puede tardar 25-35 min.',
    );
  }
  if (lower.contains('tojásokat főzd')) {
    return local(
      'M-es tojással számolva: lágy 6-7 perc, krémes közép 8-9 perc, kemény 10-11 perc forrástól számítva.',
      'Using medium eggs: soft 6-7 min, jammy 8-9 min, hard 10-11 min from boiling.',
      'Mit Eiern Größe M: weich 6-7 Min., cremig 8-9 Min., hart 10-11 Min. ab Kochbeginn.',
      'Con huevos medianos: blando 6-7 min, cremoso 8-9 min, duro 10-11 min desde que hierve.',
    );
  }
  if (lower.contains('tojásokat verd') || lower.contains('felvert tojást')) {
    return local(
      'M-es tojással számolj; verd fel villával, amíg a fehérje és a sárgája teljesen elkeveredik.',
      'Use medium eggs; beat with a fork until whites and yolks are fully combined.',
      'Eier Größe M verwenden; mit einer Gabel schlagen, bis Eiweiß und Eigelb verbunden sind.',
      'Usa huevos medianos; bate con tenedor hasta integrar clara y yema.',
    );
  }
  if (lower.contains('tojásból') || lower.contains('tojásként')) {
    return local(
      'M-es tojással számolj. Rántottánál alacsony-közepes hőn 2-3 perc alatt marad szaftos.',
      'Use medium eggs. For scrambled eggs, low-medium heat keeps them creamy in 2-3 minutes.',
      'Eier Größe M verwenden. Rührei bleibt bei niedriger bis mittlerer Hitze in 2-3 Minuten saftig.',
      'Usa huevos medianos. Para revuelto, fuego bajo-medio durante 2-3 min lo mantiene jugoso.',
    );
  }
  if (lower.contains('turmix')) {
    return local(
      'Ha túl sűrű, apránként adj hozzá folyadékot, így nem hígul túl.',
      'If it is too thick, add liquid gradually so it does not get too thin.',
      'Wenn es zu dick ist, Flüssigkeit nach und nach zugeben.',
      'Si queda muy espeso, añade líquido poco a poco.',
    );
  }
  if (lower.contains('hűtő') || lower.contains('éjszakára')) {
    return local(
      'Zárható dobozban vagy pohárban praktikus, reggel csak át kell keverni.',
      'Use a sealed jar or container; in the morning just stir it.',
      'In einem verschließbaren Glas oder Behälter lagern und morgens umrühren.',
      'Guárdalo en un tarro o recipiente cerrado y remueve por la mañana.',
    );
  }
  if (lower.contains('tzatziki')) {
    return local(
      'Ha nem kész tzatzikit használsz: sűrű görög joghurtba keverj reszelt, kinyomkodott uborkát, kevés citromlevet, fokhagymát, sót és borsot. Pihentesd 5-10 percet, hogy összeérjen.',
      'If you are not using ready-made tzatziki, mix thick Greek yogurt with grated squeezed cucumber, a little lemon juice, garlic, salt, and pepper. Rest 5-10 minutes so the flavors come together.',
      'Wenn du kein fertiges Tzatziki nutzt: dicken griechischen Joghurt mit geriebener, ausgedrückter Gurke, etwas Zitronensaft, Knoblauch, Salz und Pfeffer mischen. 5-10 Minuten ziehen lassen.',
      'Si no usas tzatziki comprado, mezcla yogur griego espeso con pepino rallado y escurrido, un poco de limón, ajo, sal y pimienta. Reposa 5-10 minutos.',
    );
  }
  if (lower.contains('joghurtos öntet') ||
      lower.contains('joghurtos szósszal') ||
      lower.contains('joghurtból készíts')) {
    return local(
      'Az öntethez keverd simára a joghurtot kevés citromlével, sóval, borssal és opcionálisan mustárral vagy fokhagymával. Ha túl sűrű, 1-2 teáskanál vízzel lazítsd.',
      'For the dressing, mix the yogurt with a little lemon juice, salt, pepper, and optionally mustard or garlic until smooth. If too thick, loosen with 1-2 teaspoons of water.',
      'Für das Dressing Joghurt mit etwas Zitronensaft, Salz, Pfeffer und optional Senf oder Knoblauch glatt rühren. Wenn es zu dick ist, mit 1-2 TL Wasser verdünnen.',
      'Para el aderezo, mezcla el yogur con un poco de limón, sal, pimienta y opcionalmente mostaza o ajo. Si queda espeso, aligera con 1-2 cucharaditas de agua.',
    );
  }
  if (lower.contains('mustáros szósszal')) {
    return local(
      'A mustáros szószhoz keverd el a mustárt kevés joghurttal vagy főzőlével, majd sóval és borssal igazítsd. Így nem csak mustárt teszel rá, hanem valódi öntetet kapsz.',
      'For the mustard sauce, mix mustard with a little yogurt or cooking liquid, then adjust with salt and pepper. This makes it a real sauce, not just plain mustard.',
      'Für die Senfsauce Senf mit etwas Joghurt oder Kochflüssigkeit verrühren und mit Salz und Pfeffer abschmecken. So entsteht eine echte Sauce.',
      'Para la salsa de mostaza, mezcla mostaza con un poco de yogur o líquido de cocción y ajusta con sal y pimienta. Así queda una salsa real.',
    );
  }
  if (lower.contains('paradicsomszósz') ||
      lower.contains('paradicsomszósszal')) {
    return local(
      'Ha alap paradicsomszószt használsz, főzd 5-8 percig sóval, borssal, fokhagymával és oregánóval vagy bazsalikommal, hogy ne nyers paradicsomízű legyen.',
      'If using plain tomato sauce, simmer it 5-8 minutes with salt, pepper, garlic, and oregano or basil so it does not taste raw.',
      'Wenn du einfache Tomatensauce nutzt, 5-8 Minuten mit Salz, Pfeffer, Knoblauch und Oregano oder Basilikum köcheln lassen.',
      'Si usas salsa de tomate simple, cocínala 5-8 minutos con sal, pimienta, ajo y orégano o albahaca para quitar el sabor crudo.',
    );
  }
  if (lower.contains('süsd') ||
      lower.contains('pirítsd') ||
      lower.contains('serpenyő')) {
    return local(
      'Közepes hőfokon dolgozz, így nem ég meg kívül, mielőtt belül elkészül.',
      'Use medium heat so the outside does not burn before the inside is done.',
      'Bei mittlerer Hitze arbeiten, damit außen nichts verbrennt.',
      'Cocina a fuego medio para que no se queme por fuera antes de hacerse.',
    );
  }
  if (lower.contains('főzd') || lower.contains('párold')) {
    return local(
      'A főzési idő alapanyagtól függhet, a kész állagot ellenőrizd.',
      'Cooking time can vary, so check the final texture.',
      'Die Garzeit kann variieren, daher die Konsistenz prüfen.',
      'El tiempo puede variar; comprueba la textura final.',
    );
  }
  if (lower.contains('keverd')) {
    return local(
      'Addig keverd, amíg egységes állagot kapsz, így pontosabban adagolható.',
      'Mix until even in texture so it portions more accurately.',
      'So lange rühren, bis die Masse gleichmäßig ist.',
      'Mezcla hasta que quede uniforme para porcionar mejor.',
    );
  }
  if (lower.contains('vágd') || lower.contains('szeleteld')) {
    return local(
      'Hasonló méretű darabokra vágd, így egyenletesebben készül el.',
      'Cut into similar-sized pieces so it cooks more evenly.',
      'In ähnlich große Stücke schneiden, damit alles gleichmäßig gart.',
      'Corta en piezas parecidas para que se cocinen de forma uniforme.',
    );
  }
  return null;
}

String _formatRecipeAmount(double value) {
  if (value == value.roundToDouble()) return value.round().toString();
  return value.toStringAsFixed(1);
}

String _formatIngredientAmount(double value, String unit) {
  if (unit == 'g' || unit == 'ml') return value.round().toString();
  if ((value - value.round()).abs() < 0.05) return value.round().toString();
  return value.toStringAsFixed(1);
}

List<ShoppingListItem> _recipeShoppingItems(
  BuildContext context,
  Recipe recipe,
  int servings,
) {
  final scale = servings / recipe.baseServings;
  return recipe.ingredients
      .map(
        (ingredient) => ShoppingListItem(
          name:
              '${tx(context, ingredient.name)} - ${_formatIngredientAmount(ingredient.amount * scale, ingredient.unit)} ${tx(context, ingredient.unit)}',
        ),
      )
      .toList();
}

List<ShoppingListItem> _mealPrepShoppingItems(
  BuildContext context,
  MealPrepPlan plan,
) {
  return [
    ShoppingListItem(
      name:
          '${plan.foodName} - ${grams(plan.totalRawNeeded)} ${tx(context, 'nyersen')}',
    ),
    if (plan.hasSide)
      ShoppingListItem(
        name:
            '${plan.sideFoodName} - ${grams(plan.sideTotalRawNeeded)} ${tx(context, 'nyersen')}',
      ),
  ];
}

void showProPaywallSheet(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: const Color(0xCC000000),
    builder: (context) {
      final isPro = AppScope.of(context).isPro;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.maybePop(context),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 8),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: SizedBox(
                height:
                    MediaQuery.sizeOf(context).height * (isPro ? 0.62 : 0.82),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                  child: ProUpsellCard(),
                ),
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
  if (state.isDark) {
    return Color.alphaBlend(p.accent.withValues(alpha: 0.025), p.card);
  }
  return Color.alphaBlend(p.accent.withValues(alpha: 0.025), p.card);
}

Color _disabledActionText(AppState state) {
  final p = state.palette;
  return state.isDark
      ? p.muted.withValues(alpha: 0.78)
      : p.muted.withValues(alpha: 0.90);
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
    return AppPrimaryPillButton(
      icon: icon,
      label: label,
      enabled: enabled,
      onPressed: onPressed,
    );
  }
}

class _FoodSectionHeader extends StatelessWidget {
  const _FoodSectionHeader({required this.label, this.freeCount});

  final String label;
  final int? freeCount;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final filled = (freeCount ?? 0) >= 1;
    final labelColor = state.isDark
        ? Color.alphaBlend(p.accent.withValues(alpha: 0.62), p.muted)
        : p.accentDim;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), style: MealText.section(labelColor)),
          if (freeCount != null) ...[
            const SizedBox(width: 9),
            Text(
              '${freeCount!}/1',
              style: MealText.section(
                filled ? p.accent : p.muted,
              ).copyWith(letterSpacing: 0, fontSize: 11.5),
            ),
          ],
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
    final state = AppScope.of(context);
    final p = state.palette;
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
        label: tx(context, 'Törlés'),
        color: const Color(0xFFC04040),
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        FocusManager.instance.primaryFocus?.unfocus();
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
                          '${tx(context, 'Hozzáadva')}: ${_addedLabel(context, widget.food.addedLabel)}',
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
                      label: tx(context, 'Kész súly'),
                      value: grams(widget.food.cookedWeight),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tx(context, 'Kimért adag'),
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
                            tx(context, 'Nyers egyenérték'),
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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (sharingEnabled)
                          Expanded(
                            child: _FoodActionButton(
                              icon: CupertinoIcons.square_arrow_up,
                              label: tx(context, 'Megosztás'),
                              color: p.accent,
                              onPressed: () => _shareFood(context),
                            ),
                          ),
                        if (sharingEnabled) const SizedBox(width: 8),
                        Expanded(
                          child: _FoodActionButton(
                            icon: CupertinoIcons.pencil,
                            label: tx(context, 'Szerkesztés'),
                            color: p.accent,
                            onPressed: () => showCupertinoModalPopup<void>(
                              context: context,
                              barrierDismissible: true,
                              barrierColor: const Color(0x99000000),
                              builder: (_) => AddFoodSheet(food: widget.food),
                            ),
                          ),
                        ),
                        if (notesEnabled) const SizedBox(width: 8),
                        if (notesEnabled)
                          Expanded(
                            child: _FoodActionButton(
                              icon: CupertinoIcons.doc_text,
                              label: tx(context, 'Jegyzet'),
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
                      placeholder: tx(
                        context,
                        'Írj receptet, tippet vagy emlékeztetőt...',
                      ),
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
      barrierDismissible: true,
      barrierColor: const Color(0x99000000),
      builder: (_) => AddMealPrepSheet(initialFood: widget.food),
    );
  }

  Future<void> _shareFood(BuildContext context) async {
    final food = widget.food;
    final text = [
      food.name,
      '${tx(context, 'Nyers adag')}: ${grams(food.rawWeight)}',
      '${tx(context, 'Kész súly')}: ${grams(food.cookedWeight)}',
      '${tx(context, 'Kimért adag')}: ${grams(food.servedWeight)}',
      '${tx(context, 'Nyers egyenérték')}: ${grams(food.rawEquivalent)}',
      if (food.hasNote) '${tx(context, 'Jegyzet')}: ${food.note}',
    ].join('\n');
    await const ShareService().shareText(text);
  }
}

String _addedLabel(BuildContext context, String label) {
  return switch (label.trim().toLowerCase()) {
    'ma' => tx(context, 'Ma'),
    'tegnap' => tx(context, 'Tegnap'),
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
    final state = AppScope.of(context);
    final p = state.palette;
    return SpringPressable(
      pressedScale: 0.975,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        color: p.bg,
        borderRadius: BorderRadius.circular(10),
        onPressed: withAppActionHaptic(onPressed),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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
        transitionBetweenRoutes: false,
        backgroundColor: state.headerSurface,
        border: null,
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
                  barrierDismissible: true,
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
          barrierDismissible: true,
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
                barrierDismissible: true,
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
    return AppKeyboardSheetPosition(
      child: GlassSurface(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        radius: 22,
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
                  subtitle: tx(context, 'Nevezd el és add hozzá a tételeket'),
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
                  onPressed: withAppActionHaptic(_addItemRow),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.plus_circle_fill, color: p.accent),
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
                        color: canSave ? p.accent : _disabledActionFill(state),
                        borderRadius: BorderRadius.circular(14),
                        onPressed: canSave
                            ? withAppActionHaptic(() {
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
                              })
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
    final checkedCount = list.items.where((item) => item.checked).length;
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
                      subtitle:
                          '${_shoppingDate(list.createdAt)} · $checkedCount/${list.items.length}',
                    ),
                    const SizedBox(height: 12),
                    if (checkedCount > 0) ...[
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          color: p.resultBg,
                          borderRadius: BorderRadius.circular(12),
                          onPressed: () =>
                              state.clearCheckedShoppingItems(list!.id),
                          child: Text(
                            tx(context, 'Kipipált tételek törlése'),
                            style: TextStyle(
                              color: p.accent,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
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
                        borderRadius: BorderRadius.circular(12),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          tx(context, 'Bezárás'),
                          style: TextStyle(
                            color: p.muted,
                            fontWeight: FontWeight.w500,
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
      onPressed: withAppActionHaptic(onPressed),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        decoration: BoxDecoration(
          color: p.bg,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: p.border.withValues(alpha: 0.62)),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
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
      onPressed: withAppActionHaptic(onPressed),
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
    return AppSheetHeader(icon: icon, title: title, subtitle: subtitle);
  }
}

String _shoppingDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}. $month. $day.';
}

class _WarmBackButton extends StatelessWidget {
  const _WarmBackButton();

  static const double _size = 38;
  static const double _radius = 12;
  static const double _iconSize = 19;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Align(
      alignment: Alignment.centerLeft,
      child: SpringPressable(
        pressedScale: 0.96,
        child: CupertinoButton(
          minimumSize: const Size(_size, _size),
          padding: EdgeInsets.zero,
          color: p.card,
          borderRadius: BorderRadius.circular(_radius),
          onPressed: () => Navigator.maybePop(context),
          child: Icon(
            CupertinoIcons.chevron_left,
            color: p.accent,
            size: _iconSize,
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
        transitionBetweenRoutes: false,
        backgroundColor: state.headerSurface,
        border: null,
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
                    ? withAppActionHaptic(
                        () => showCupertinoModalPopup<void>(
                          context: context,
                          barrierDismissible: true,
                          barrierColor: const Color(0x99000000),
                          builder: (_) => const AddMealPrepSheet(),
                        ),
                      )
                    : withAppActionHaptic(() => showProPaywallSheet(context)),
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
          barrierDismissible: true,
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

    return AppKeyboardSheetPosition(
      child: GlassSurface(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 15),
        radius: 22,
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
                const SizedBox(height: 8),
                _Input(
                  controller: nameController,
                  placeholder: tx(context, 'Terv neve'),
                  onChanged: () => setState(() {}),
                ),
                const SizedBox(height: 7),
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
                const SizedBox(height: 5),
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
                    fontSize: 12,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  tx(context, 'Főétel'),
                  style: TextStyle(
                    color: p.text,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                _MealPrepFoodPicker(
                  foods: mainFoods.isEmpty ? state.foods : mainFoods,
                  selected: selectedFood,
                  onSelected: (food) => setState(() => selectedFood = food),
                ),
                const SizedBox(height: 7),
                Text(
                  tx(context, 'Köret hozzáadása'),
                  style: TextStyle(
                    color: p.text,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                _MealPrepFoodPicker(
                  foods: sideFoods,
                  selected: selectedSideFood,
                  optionalLabel: tx(context, 'Nincs köret'),
                  onSelected: (food) => setState(() => selectedSideFood = food),
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
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        borderRadius: BorderRadius.circular(12),
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
                        color: canSave ? p.accent : _disabledActionFill(state),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        borderRadius: BorderRadius.circular(12),
                        onPressed: canSave
                            ? withAppActionHaptic(() {
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
                              })
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
    final state = AppScope.of(context);
    final p = state.palette;
    return Expanded(
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        color: active ? state.primaryActionSurface : p.bg,
        borderRadius: BorderRadius.circular(12),
        onPressed: withAppActionHaptic(onTap),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: TextStyle(
              color: active ? p.buttonText : p.muted,
              fontSize: 12.8,
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
    final state = AppScope.of(context);
    final p = state.palette;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: withAppActionHaptic(onPressed),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          color: active ? p.resultBg : p.bg.withValues(alpha: 0.76),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active
                ? p.resultBorder.withValues(alpha: 0.76)
                : p.border.withValues(alpha: 0.62),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: p.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
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
              style: TextStyle(
                color: p.accent,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: p.accent,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
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
                              barrierDismissible: true,
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
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        color: state.isPro
                            ? state.primaryActionSurface
                            : _disabledActionFill(state),
                        borderRadius: BorderRadius.circular(14),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        onPressed: state.isPro
                            ? withAppActionHaptic(() {
                                state.addShoppingList(
                                  name: '${plan!.name} shopping',
                                  items: _mealPrepShoppingItems(context, plan),
                                );
                                Navigator.pop(context);
                              })
                            : withAppActionHaptic(
                                () => showProPaywallSheet(context),
                              ),
                        child: Text(
                          tx(context, 'Bevásárlólista mentése'),
                          style: TextStyle(
                            color: state.isPro
                                ? p.buttonText
                                : _disabledActionText(state),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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
      onPressed: withAppActionHaptic(onPressed),
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
  const AddFoodSheet({
    this.initialCategory = FoodCategory.main,
    this.allowCategorySelection = true,
    this.food,
    super.key,
  });

  final FoodCategory initialCategory;
  final bool allowCategorySelection;
  final FoodItem? food;

  @override
  State<AddFoodSheet> createState() => _AddFoodSheetState();
}

class _AddFoodSheetState extends State<AddFoodSheet> {
  late FoodCategory category;
  final name = TextEditingController();
  final raw = TextEditingController();
  final cooked = TextEditingController();
  final served = TextEditingController();
  final nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final food = widget.food;
    category = food?.category ?? widget.initialCategory;
    if (food != null) {
      name.text = food.name;
      raw.text = food.rawWeight.toStringAsFixed(0);
      cooked.text = food.cookedWeight.toStringAsFixed(0);
      served.text = food.servedWeight.toStringAsFixed(0);
    }
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
    final editingFood = widget.food;
    final showCategoryPicker =
        widget.allowCategorySelection || editingFood != null;
    final canAddMain =
        state.canAddFood(FoodCategory.main) ||
        editingFood?.category == FoodCategory.main;
    final canAddSide =
        state.canAddFood(FoodCategory.side) ||
        editingFood?.category == FoodCategory.side;
    final canAddSelected =
        state.canAddFood(category) || editingFood?.category == category;
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

    return AppSheetFrame(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      scrollable: false,
      avoidKeyboard: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              tx(
                context,
                widget.food == null
                    ? 'Új étel hozzáadása'
                    : 'Étel szerkesztése',
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: p.text,
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 9),
          if (showCategoryPicker) ...[
            Row(
              children: [
                Expanded(
                  child: AppChoicePill(
                    label: tx(context, 'Főétel'),
                    active: category == FoodCategory.main,
                    fullWidth: true,
                    enabled: canAddMain,
                    onPressed: () =>
                        setState(() => category = FoodCategory.main),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppChoicePill(
                    label: tx(context, 'Köret'),
                    active: category == FoodCategory.side,
                    fullWidth: true,
                    enabled: canAddSide,
                    onPressed: () =>
                        setState(() => category = FoodCategory.side),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
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
            padding: const EdgeInsets.fromLTRB(13, 9, 13, 9),
            decoration: BoxDecoration(
              color: p.resultBg,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: p.resultBorder),
            ),
            child: Row(
              children: [
                Text(
                  tx(context, 'Nyers egyenérték'),
                  style: TextStyle(
                    color: p.accent,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  result <= 0 ? '- g' : grams(result),
                  style: TextStyle(
                    color: p.accent,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: AppSecondaryPillButton(
                  label: tx(context, 'Mégse'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: AppPrimaryPillButton(
                  label: tx(context, 'Mentés'),
                  enabled: canAddSelected,
                  onPressed: canAddSelected
                      ? () {
                          final food = widget.food;
                          if (food == null) {
                            state.addFood(
                              name: name.text,
                              category: category,
                              rawWeight: _num(raw),
                              cookedWeight: _num(cooked),
                              servedWeight: _num(served),
                            );
                          } else {
                            state.updateFood(
                              id: food.id,
                              name: name.text,
                              category: category,
                              rawWeight: _num(raw),
                              cookedWeight: _num(cooked),
                              servedWeight: _num(served),
                            );
                          }
                          Navigator.pop(context);
                        }
                      : () {},
                ),
              ),
            ],
          ),
        ],
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
    final isNumeric = numericTitle != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: AppTextFieldBox(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        placeholder: placeholder,
        keyboardType: isNumeric
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        onChanged: onChanged,
      ),
    );
  }
}

class ProUpsellCard extends StatelessWidget {
  const ProUpsellCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return GlassSurface(
      width: double.infinity,
      padding: EdgeInsets.zero,
      radius: 22,
      tint: p.card,
      opacity: 1,
      borderColor: p.border.withValues(alpha: 0.42),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: const MealWeightMark(size: 40, radius: 12),
                ),
                const SizedBox(width: 10),
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
                          letterSpacing: -0.6,
                        ),
                      ),
                      Text(
                        tx(context, 'Korlátlan mentés és extra funkciók'),
                        style: TextStyle(
                          color: p.muted,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                CupertinoButton(
                  minimumSize: const Size(32, 32),
                  padding: EdgeInsets.zero,
                  color: p.bg,
                  borderRadius: BorderRadius.circular(16),
                  onPressed: () => Navigator.maybePop(context),
                  child: Icon(CupertinoIcons.xmark, color: p.muted, size: 15),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 2, 14, 20),
              child: Column(
                children: [
                  _PaywallFeatureSections(isPro: state.isPro),
                  if (!state.isPro) ...[
                    const SizedBox(height: 10),
                    _PricingCard(),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        color: state.primaryActionSurface,
                        borderRadius: BorderRadius.circular(14),
                        onPressed: () {},
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            tx(context, 'Próbáld ki ingyen 7 napig'),
                            maxLines: 1,
                            style: TextStyle(
                              color: p.buttonText,
                              fontSize: 16,
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
                        fontSize: 11.5,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaywallFeatureSections extends StatelessWidget {
  const _PaywallFeatureSections({required this.isPro});

  final bool isPro;

  @override
  Widget build(BuildContext context) {
    final proFeatures = [
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
        icon: CupertinoIcons.chart_bar_alt_fill,
        title: tx(context, 'Heti táplálkozási pillanatkép'),
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
    ];

    if (isPro) {
      return _PaywallFeatureGroup(
        title: tx(context, 'Korlátlan mentés és extra funkciók'),
        subtitle: tx(context, 'Rendszeres használathoz'),
        accent: true,
        features: proFeatures,
      );
    }

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
          features: proFeatures,
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
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 7),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accent
              ? p.resultBorder.withValues(alpha: 0.46)
              : p.border.withValues(alpha: 0.34),
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
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 9),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: p.resultBg.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: p.border.withValues(alpha: 0.34)),
            ),
            child: Icon(feature.icon, color: p.accent, size: 14),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              feature.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: p.text,
                fontSize: 14,
                height: 1.22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (feature.limit != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: p.resultBg.withValues(alpha: 0.84),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: p.border.withValues(alpha: 0.34)),
              ),
              child: Text(
                feature.limit!,
                style: TextStyle(
                  color: p.accent,
                  fontSize: 12.5,
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
    final radius = BorderRadius.circular(14);
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: radius,
          border: Border.all(color: p.border.withValues(alpha: 0.36)),
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
              child: Container(
                height: 1,
                color: p.border.withValues(alpha: 0.36),
              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
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
                          fontSize: 15.5,
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
                            fontSize: 11,
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
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: p.muted,
                fontFamily: MealText.family,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: price,
                  style: TextStyle(
                    color: p.accent,
                    fontSize: 19,
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
