import 'package:flutter/cupertino.dart';

import '../../app/app_layout.dart';
import '../../app/app_state.dart';
import '../../app/app_strings.dart';
import '../../utils/calculators.dart';
import '../../widgets/glass_surface.dart';

class BmiScreen extends StatelessWidget {
  const BmiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final weight = state.bmiWeight;
    final height = state.bmiHeight;
    final gender = state.bmiGender;
    final result = calculateBmi(
      weightKg: weight,
      heightCm: height,
      gender: gender,
    );
    final categoryColor = switch (result.category) {
      'Sovány' => const Color(0xFF4A9FE0),
      'Normál súly' => p.noteColor,
      'Túlsúlyos' => p.accent,
      _ => const Color(0xFFD04040),
    };

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        14,
        20,
        14,
        AppLayout.screenBottomPadding,
      ),
      children: [
        _BmiResultCard(result: result, categoryColor: categoryColor),
        const SizedBox(height: 12),
        _SliderCard(
          label: tx(context, 'Súly (kg)'),
          value: weight,
          min: 1,
          max: 200,
          display: weight.toStringAsFixed(1),
          decimalPlaces: 1,
          onChanged: state.updateBmiWeight,
        ),
        const SizedBox(height: 12),
        _SliderCard(
          label: tx(context, 'Magasság (cm)'),
          value: height,
          min: 10,
          max: 250,
          display: height.round().toString(),
          onChanged: state.updateBmiHeight,
        ),
        const SizedBox(height: 12),
        _GenderCard(gender: gender, onChanged: state.updateBmiGender),
        const SizedBox(height: 12),
        _SaveStrip(saved: state.bmiSaved, onSave: state.saveBmiToProfile),
        const SizedBox(height: 10),
        Text(
          tx(
            context,
            'A BMI csak tájékoztató. Nem veszi figyelembe az izomtömeget. Orvosi diagnózisra nem alkalmas.',
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: p.muted.withValues(alpha: 0.55),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _BmiResultCard extends StatelessWidget {
  const _BmiResultCard({required this.result, required this.categoryColor});

  final BmiResult result;
  final Color categoryColor;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return _BmiPanel(
      padding: const EdgeInsets.fromLTRB(26, 26, 26, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tx(context, 'TESTTÖMEG INDEX (BMI)'),
            style: TextStyle(
              color: p.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            result.value.toStringAsFixed(1),
            style: TextStyle(
              color: categoryColor,
              fontSize: 58,
              height: 0.95,
              fontWeight: FontWeight.w600,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_categoryPrefix(result.category)} ${txBmiCategory(context, result.category)}',
            style: TextStyle(
              color: categoryColor,
              fontSize: 23,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tx(context, _categoryDescription(result.category)),
            style: TextStyle(
              color: p.muted,
              fontSize: 17,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: _BmiBar(percent: result.needlePercent),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in ['Sovány', 'Normál', 'Túlsúly', 'Obezitás'])
                Text(
                  tx(context, label),
                  style: TextStyle(
                    color: p.muted.withValues(alpha: 0.68),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: p.bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: p.border.withValues(alpha: 0.62)),
            ),
            child: Row(
              children: [
                Text(
                  tx(context, 'Ideális testsúly'),
                  maxLines: 1,
                  style: TextStyle(
                    color: p.muted,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${result.idealMin.toStringAsFixed(1)} – ${result.idealMax.toStringAsFixed(1)} kg',
                        maxLines: 1,
                        style: TextStyle(
                          color: p.noteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _categoryPrefix(String category) {
    return switch (category) {
      'Normál súly' => '✓',
      'Túlsúlyos' => '!',
      _ => '⚠',
    };
  }

  String _categoryDescription(String category) {
    return switch (category) {
      'Sovány' => 'A BMI 18.5 alatt sovány tartomány.',
      'Normál súly' =>
        'A normál BMI tartomány 18.5–24.9. Egészséges testsúlyon vagy!',
      'Túlsúlyos' => 'A BMI 25–29.9 között túlsúly.',
      _ => 'A BMI 30 felett obezitás tartomány.',
    };
  }
}

class _BmiBar extends StatelessWidget {
  const _BmiBar({required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const thumbWidth = 7.0;
        final clampedPercent = percent.clamp(0, 100);
        final left =
            (constraints.maxWidth - thumbWidth) * (clampedPercent / 100);

        return SizedBox(
          height: 26,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 5,
                height: 14,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4A9FE0),
                          Color(0xFF4A9FE0),
                          Color(0xFF00C9A7),
                          Color(0xFF00C9A7),
                          Color(0xFFFF6B35),
                          Color(0xFFFF6B35),
                          Color(0xFFD04040),
                          Color(0xFFD04040),
                        ],
                        stops: [0, 0.25, 0.25, 0.58, 0.58, 0.78, 0.78, 1],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: left,
                top: 0,
                child: Container(
                  width: thumbWidth,
                  height: 26,
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x77000000),
                        blurRadius: 6,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
    final p = AppScope.of(context).palette;
    return _BmiPanel(
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
                    fontSize: 18,
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
                      fontSize: 26,
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
    return CupertinoButton(
      minimumSize: const Size(32, 32),
      padding: EdgeInsets.zero,
      color: p.bg.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(10),
      onPressed: onPressed,
      child: Icon(icon, color: p.accent, size: 17),
    );
  }
}

class _GenderCard extends StatelessWidget {
  const _GenderCard({required this.gender, required this.onChanged});

  final Gender gender;
  final ValueChanged<Gender> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return _BmiPanel(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tx(context, 'Nem'),
            style: TextStyle(
              color: p.muted,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _GenderButton(
                label: tx(context, 'Férfi'),
                active: gender == Gender.male,
                onTap: () => onChanged(Gender.male),
              ),
              const SizedBox(width: 12),
              _GenderButton(
                label: tx(context, 'Nő'),
                active: gender == Gender.female,
                onTap: () => onChanged(Gender.female),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SaveStrip extends StatelessWidget {
  const _SaveStrip({required this.saved, required this.onSave});

  final bool saved;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return _BmiPanel(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              saved
                  ? tx(context, 'Mentve a profilba.')
                  : tx(
                      context,
                      'Mentve a profilba · legközelebb automatikusan kitöltve',
                    ),
              style: TextStyle(
                color: p.muted,
                fontSize: 16,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            color: saved ? p.noteColor : p.accent,
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
        ],
      ),
    );
  }
}

class _BmiPanel extends StatelessWidget {
  const _BmiPanel({required this.child, required this.padding});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return GlassSurface(
      width: double.infinity,
      padding: padding,
      radius: 24,
      tint: p.card,
      opacity: 0.62,
      borderColor: p.text.withValues(alpha: 0.10),
      child: child,
    );
  }
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({
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
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: active ? p.accent : p.bg,
        borderRadius: BorderRadius.circular(12),
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(
            color: active ? p.buttonText : p.muted,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
