import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../app/app_state.dart';
import '../../app/app_strings.dart';
import '../../theme/app_typography.dart';
import '../../utils/app_haptics.dart';
import '../../utils/calculators.dart';
import '../food/food_list_screen.dart';
import '../../widgets/glass_surface.dart';
import '../../widgets/mealweight_mark.dart';

class OnboardingOverlay extends StatefulWidget {
  const OnboardingOverlay({super.key});

  @override
  State<OnboardingOverlay> createState() => _OnboardingOverlayState();
}

class _OnboardingOverlayState extends State<OnboardingOverlay> {
  final controller = PageController();
  int page = 0;
  bool showEntryGate = true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final pages = const [
      _WelcomePage(),
      _IntroPage(),
      _ProcessPage(),
      _ProfileSetupPage(),
    ];
    final isLast = page == pages.length - 1;

    return Positioned.fill(
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
                    Color.alphaBlend(p.accent.withValues(alpha: 0.06), p.bg),
                    p.bg,
                  ],
                ),
              ),
              child: SafeArea(
                top: true,
                bottom: false,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const _Header(),
                    const SizedBox(height: 14),
                    Expanded(
                      child: PageView(
                        controller: controller,
                        onPageChanged: (value) => setState(() => page = value),
                        children: pages,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        10,
                        24,
                        bottomInset + 10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _PageDots(count: pages.length, active: page),
                          const SizedBox(height: 14),
                          _OnboardingActions(
                            isLast: isLast,
                            onNext: () => controller.nextPage(
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeOutCubic,
                            ),
                            onTryPro: () => showProPaywallSheet(context),
                            onStartFree: state.finishOnboarding,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showEntryGate)
            _OnboardingEntryGate(
              onStart: () => setState(() => showEntryGate = false),
            ),
        ],
      ),
    );
  }
}

class _OnboardingEntryGate extends StatelessWidget {
  const _OnboardingEntryGate({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return Positioned.fill(
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: ColoredBox(
            color: p.bg.withValues(alpha: state.isDark ? 0.64 : 0.52),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const MealWeightMark(size: 112, radius: 30),
                    const SizedBox(height: 18),
                    Text(
                      'Mealful',
                      style: MealText.largeTitle(
                        p.text,
                      ).copyWith(fontSize: 34, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 224,
                      child: CupertinoButton(
                        color: p.accent,
                        borderRadius: BorderRadius.circular(24),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        onPressed: withAppActionHaptic(onStart),
                        child: Text(
                          tx(context, 'Indulhat'),
                          style: MealText.button(p.buttonText),
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

class _OnboardingActions extends StatelessWidget {
  const _OnboardingActions({
    required this.isLast,
    required this.onNext,
    required this.onTryPro,
    required this.onStartFree,
  });

  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onTryPro;
  final VoidCallback onStartFree;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    if (!isLast) {
      return SizedBox(
        width: double.infinity,
        child: CupertinoButton(
          color: p.accent,
          borderRadius: BorderRadius.circular(24),
          padding: const EdgeInsets.symmetric(vertical: 15),
          onPressed: withAppActionHaptic(onNext),
          child: Text(
            tx(context, 'Tovább'),
            style: MealText.button(p.buttonText),
          ),
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: CupertinoButton(
            color: p.accent,
            borderRadius: BorderRadius.circular(22),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            onPressed: withAppActionHaptic(onTryPro),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tx(context, 'Próbáld ki ingyen 7 napig'),
                  maxLines: 1,
                  style: MealText.button(p.buttonText),
                ),
                const SizedBox(height: 2),
                Text(
                  tx(context, 'Éves csomag −50% kedvezménnyel'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: MealText.captionStrong(
                    p.buttonText.withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: CupertinoButton(
            color: p.card,
            borderRadius: BorderRadius.circular(22),
            padding: const EdgeInsets.symmetric(vertical: 14),
            onPressed: withAppActionHaptic(onStartFree),
            child: Text(
              tx(context, 'Kezdés ingyenesen'),
              style: MealText.button(p.accent),
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Column(
      children: [
        const MealWeightMark(size: 64, radius: 20),
        const SizedBox(height: 14),
        Text(
          'Mealful',
          style: MealText.largeTitle(
            p.text,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Text(
          tx(context, 'Tervezz, főzz, kövess okosabban'),
          style: MealText.cardTitle(p.muted),
        ),
      ],
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    return _OnboardPage(
      children: [
        _HeroCard(
          eyebrow: tx(context, 'ÜDV A MEALFUL-BEN'),
          title: tx(context, 'Kezdjük egyszerűen.'),
          text: tx(
            context,
            'A Mealful abban segít, hogy főzés, adagolás és meal prep közben ne kelljen fejben számolgatnod. Pár rövid lépésben megmutatjuk, hogyan hozd ki belőle a legtöbbet.',
          ),
          icon: CupertinoIcons.sparkles,
        ),
        const SizedBox(height: 16),
        _InfoStrip(
          icon: CupertinoIcons.heart_fill,
          text: tx(
            context,
            'Nyugodt, praktikus eszköz a pontosabb étkezési rutinhoz.',
          ),
        ),
      ],
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage();

  @override
  Widget build(BuildContext context) {
    return _OnboardPage(
      children: [
        _HeroCard(
          eyebrow: tx(context, 'MIÉRT HASZNOS?'),
          title: tx(context, 'A főtt étel súlya változik, a kalória nem.'),
          text: tx(
            context,
            'A Mealful azért kell, hogy ne kelljen fejben számolgatnod, amikor főzés után kevesebb vagy több lesz az étel tömege. Beírod a nyers, kész és kimért súlyt, az app pedig megmondja, mennyi nyers alapanyagnak felel meg az adag.',
          ),
          icon: CupertinoIcons.chart_bar_fill,
        ),
        const SizedBox(height: 16),
        _InfoStrip(
          icon: CupertinoIcons.check_mark_circled_solid,
          text: tx(
            context,
            'Így pontosabban tudod vezetni a kalóriákat, és a meal prep adagolás sem lesz találgatás.',
          ),
        ),
      ],
    );
  }
}

class _ProcessPage extends StatelessWidget {
  const _ProcessPage();

  @override
  Widget build(BuildContext context) {
    return _OnboardPage(
      children: [
        _OnboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(tx(context, 'HOGYAN HASZNÁLD?')),
              const SizedBox(height: 18),
              _Step(
                number: '1',
                title: tx(context, 'Nyers adag'),
                text: tx(
                  context,
                  'mérd le főzés előtt az alapanyagokat, például csirke + rizs + zöldség összesen 950 g.',
                ),
              ),
              _Step(
                number: '2',
                title: tx(context, 'Kész étel'),
                text: tx(
                  context,
                  'főzés után mérd le az egész elkészült ételt, például 760 g.',
                ),
              ),
              _Step(
                number: '3',
                title: tx(context, 'Kimért adag'),
                text: tx(
                  context,
                  'ha a dobozodba 250 g kerül, a Mealful kiszámolja, hogy ez kb. 313 g nyers alapanyagnak felel meg.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _ExampleCard(
          title: tx(context, 'Köret külön vezetve'),
          text: tx(
            context,
            'Külön köretnél is ugyanígy működik: ha a nyers alapanyag főzés közben vizet vesz fel, a kész tömeg több lehet, de ettől nem lesz több benne a kalória. A Mealful ilyenkor is a nyers egyenértéket számolja ki.',
          ),
        ),
      ],
    );
  }
}

class _ProfileSetupPage extends StatelessWidget {
  const _ProfileSetupPage();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return _OnboardPage(
      children: [
        _HeroCard(
          eyebrow: tx(context, 'SZEMÉLYES ALAPOK'),
          title: tx(context, 'Add meg az alapadataidat.'),
          text: tx(
            context,
            'A kitöltött adatok azonnal bekerülnek a BMI kalkulátorba, a Kalória menübe és a Profilba is, így nem kell később újra megadnod őket.',
          ),
          icon: CupertinoIcons.person_crop_circle_fill,
        ),
        const SizedBox(height: 16),
        _OnboardCard(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            children: [
              _OnboardNumberInput(
                label: tx(context, 'Életkor'),
                value: state.calorieAge.toDouble(),
                min: 12,
                max: 90,
                suffix: tx(context, 'év'),
                decimalPlaces: 0,
                onChanged: (value) =>
                    state.applyOnboardingProfile(age: value.round()),
              ),
              const SizedBox(height: 10),
              _OnboardNumberInput(
                label: tx(context, 'Súly'),
                value: state.profileWeight,
                min: 1,
                max: 300,
                suffix: 'kg',
                decimalPlaces: 1,
                onChanged: (value) =>
                    state.applyOnboardingProfile(weight: value),
              ),
              const SizedBox(height: 10),
              _OnboardNumberInput(
                label: tx(context, 'Magasság'),
                value: state.profileHeight,
                min: 80,
                max: 230,
                suffix: 'cm',
                decimalPlaces: 0,
                onChanged: (value) =>
                    state.applyOnboardingProfile(height: value),
              ),
              const SizedBox(height: 12),
              _GenderPicker(
                selected: state.calorieGender,
                onChanged: (gender) =>
                    state.applyOnboardingProfile(gender: gender),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _InfoStrip(
          icon: CupertinoIcons.check_mark_circled_solid,
          text: tx(
            context,
            'Ezekből számolja az app a BMI értéket, a napi kalória célt és a profil alapadatait.',
          ),
        ),
      ],
    );
  }
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
      children: children,
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.eyebrow,
    required this.title,
    required this.text,
    required this.icon,
  });

  final String eyebrow;
  final String title;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return _OnboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: p.accent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: p.buttonText, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(child: _SectionTitle(eyebrow)),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: MealText.largeTitle(
              p.text,
            ).copyWith(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          Text(text, style: MealText.cardTitle(p.muted).copyWith(height: 1.44)),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return GlassSurface(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      radius: 22,
      tint: p.noteBg,
      opacity: 0.62,
      borderColor: p.noteColor.withValues(alpha: 0.38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.lightbulb_fill, color: p.noteColor, size: 20),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: p.noteColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              color: p.noteColor,
              fontSize: 16,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoStrip extends StatelessWidget {
  const _InfoStrip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return GlassSurface(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      radius: 22,
      tint: p.resultBg,
      opacity: 0.62,
      borderColor: p.resultBorder.withValues(alpha: 0.55),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: p.accent, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: p.accent,
                fontSize: 16,
                height: 1.42,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardNumberInput extends StatefulWidget {
  const _OnboardNumberInput({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.decimalPlaces,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final String suffix;
  final int decimalPlaces;
  final ValueChanged<double> onChanged;

  @override
  State<_OnboardNumberInput> createState() => _OnboardNumberInputState();
}

class _OnboardNumberInputState extends State<_OnboardNumberInput> {
  late final TextEditingController controller;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: _formatValue(widget.value));
    focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _OnboardNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!focusNode.hasFocus && oldWidget.value != widget.value) {
      controller.text = _formatValue(widget.value);
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: p.bg.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: p.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.label,
              style: TextStyle(
                color: p.text,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _OnboardStepperButton(
            icon: CupertinoIcons.minus,
            onPressed: () => _stepValue(-1),
          ),
          SizedBox(
            width: 72,
            child: CupertinoTextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.numberWithOptions(
                decimal: widget.decimalPlaces > 0,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
              ],
              textAlign: TextAlign.center,
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: const BoxDecoration(),
              style: TextStyle(
                color: p.accent,
                fontFamily: MealText.family,
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
              onTap: () => controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.text.length,
              ),
              onChanged: _updateLiveValue,
              onSubmitted: (_) => _commitManualValue(),
              onEditingComplete: _commitManualValue,
            ),
          ),
          _OnboardStepperButton(
            icon: CupertinoIcons.plus,
            onPressed: () => _stepValue(1),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 28,
            child: Text(widget.suffix, style: MealText.callout(p.muted)),
          ),
        ],
      ),
    );
  }

  void _commitManualValue() {
    final parsed = double.tryParse(controller.text.trim().replaceAll(',', '.'));
    if (parsed == null) {
      controller.text = _formatValue(widget.value);
      focusNode.unfocus();
      return;
    }
    final normalized = _normalize(parsed);
    widget.onChanged(normalized);
    controller.text = _formatValue(normalized);
    focusNode.unfocus();
  }

  void _updateLiveValue(String value) {
    final parsed = double.tryParse(value.trim().replaceAll(',', '.'));
    if (parsed == null) return;
    widget.onChanged(_normalize(parsed));
  }

  void _stepValue(int direction) {
    final current =
        double.tryParse(controller.text.trim().replaceAll(',', '.')) ??
        widget.value;
    final step = widget.decimalPlaces == 0 ? 1.0 : 0.1;
    final next = _normalize(current + step * direction);
    widget.onChanged(next);
    controller.text = _formatValue(next);
    focusNode.unfocus();
  }

  double _normalize(double value) {
    final clamped = value.clamp(widget.min, widget.max).toDouble();
    return widget.decimalPlaces == 0
        ? clamped.roundToDouble()
        : double.parse(clamped.toStringAsFixed(widget.decimalPlaces));
  }

  String _formatValue(double value) => widget.decimalPlaces == 0
      ? value.round().toString()
      : value.toStringAsFixed(widget.decimalPlaces);
}

class _OnboardStepperButton extends StatelessWidget {
  const _OnboardStepperButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoButton(
      minimumSize: const Size(34, 34),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(12),
      onPressed: withAppActionHaptic(onPressed),
      child: Icon(icon, color: p.accent, size: 19),
    );
  }
}

class _GenderPicker extends StatelessWidget {
  const _GenderPicker({required this.selected, required this.onChanged});

  final Gender selected;
  final ValueChanged<Gender> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: p.bg.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: p.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _GenderOption(
              label: tx(context, 'Férfi'),
              active: selected == Gender.male,
              onTap: () => onChanged(Gender.male),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _GenderOption(
              label: tx(context, 'Nő'),
              active: selected == Gender.female,
              onTap: () => onChanged(Gender.female),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
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
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 11),
      color: active ? p.accent : CupertinoColors.transparent,
      borderRadius: BorderRadius.circular(14),
      onPressed: withAppActionHaptic(onTap),
      child: Text(
        label,
        style: TextStyle(
          color: active ? p.buttonText : p.muted,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _OnboardCard extends StatelessWidget {
  const _OnboardCard({
    required this.child,
    this.padding = const EdgeInsets.all(22),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return GlassSurface(
      width: double.infinity,
      padding: padding,
      radius: 26,
      tint: p.card,
      opacity: 0.64,
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Text(
      text,
      style: TextStyle(
        color: p.accent,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.4,
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.title, required this.text});

  final String number;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: p.accent, shape: BoxShape.circle),
            child: Text(
              number,
              style: TextStyle(
                color: p.buttonText,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: p.muted,
                  fontFamily: MealText.family,
                  fontSize: 16,
                  height: 1.43,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: TextStyle(
                      color: p.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == active ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == active ? p.accent : p.border,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
      ],
    );
  }
}
