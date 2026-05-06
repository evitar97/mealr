import 'package:flutter/cupertino.dart';

import '../../app/app_state.dart';
import '../../app/app_strings.dart';
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
    final pages = const [_IntroPage(), _ProcessPage(), _ToolsPage()];
    final isLast = page == pages.length - 1;

    return Positioned.fill(
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
                padding: EdgeInsets.fromLTRB(24, 10, 24, bottomInset + 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PageDots(count: pages.length, active: page),
                    const SizedBox(height: 14),
                    if (isLast)
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CupertinoButton(
                              color: p.accent,
                              borderRadius: BorderRadius.circular(22),
                              padding: const EdgeInsets.symmetric(
                                vertical: 13,
                                horizontal: 10,
                              ),
                              onPressed: () {
                                showProPaywallSheet(context);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      tx(context, 'Próbáld ki ingyen 7 napig'),
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: p.buttonText,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    tx(
                                      context,
                                      'Éves csomag −50% kedvezménnyel',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: p.buttonText.withValues(
                                        alpha: 0.82,
                                      ),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CupertinoButton(
                              color: p.card,
                              borderRadius: BorderRadius.circular(22),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              onPressed: state.finishOnboarding,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  tx(context, 'Kihagyás'),
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: p.muted,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          color: p.accent,
                          borderRadius: BorderRadius.circular(26),
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          onPressed: () => controller.nextPage(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                          ),
                          child: Text(
                            tx(context, 'Tovább'),
                            style: TextStyle(
                              color: p.buttonText,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
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
          'Mealr',
          style: TextStyle(
            color: p.text,
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          tx(context, 'Nyers súly kalkulátor'),
          style: TextStyle(
            color: p.muted,
            fontSize: 17,
            fontWeight: FontWeight.w600,
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
            'A Mealr azért kell, hogy ne kelljen fejben számolgatnod, amikor főzés után kevesebb vagy több lesz az étel tömege. Beírod a nyers, kész és kimért súlyt, az app pedig megmondja, mennyi nyers alapanyagnak felel meg az adag.',
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
                  'ha a dobozodba 250 g kerül, a Mealr kiszámolja, hogy ez kb. 313 g nyers alapanyagnak felel meg.',
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
            'Ha csak rizst, bulgurt vagy tésztát főzöl köretnek, ugyanígy működik: nyers rizs 300 g, kész rizs 820 g, kimért adag 180 g. Az app megadja a nyers rizs egyenértékét.',
          ),
        ),
      ],
    );
  }
}

class _ToolsPage extends StatelessWidget {
  const _ToolsPage();

  @override
  Widget build(BuildContext context) {
    return _OnboardPage(
      children: [
        _HeroCard(
          eyebrow: tx(context, 'MINDEN EGYBEN'),
          title: tx(
            context,
            'Nem csak mérlegelés: egy app a kajás rutinodhoz.',
          ),
          text: tx(
            context,
            'A Mealr egy helyre gyűjti a főzéshez, adagoláshoz és célkövetéshez hasznos eszközöket, hogy ne több app között kelljen ugrálnod.',
          ),
          icon: CupertinoIcons.square_grid_2x2,
        ),
        const SizedBox(height: 16),
        _FeatureGrid(
          features: [
            _FeatureInfo(
              CupertinoIcons.flame_fill,
              tx(context, 'Kalória kalkulátor'),
            ),
            _FeatureInfo(CupertinoIcons.heart_fill, tx(context, 'BMI')),
            _FeatureInfo(
              CupertinoIcons.cart_fill,
              tx(context, 'Bevásárlás lista'),
            ),
            _FeatureInfo(
              CupertinoIcons.chart_bar_fill,
              tx(context, 'Súly követés'),
            ),
            _FeatureInfo(
              CupertinoIcons.archivebox_fill,
              tx(context, 'Meal preppelés'),
            ),
          ],
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
            style: TextStyle(
              color: p.text,
              fontSize: 25,
              height: 1.14,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            text,
            style: TextStyle(
              color: p.muted,
              fontSize: 17,
              height: 1.48,
              fontWeight: FontWeight.w600,
            ),
          ),
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

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.features});

  final List<_FeatureInfo> features;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final feature in features)
          SizedBox(
            width: (MediaQuery.sizeOf(context).width - 58) / 2,
            child: _ToolTile(feature: feature),
          ),
      ],
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({required this.feature});

  final _FeatureInfo feature;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return _OnboardCard(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Icon(feature.icon, color: p.accent, size: 21),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              feature.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: p.text,
                fontSize: 15,
                height: 1.18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureInfo {
  const _FeatureInfo(this.icon, this.title);

  final IconData icon;
  final String title;
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
