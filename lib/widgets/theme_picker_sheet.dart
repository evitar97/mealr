import 'package:flutter/cupertino.dart';

import '../app/app_state.dart';
import '../app/app_strings.dart';
import '../features/food/food_list_screen.dart';
import '../models/theme_option.dart';
import '../theme/app_typography.dart';
import '../theme/mealweight_theme.dart';
import 'app_sheet.dart';
import 'spring_pressable.dart';

void showThemePickerSheet(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: const Color(0x99000000),
    builder: (sheetContext) => ThemePickerSheet(hostContext: context),
  );
}

class ThemePickerSheet extends StatelessWidget {
  const ThemePickerSheet({super.key, required this.hostContext});

  final BuildContext hostContext;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final orderedThemes = [
      for (final id in [
        'forest',
        'original',
        'clean',
        'ocean',
        'blush',
        'aurum',
      ])
        for (final theme in themeOptions)
          if (theme.id == id) theme,
    ];
    return AppSheetFrame(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      scrollable: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tx(context, 'Téma választása'),
            style: MealText.sheetTitle(p.text),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: orderedThemes.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final theme = orderedThemes[index];
                final selected = theme.id == state.theme.id;
                final unlocked = state.isPro || theme.isFree;
                return _ThemeTile(
                  theme: theme,
                  selected: selected,
                  unlocked: unlocked,
                  darkMode: state.isDark,
                  onPressed: () {
                    if (unlocked) {
                      state.selectTheme(theme);
                      Navigator.pop(context);
                      return;
                    }
                    Navigator.pop(context);
                    showProPaywallSheet(hostContext);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.theme,
    required this.selected,
    required this.unlocked,
    required this.darkMode,
    required this.onPressed,
  });

  final ThemeOption theme;
  final bool selected;
  final bool unlocked;
  final bool darkMode;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    final sample = darkMode ? theme.dark : theme.light;
    final statusColor = sample.accent;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: SpringPressable(
        child: Container(
          width: 96,
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 9),
          decoration: BoxDecoration(
            color: selected
                ? Color.alphaBlend(
                    sample.accent.withValues(alpha: darkMode ? 0.09 : 0.06),
                    p.card,
                  )
                : p.card,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected
                  ? sample.accent.withValues(alpha: 0.74)
                  : p.border.withValues(alpha: darkMode ? 0.58 : 0.30),
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  selected
                      ? CupertinoIcons.check_mark_circled_solid
                      : unlocked
                      ? CupertinoIcons.circle
                      : CupertinoIcons.lock,
                  color: statusColor.withValues(alpha: unlocked ? 1 : 0.8),
                  size: 14,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ThemeGlyph(id: theme.id, color: sample.accent, size: 31),
                  const SizedBox(height: 7),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      tx(context, theme.name),
                      maxLines: 1,
                      style: MealText.bodyStrong(p.text).copyWith(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeGlyph extends StatelessWidget {
  const _ThemeGlyph({
    required this.id,
    required this.color,
    required this.size,
  });

  final String id;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ThemeGlyphPainter(id: id, color: color),
      ),
    );
  }
}

class _ThemeGlyphPainter extends CustomPainter {
  const _ThemeGlyphPainter({required this.id, required this.color});

  final String id;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width * 0.09;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (id) {
      case 'forest':
        _paintLeaf(canvas, size, stroke, fill);
      case 'original':
        _paintToast(canvas, size, stroke, fill);
      case 'clean':
        _paintCream(canvas, size, stroke, fill);
      case 'ocean':
        _paintDrop(canvas, size, stroke, fill);
      case 'blush':
        _paintCandy(canvas, size, stroke, fill);
      case 'aurum':
        _paintBowl(canvas, size, stroke, fill);
      default:
        canvas.drawCircle(size.center(Offset.zero), size.width * 0.34, fill);
    }
  }

  void _paintToast(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.20,
        size.height * 0.18,
        size.width * 0.60,
        size.height * 0.68,
      ),
      Radius.circular(size.width * 0.18),
    );
    canvas.drawRRect(r, fill..color = color.withValues(alpha: 0.30));
    canvas.drawRRect(r, stroke);
    canvas.drawCircle(
      Offset(size.width * 0.42, size.height * 0.52),
      size.width * 0.035,
      Paint()..color = color,
    );
    canvas.drawCircle(
      Offset(size.width * 0.58, size.height * 0.62),
      size.width * 0.035,
      Paint()..color = color,
    );
  }

  void _paintLeaf(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.62)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.24,
        size.width * 0.68,
        size.height * 0.14,
        size.width * 0.78,
        size.height * 0.22,
      )
      ..cubicTo(
        size.width * 0.84,
        size.height * 0.56,
        size.width * 0.52,
        size.height * 0.82,
        size.width * 0.25,
        size.height * 0.62,
      );
    canvas.drawPath(path, fill..color = color.withValues(alpha: 0.30));
    canvas.drawPath(path, stroke);
    canvas.drawLine(
      Offset(size.width * 0.28, size.height * 0.62),
      Offset(size.width * 0.70, size.height * 0.26),
      stroke,
    );
  }

  void _paintDrop(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final path = Path()
      ..moveTo(size.width * 0.50, size.height * 0.14)
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.44,
        size.width * 0.72,
        size.height * 0.84,
        size.width * 0.50,
        size.height * 0.86,
      )
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.84,
        size.width * 0.22,
        size.height * 0.44,
        size.width * 0.50,
        size.height * 0.14,
      );
    canvas.drawPath(path, fill..color = color.withValues(alpha: 0.26));
    canvas.drawPath(path, stroke);
  }

  void _paintCream(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.70)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.45,
        size.width * 0.42,
        size.height * 0.44,
        size.width * 0.42,
        size.height * 0.28,
      )
      ..cubicTo(
        size.width * 0.42,
        size.height * 0.14,
        size.width * 0.68,
        size.height * 0.22,
        size.width * 0.58,
        size.height * 0.42,
      )
      ..cubicTo(
        size.width * 0.82,
        size.height * 0.44,
        size.width * 0.78,
        size.height * 0.76,
        size.width * 0.25,
        size.height * 0.70,
      );
    canvas.drawPath(path, fill..color = color.withValues(alpha: 0.22));
    canvas.drawPath(path, stroke);
  }

  void _paintCandy(Canvas canvas, Size size, Paint stroke, Paint fill) {
    canvas.drawCircle(
      Offset(size.width * 0.50, size.height * 0.50),
      size.width * 0.22,
      fill..color = color.withValues(alpha: 0.28),
    );
    canvas.drawCircle(
      Offset(size.width * 0.50, size.height * 0.50),
      size.width * 0.22,
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.28, size.height * 0.44),
      Offset(size.width * 0.12, size.height * 0.34),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.72, size.height * 0.56),
      Offset(size.width * 0.88, size.height * 0.66),
      stroke,
    );
  }

  void _paintBowl(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final bowl = Path()
      ..moveTo(size.width * 0.20, size.height * 0.54)
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.88,
        size.width * 0.80,
        size.height * 0.54,
      );
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.20,
        size.height * 0.43,
        size.width * 0.60,
        size.height * 0.20,
      ),
      stroke,
    );
    canvas.drawPath(bowl, stroke);
    canvas.drawCircle(
      Offset(size.width * 0.40, size.height * 0.38),
      size.width * 0.035,
      fill..color = color,
    );
    canvas.drawCircle(
      Offset(size.width * 0.53, size.height * 0.34),
      size.width * 0.035,
      fill,
    );
    canvas.drawCircle(
      Offset(size.width * 0.64, size.height * 0.39),
      size.width * 0.035,
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant _ThemeGlyphPainter oldDelegate) {
    return oldDelegate.id != id || oldDelegate.color != color;
  }
}
