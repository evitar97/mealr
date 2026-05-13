import 'package:flutter/cupertino.dart';

import '../../app/app_layout.dart';
import '../../app/app_state.dart';
import '../../app/app_strings.dart';
import '../../utils/calculators.dart';
import '../../widgets/glass_surface.dart';
import '../../widgets/spring_pressable.dart';

class CalorieScreen extends StatefulWidget {
  const CalorieScreen({super.key});

  @override
  State<CalorieScreen> createState() => _CalorieScreenState();
}

class _CalorieScreenState extends State<CalorieScreen> {
  bool howToOpen = false;

  final activities = const [
    ('Ülő életmód', 1.2),
    ('Enyhén aktív (heti 1–3x)', 1.375),
    ('Közepesen aktív (heti 3–5x)', 1.55),
    ('Erősen aktív (heti 6–7x)', 1.725),
    ('Extrém aktív', 1.9),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final age = state.calorieAge;
    final weight = state.calorieWeight;
    final height = state.calorieHeight;
    final gender = state.calorieGender;
    final activity = state.calorieActivity;
    final result = calculateCalories(
      age: age,
      weightKg: weight,
      heightCm: height,
      gender: gender,
      activityMultiplier: activity,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        AppLayout.screenBottomPadding,
      ),
      children: [
        _HowToCard(
          open: howToOpen,
          onToggle: () => setState(() => howToOpen = !howToOpen),
        ),
        const SizedBox(height: 12),
        _CaloriePanel(
          color: p.resultBg,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tx(context, 'NAPI SZINTENTARTÓ KALÓRIA'),
                style: TextStyle(
                  color: p.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.9,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                whole(result.tdee),
                style: TextStyle(
                  color: p.accent,
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1.4,
                ),
              ),
              Text(tx(context, 'kcal / nap'), style: TextStyle(color: p.muted)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _Metric(label: 'BMR', value: whole(result.bmr)),
                  const SizedBox(width: 8),
                  _Metric(
                    label: tx(context, 'Fogyáshoz'),
                    value: whole(result.lossTarget),
                  ),
                  const SizedBox(width: 8),
                  _Metric(
                    label: tx(context, 'Tömegnövelés'),
                    value: whole(result.gainTarget),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _SliderCard(
          label: tx(context, 'Életkor'),
          value: age.toDouble(),
          min: 1,
          max: 99,
          display: age.toString(),
          onChanged: (v) => state.updateCalorieAge(v.round()),
        ),
        const SizedBox(height: 12),
        _SliderCard(
          label: tx(context, 'Súly (kg)'),
          value: weight,
          min: 1,
          max: 200,
          display: weight.toStringAsFixed(1),
          decimalPlaces: 1,
          onChanged: state.updateCalorieWeight,
        ),
        const SizedBox(height: 12),
        _SliderCard(
          label: tx(context, 'Magasság (cm)'),
          value: height,
          min: 10,
          max: 250,
          display: height.round().toString(),
          onChanged: state.updateCalorieHeight,
        ),
        const SizedBox(height: 12),
        _CaloriePanel(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tx(context, 'Nem'),
                style: TextStyle(
                  color: p.muted,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _Choice(
                    label: tx(context, 'Férfi'),
                    active: gender == Gender.male,
                    onTap: () => state.updateCalorieGender(Gender.male),
                  ),
                  const SizedBox(width: 8),
                  _Choice(
                    label: tx(context, 'Nő'),
                    active: gender == Gender.female,
                    onTap: () => state.updateCalorieGender(Gender.female),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _CaloriePanel(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tx(context, 'Napi aktivitás'),
                style: TextStyle(
                  color: p.muted,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              for (final item in activities)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _Choice(
                    label: tx(context, item.$1),
                    active: activity == item.$2,
                    onTap: () => state.updateCalorieActivity(item.$2),
                    fullWidth: true,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _SaveStrip(
          saved: state.calorieSaved,
          onSave: state.saveCaloriesToProfile,
        ),
      ],
    );
  }
}

class _HowToCard extends StatelessWidget {
  const _HowToCard({required this.open, required this.onToggle});

  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return _CaloriePanel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoButton(
            padding: const EdgeInsets.fromLTRB(24, 13, 24, 12),
            onPressed: onToggle,
            child: Row(
              children: [
                Text(
                  tx(context, 'HOGYAN HASZNÁLD?'),
                  style: TextStyle(
                    color: p.muted,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.4,
                  ),
                ),
                const Spacer(),
                Icon(
                  open
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  color: p.muted,
                  size: 19,
                ),
              ],
            ),
          ),
          if (open)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: p.muted,
                    fontSize: 17,
                    height: 1.55,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: tx(context, 'Fogyáshoz: '),
                      style: TextStyle(
                        color: p.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: tx(
                        context,
                        'vonj le 300–500 kcal-t. Napi 500 kcal deficit ≈ heti 0,5 kg fogyás.\n\n',
                      ),
                    ),
                    TextSpan(
                      text: tx(context, 'Tömegnöveléshez: '),
                      style: TextStyle(
                        color: p.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: tx(
                        context,
                        'adj 150–300 kcal-t a szintentartóhoz.\n\n',
                      ),
                    ),
                    TextSpan(
                      text: tx(
                        context,
                        'Iránymutató – 2–4 hétig kövesd, majd a tényleges változás alapján igazítsd.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(color: p.text, fontWeight: FontWeight.w600),
            ),
            Text(label, style: TextStyle(color: p.muted, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _SliderCard extends StatefulWidget {
  const _SliderCard({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.display,
    required this.onChanged,
    this.decimalPlaces = 0,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final String display;
  final ValueChanged<double> onChanged;
  final int decimalPlaces;

  @override
  State<_SliderCard> createState() => _SliderCardState();
}

class _SliderCardState extends State<_SliderCard> {
  late final TextEditingController controller;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.display);
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        _commitManualValue();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _SliderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.display != widget.display && !focusNode.hasFocus) {
      controller.text = widget.display;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return _CaloriePanel(
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    color: p.text,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${_formatLimit(widget.min)} – ${_formatLimit(widget.max)}',
                  style: TextStyle(
                    color: p.muted.withValues(alpha: 0.72),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: widget.decimalPlaces == 0 ? 158 : 170,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: p.bg.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: p.border.withValues(alpha: 0.86)),
            ),
            child: Row(
              children: [
                _StepperButton(
                  icon: CupertinoIcons.minus,
                  onPressed: () => _stepValue(-1),
                ),
                Expanded(
                  child: CupertinoTextField(
                    controller: controller,
                    focusNode: focusNode,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: widget.decimalPlaces > 0,
                    ),
                    onTap: () => controller.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: controller.text.length,
                    ),
                    onChanged: _updateLiveValue,
                    textAlign: TextAlign.center,
                    padding: EdgeInsets.zero,
                    decoration: const BoxDecoration(),
                    style: TextStyle(
                      color: p.accent,
                      fontSize: 23,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.8,
                    ),
                    onSubmitted: (_) {
                      _commitManualValue();
                      focusNode.unfocus();
                    },
                    onEditingComplete: () {
                      _commitManualValue();
                      focusNode.unfocus();
                    },
                  ),
                ),
                _StepperButton(
                  icon: CupertinoIcons.plus,
                  onPressed: () => _stepValue(1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatLimit(double value) {
    return value == value.roundToDouble()
        ? value.round().toString()
        : value.toStringAsFixed(1);
  }

  void _commitManualValue() {
    final parsed = double.tryParse(controller.text.trim().replaceAll(',', '.'));
    if (parsed == null) return;
    final next = parsed.clamp(widget.min, widget.max);
    widget.onChanged(next);
    controller.text = _formatValue(next);
  }

  void _updateLiveValue(String text) {
    final parsed = double.tryParse(text.trim().replaceAll(',', '.'));
    if (parsed == null) return;
    widget.onChanged(parsed.clamp(widget.min, widget.max));
  }

  void _stepValue(int direction) {
    _commitManualValue();
    final current =
        double.tryParse(controller.text.trim().replaceAll(',', '.')) ??
        widget.value;
    final step = widget.decimalPlaces == 0 ? 1.0 : 0.1;
    final next = (current + step * direction).clamp(widget.min, widget.max);
    final normalized = widget.decimalPlaces == 0
        ? next.roundToDouble()
        : double.parse(next.toStringAsFixed(widget.decimalPlaces));
    widget.onChanged(normalized);
    controller.text = _formatValue(normalized);
    focusNode.unfocus();
  }

  String _formatValue(double value) {
    return widget.decimalPlaces == 0
        ? value.round().toString()
        : value.toStringAsFixed(widget.decimalPlaces);
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return SpringPressable(
      pressedScale: 0.90,
      child: CupertinoButton(
        minimumSize: const Size(32, 32),
        padding: EdgeInsets.zero,
        color: p.card,
        borderRadius: BorderRadius.circular(10),
        onPressed: onPressed,
        child: Icon(icon, color: p.accent, size: 17),
      ),
    );
  }
}

class _CaloriePanel extends StatelessWidget {
  const _CaloriePanel({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.color,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return GlassSurface(
      width: double.infinity,
      padding: padding,
      radius: 24,
      tint: color ?? p.card,
      opacity: color == null ? 0.88 : 0.72,
      borderColor: p.border.withValues(alpha: 0.60),
      child: child,
    );
  }
}

class _SaveStrip extends StatelessWidget {
  const _SaveStrip({required this.saved, required this.onSave});

  final bool saved;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return _CaloriePanel(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              saved
                  ? tx(context, 'Mentve a profilba.')
                  : tx(context, 'Mentés profilba · a Kalória cél frissítése'),
              style: TextStyle(
                color: p.muted,
                fontSize: 16,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SpringPressable(
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              color: saved ? p.noteColor : state.primaryActionSurface,
              borderRadius: BorderRadius.circular(14),
              onPressed: onSave,
              child: Text(
                saved ? tx(context, 'Mentve') : tx(context, 'Mentés'),
                style: TextStyle(
                  color: p.buttonText,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.active,
    required this.onTap,
    this.fullWidth = false,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final child = SpringPressable(
      pressedScale: 0.96,
      child: CupertinoButton(
        color: active ? state.primaryActionSurface : p.resultBg,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        borderRadius: BorderRadius.circular(9),
        onPressed: onTap,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? p.buttonText : p.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
    return fullWidth
        ? SizedBox(width: double.infinity, child: child)
        : Expanded(child: child);
  }
}
