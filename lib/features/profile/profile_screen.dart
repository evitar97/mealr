import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

import '../../app/app_layout.dart';
import '../../app/app_state.dart';
import '../../app/app_strings.dart';
import '../../models/theme_option.dart';
import '../../models/weight_entry.dart';
import '../../theme/app_typography.dart';
import '../../utils/app_haptics.dart';
import '../../utils/calculators.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_components.dart';
import '../../widgets/app_sheet.dart';
import '../../widgets/mealweight_mark.dart';
import '../../widgets/theme_picker_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        AppLayout.screenBottomPadding,
      ),
      children: [
        SectionLabel(tx(context, 'Súlykövetés')),
        const _WeightTrackerCard(),
        SectionLabel(tx(context, 'Személyes adatok')),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _ProfileRow(
                icon: CupertinoIcons.person,
                title: tx(context, 'Súly'),
                value: '${state.profileWeight.toStringAsFixed(1)} kg',
              ),
              _ProfileRow(
                icon: CupertinoIcons.resize_v,
                title: tx(context, 'Magasság'),
                value: '${state.profileHeight.round()} cm',
              ),
              _ProfileRow(
                icon: CupertinoIcons.flame,
                title: tx(context, 'Kalória cél'),
                subtitle: tx(context, 'Kalkulátorból beállítva'),
                value: '${_formatWhole(state.profileCalorieTarget)} kcal',
              ),
            ],
          ),
        ),
        SectionLabel(tx(context, 'Beállítások')),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _ProfileRow(
                icon: CupertinoIcons.gear_alt,
                title: tx(context, 'Beállítások'),
                subtitle: tx(context, 'Nyelv, téma, mód és verzió'),
                onTap: () => _showSettingsSheet(context),
              ),
            ],
          ),
        ),
        SectionLabel(tx(context, 'Előfizetés')),
        AppCard(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          child: Column(
            children: [
              _SubscriptionStatus(
                isPro: state.isPro,
                planLabel: state.isPro ? 'Mealr Pro' : tx(context, 'Ingyenes'),
                expiryLabel: _subscriptionExpiryLabel(context, state),
              ),
              const SizedBox(height: 10),
              _ToggleRow(
                icon: CupertinoIcons.lock_open,
                title: tx(context, 'Pro mód teszt'),
                value: state.isPro,
                onChanged: state.setProMode,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0x99000000),
      builder: (context) => const _SettingsSheet(),
    );
  }
}

String _formatWhole(num value) => value.round().toString().replaceAllMapped(
  RegExp(r'\B(?=(\d{3})+(?!\d))'),
  (_) => ' ',
);

String _formatEntryDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${date.year}. $month. $day. $hour:$minute';
}

class _SubscriptionStatus extends StatelessWidget {
  const _SubscriptionStatus({
    required this.isPro,
    required this.planLabel,
    required this.expiryLabel,
  });

  final bool isPro;
  final String planLabel;
  final String expiryLabel;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final softBorder = p.border.withValues(alpha: state.isDark ? 0.58 : 0.34);
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isPro ? p.accent : p.bg,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isPro ? p.accent.withValues(alpha: 0.72) : softBorder,
            ),
          ),
          child: isPro
              ? const MealWeightMark(size: 46, radius: 15)
              : Icon(CupertinoIcons.lock, color: p.muted, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(planLabel, style: MealText.cardTitle(p.text)),
              const SizedBox(height: 2),
              Text(
                isPro
                    ? '${tx(context, 'Aktív előfizetés · ')}$expiryLabel'
                    : '$expiryLabel${tx(context, ' Pro extrák lezárva')}',
                style: MealText.callout(
                  p.muted,
                ).copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isPro ? p.resultBg : p.bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isPro
                  ? p.resultBorder.withValues(alpha: 0.58)
                  : softBorder,
            ),
          ),
          child: Text(
            isPro ? 'PRO' : 'FREE',
            style: MealText.captionStrong(
              isPro ? p.accent : p.muted,
            ).copyWith(letterSpacing: 0.6),
          ),
        ),
      ],
    );
  }
}

class _WeightTrackerCard extends StatefulWidget {
  const _WeightTrackerCard();

  @override
  State<_WeightTrackerCard> createState() => _WeightTrackerCardState();
}

class _WeightTrackerCardState extends State<_WeightTrackerCard> {
  bool expandedHistory = false;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final entries = state.weightEntriesForRange(state.weightChartRange);
    final stats = state.weightStats;
    final history = state.weightEntries.reversed.take(expandedHistory ? 8 : 3);
    final canExpand = state.weightEntries.length > 3;
    final rangeChange = switch (state.weightChartRange) {
      WeightChartRange.days7 => stats?.sevenDayChange,
      WeightChartRange.days30 => stats?.thirtyDayChange,
      WeightChartRange.days60 => stats?.totalChange,
    };
    final bmi = calculateBmi(
      weightKg: state.profileWeight,
      heightCm: state.profileHeight,
      gender: state.bmiGender,
    );
    final guidanceTarget = state.profileWeight > bmi.idealMax
        ? bmi.idealMax
        : state.profileWeight < bmi.idealMin
        ? bmi.idealMin
        : null;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tx(context, 'Súly progresszió').toUpperCase(),
            style: MealText.section(p.muted),
          ),
          const SizedBox(height: 9),
          Text(
            _weightProgressHeadline(context, rangeChange),
            style: MealText.title(p.text).copyWith(fontSize: 22),
          ),
          const SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                state.profileWeight.toStringAsFixed(1),
                style: MealText.largeTitle(
                  p.text,
                ).copyWith(fontSize: 31, height: 0.98),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, bottom: 3),
                child: Text('kg', style: MealText.cardTitle(p.muted)),
              ),
              const Spacer(),
              if (rangeChange != null)
                _WeightChangeSummary(
                  days: state.weightChartRange.days,
                  change: rangeChange,
                ),
            ],
          ),
          const SizedBox(height: 18),
          _WeightRangeSelector(selected: state.weightChartRange),
          const SizedBox(height: 16),
          SizedBox(
            height: 194,
            width: double.infinity,
            child: _InteractiveWeightChart(
              entries: entries,
              palette: p,
              days: state.weightChartRange.days,
              targetWeight: guidanceTarget,
            ),
          ),
          const SizedBox(height: 16),
          if (state.isPro && stats != null) ...[
            _WeightInsights(stats: stats, entries: state.weightEntries.length),
            const SizedBox(height: 22),
          ],
          _WeightInputRow(
            value: state.weightTrackerInput,
            onChanged: state.updateWeightTrackerInput,
            onAdd: state.addWeightEntry,
          ),
          if (state.weightEntries.isNotEmpty) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    tx(context, 'Rögzített súlyok'),
                    style: TextStyle(
                      color: p.muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                CupertinoButton(
                  minimumSize: const Size(32, 32),
                  padding: EdgeInsets.zero,
                  color: p.bg,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: () => _showResetConfirmation(context),
                  child: Icon(
                    CupertinoIcons.arrow_counterclockwise,
                    color: p.muted,
                    size: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final entry in history) _WeightHistoryRow(entry: entry),
            if (canExpand)
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  color: p.bg,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () =>
                      setState(() => expandedHistory = !expandedHistory),
                  child: Text(
                    expandedHistory
                        ? tx(context, 'Kevesebb mutatása')
                        : tx(context, 'További rögzítések'),
                    style: TextStyle(
                      color: p.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) {
        final state = AppScope.of(context);
        return CupertinoAlertDialog(
          title: Text(tx(context, 'Progresszió törlése')),
          content: Text(
            tx(context, 'Biztosan törlöd az összes rögzített súlyt?'),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(tx(context, 'Mégse')),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                state.resetWeightProgress();
                Navigator.pop(dialogContext);
              },
              child: Text(tx(context, 'Törlés')),
            ),
          ],
        );
      },
    );
  }
}

String _weightProgressHeadline(BuildContext context, double? change) {
  if (change == null) return tx(context, 'A jelenlegi súlyod');
  if (change.abs() < 0.05) return tx(context, 'Stabil ezen az időszakon');
  return change < 0
      ? tx(context, 'Csökkenő trend ebben az időszakban')
      : tx(context, 'Emelkedő trend ebben az időszakban');
}

class _WeightChangeSummary extends StatelessWidget {
  const _WeightChangeSummary({required this.days, required this.change});

  final int days;
  final double change;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    final rising = change > 0;
    final icon = change == 0
        ? CupertinoIcons.minus
        : rising
        ? CupertinoIcons.arrow_up_right
        : CupertinoIcons.arrow_down_right;
    final formatted = '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} kg';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: p.accent, size: 14),
            const SizedBox(width: 4),
            Text(formatted, style: MealText.bodyStrong(p.accent)),
          ],
        ),
        const SizedBox(height: 2),
        Text('$days ${tx(context, 'nap')}', style: MealText.caption(p.muted)),
      ],
    );
  }
}

class _WeightInsights extends StatelessWidget {
  const _WeightInsights({required this.stats, required this.entries});

  final WeightStats stats;
  final int entries;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _WeightInsightHero(
                label: tx(context, 'Összes'),
                value: _formatWeightChange(stats.totalChange),
              ),
            ),
            Container(
              height: 40,
              width: 1,
              margin: const EdgeInsets.symmetric(horizontal: 13),
              color: p.border.withValues(alpha: 0.46),
            ),
            Expanded(
              child: _WeightInsightHero(
                label: tx(context, 'Heti átlag'),
                value:
                    '${_formatWeightChange(stats.weeklyAverage)}/${tx(context, 'hét')}',
              ),
            ),
            Container(
              height: 40,
              width: 1,
              margin: const EdgeInsets.symmetric(horizontal: 13),
              color: p.border.withValues(alpha: 0.46),
            ),
            Expanded(
              child: _WeightInsightHero(
                label: tx(context, 'Mérések'),
                value: entries.toString(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatWeightChange(double value) {
    if (value == 0) return '0.0 kg';
    return '${value > 0 ? '+' : ''}${value.toStringAsFixed(1)} kg';
  }
}

class _WeightInsightHero extends StatelessWidget {
  const _WeightInsightHero({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            maxLines: 1,
            style: MealText.title(p.text).copyWith(fontSize: 22),
          ),
        ),
        const SizedBox(height: 3),
        Text(label, style: MealText.caption(p.muted)),
      ],
    );
  }
}

class _WeightRangeSelector extends StatelessWidget {
  const _WeightRangeSelector({required this.selected});

  final WeightChartRange selected;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: p.bg.withValues(alpha: 0.56),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                _RangeButton(range: WeightChartRange.days7, selected: selected),
                _RangeButton(
                  range: WeightChartRange.days30,
                  selected: selected,
                  locked: !state.isPro,
                ),
                _RangeButton(
                  range: WeightChartRange.days60,
                  selected: selected,
                  locked: !state.isPro,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RangeButton extends StatelessWidget {
  const _RangeButton({
    required this.range,
    required this.selected,
    this.locked = false,
  });

  final WeightChartRange range;
  final WeightChartRange selected;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final active = selected == range;
    return Expanded(
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 9),
        color: active ? p.card : CupertinoColors.transparent,
        borderRadius: BorderRadius.circular(10),
        onPressed: withAppActionHaptic(
          () => state.selectWeightChartRange(range),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (locked) ...[
              Icon(CupertinoIcons.lock, color: p.muted, size: 13),
              const SizedBox(width: 5),
            ],
            Text(
              '${range.days} ${tx(context, 'nap')}',
              style: TextStyle(
                color: active ? p.accent : p.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeightInputRow extends StatefulWidget {
  const _WeightInputRow({
    required this.value,
    required this.onChanged,
    required this.onAdd,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final VoidCallback onAdd;

  @override
  State<_WeightInputRow> createState() => _WeightInputRowState();
}

class _WeightInputRowState extends State<_WeightInputRow> {
  late final TextEditingController controller;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value.toStringAsFixed(1));
    focusNode.addListener(() {
      if (!focusNode.hasFocus) _commit();
    });
  }

  @override
  void didUpdateWidget(covariant _WeightInputRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !focusNode.hasFocus) {
      controller.text = widget.value.toStringAsFixed(1);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tx(context, 'Új mérés').toUpperCase(),
          style: MealText.section(p.muted),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  color: p.bg.withValues(alpha: 0.58),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _WeightStepButton(
                      icon: CupertinoIcons.minus,
                      onPressed: () => _step(-0.1),
                    ),
                    Expanded(
                      child: CupertinoTextField(
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.center,
                        padding: EdgeInsets.zero,
                        decoration: const BoxDecoration(),
                        onTap: () => controller.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: controller.text.length,
                        ),
                        onChanged: (value) {
                          final parsed = _parse(value);
                          if (parsed != null) widget.onChanged(parsed);
                        },
                        onSubmitted: (_) {
                          _commit();
                          focusNode.unfocus();
                        },
                        style: MealText.title(p.text).copyWith(fontSize: 21),
                      ),
                    ),
                    Text('kg', style: MealText.callout(p.muted)),
                    const SizedBox(width: 4),
                    _WeightStepButton(
                      icon: CupertinoIcons.plus,
                      onPressed: () => _step(0.1),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 9),
            SizedBox(
              height: 50,
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                color: AppScope.of(context).primaryActionSurface,
                borderRadius: BorderRadius.circular(14),
                onPressed: withAppActionHaptic(() {
                  _commit();
                  widget.onAdd();
                  focusNode.unfocus();
                }),
                child: Text(
                  tx(context, 'Rögzítés'),
                  style: MealText.bodyStrong(p.buttonText),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  double? _parse(String value) {
    final parsed = double.tryParse(value.trim().replaceAll(',', '.'));
    if (parsed == null) return null;
    return parsed.clamp(1, 300).toDouble();
  }

  void _commit() {
    final parsed = _parse(controller.text);
    if (parsed == null) return;
    final next = double.parse(parsed.toStringAsFixed(1));
    widget.onChanged(next);
    controller.text = next.toStringAsFixed(1);
  }

  void _step(double amount) {
    _commit();
    final current = _parse(controller.text) ?? widget.value;
    final next = (current + amount).clamp(1, 300).toDouble();
    final normalized = double.parse(next.toStringAsFixed(1));
    widget.onChanged(normalized);
    controller.text = normalized.toStringAsFixed(1);
    focusNode.unfocus();
  }
}

class _WeightStepButton extends StatelessWidget {
  const _WeightStepButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoButton(
      minimumSize: const Size(34, 34),
      padding: EdgeInsets.zero,
      color: p.card.withValues(alpha: 0.62),
      borderRadius: BorderRadius.circular(11),
      onPressed: withAppActionHaptic(onPressed),
      child: Icon(icon, color: p.accent, size: 17),
    );
  }
}

class _WeightHistoryRow extends StatelessWidget {
  const _WeightHistoryRow({required this.entry});

  final WeightEntry entry;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.border),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.calendar, color: p.muted, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _formatEntryDate(entry.recordedAt),
              style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '${entry.weight.toStringAsFixed(1)} kg',
            style: TextStyle(color: p.text, fontWeight: FontWeight.w600),
          ),
          if (state.isPro) ...[
            const SizedBox(width: 8),
            _HistoryIconButton(
              icon: CupertinoIcons.pencil,
              color: p.accent,
              onPressed: () => showCupertinoModalPopup<void>(
                context: context,
                barrierDismissible: true,
                barrierColor: const Color(0x99000000),
                builder: (_) => _EditWeightEntrySheet(entry: entry),
              ),
            ),
            const SizedBox(width: 5),
            _HistoryIconButton(
              icon: CupertinoIcons.trash,
              color: const Color(0xFFC04040),
              onPressed: () => state.deleteWeightEntry(entry.id),
            ),
          ],
        ],
      ),
    );
  }
}

class _HistoryIconButton extends StatelessWidget {
  const _HistoryIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoButton(
      minimumSize: const Size(30, 30),
      padding: EdgeInsets.zero,
      color: p.card,
      borderRadius: BorderRadius.circular(9),
      onPressed: onPressed,
      child: Icon(icon, color: color, size: 15),
    );
  }
}

class _EditWeightEntrySheet extends StatefulWidget {
  const _EditWeightEntrySheet({required this.entry});

  final WeightEntry entry;

  @override
  State<_EditWeightEntrySheet> createState() => _EditWeightEntrySheetState();
}

class _EditWeightEntrySheetState extends State<_EditWeightEntrySheet> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.entry.weight.toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return AppSheetFrame(
      scrollable: false,
      avoidKeyboard: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetHeader(
            icon: CupertinoIcons.pencil,
            title: tx(context, 'Súly szerkesztése'),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: p.bg.withValues(alpha: 0.62),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: p.border),
            ),
            child: Row(
              children: [
                _WeightStepButton(
                  icon: CupertinoIcons.minus,
                  onPressed: () => _step(-0.1),
                ),
                Expanded(
                  child: CupertinoTextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    padding: EdgeInsets.zero,
                    decoration: const BoxDecoration(),
                    style: TextStyle(
                      color: p.accent,
                      fontSize: 21,
                      height: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  'kg',
                  style: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 6),
                _WeightStepButton(
                  icon: CupertinoIcons.plus,
                  onPressed: () => _step(0.1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  color: p.deleteBg,
                  borderRadius: BorderRadius.circular(14),
                  onPressed: withAppActionHaptic(() {
                    state.deleteWeightEntry(widget.entry.id);
                    Navigator.pop(context);
                  }),
                  child: Text(
                    tx(context, 'Törlés'),
                    style: const TextStyle(
                      color: Color(0xFFC04040),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: CupertinoButton(
                  color: p.accent,
                  borderRadius: BorderRadius.circular(14),
                  onPressed: withAppActionHaptic(() {
                    final next = _currentValue();
                    if (next == null) return;
                    state.updateWeightEntry(widget.entry.id, next);
                    Navigator.pop(context);
                  }),
                  child: Text(
                    tx(context, 'Mentés'),
                    style: TextStyle(
                      color: p.buttonText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double? _currentValue() {
    final parsed = double.tryParse(controller.text.trim().replaceAll(',', '.'));
    if (parsed == null) return null;
    return parsed.clamp(1, 300).toDouble();
  }

  void _step(double amount) {
    final current = _currentValue() ?? widget.entry.weight;
    final next = (current + amount).clamp(1, 300).toDouble();
    controller.text = next.toStringAsFixed(1);
  }
}

class _InteractiveWeightChart extends StatefulWidget {
  const _InteractiveWeightChart({
    required this.entries,
    required this.palette,
    required this.days,
    required this.targetWeight,
  });

  final List<WeightEntry> entries;
  final MealWeightPalette palette;
  final int days;
  final double? targetWeight;

  @override
  State<_InteractiveWeightChart> createState() =>
      _InteractiveWeightChartState();
}

class _InteractiveWeightChartState extends State<_InteractiveWeightChart> {
  int? selectedIndex;

  @override
  void didUpdateWidget(covariant _InteractiveWeightChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (selectedIndex != null && selectedIndex! >= widget.entries.length) {
      selectedIndex = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...widget.entries]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final geometry = _weightChartGeometry(
          entries: sorted,
          size: size,
          days: widget.days,
          targetWeight: widget.targetWeight,
        );

        void selectAt(Offset localPosition) {
          if (geometry == null || geometry.points.isEmpty) return;
          var closest = 0;
          var distance = double.infinity;
          for (var index = 0; index < geometry.points.length; index++) {
            final nextDistance = (geometry.points[index].dx - localPosition.dx)
                .abs();
            if (nextDistance < distance) {
              distance = nextDistance;
              closest = index;
            }
          }
          if (selectedIndex != closest) {
            setState(() => selectedIndex = closest);
          }
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) => selectAt(details.localPosition),
          onHorizontalDragStart: (details) => selectAt(details.localPosition),
          onHorizontalDragUpdate: (details) => selectAt(details.localPosition),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: size,
                painter: _WeightChartPainter(
                  entries: sorted,
                  palette: widget.palette,
                  days: widget.days,
                  targetWeight: widget.targetWeight,
                  targetLabel: tx(context, 'Irányadó cél'),
                  selectedIndex: selectedIndex,
                ),
              ),
              if (sorted.length < 2)
                Padding(
                  padding: const EdgeInsets.fromLTRB(42, 36, 22, 4),
                  child: Text(
                    sorted.isEmpty
                        ? tx(context, 'Kezdd az első súlyméréssel.')
                        : tx(
                            context,
                            'Rögzíts még egy mérést a trend megjelenítéséhez.',
                          ),
                    textAlign: TextAlign.center,
                    style: MealText.callout(
                      widget.palette.muted,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _WeightChartGeometry {
  const _WeightChartGeometry({
    required this.points,
    required this.minWeight,
    required this.maxWeight,
    required this.padding,
    required this.plotBottom,
  });

  final List<Offset> points;
  final double minWeight;
  final double maxWeight;
  final EdgeInsets padding;
  final double plotBottom;
}

_WeightChartGeometry? _weightChartGeometry({
  required List<WeightEntry> entries,
  required Size size,
  required int days,
  required double? targetWeight,
}) {
  if (entries.isEmpty) return null;
  final weights = [...entries.map((entry) => entry.weight), ?targetWeight];
  var minWeight = weights.reduce(math.min);
  var maxWeight = weights.reduce(math.max);
  final span = maxWeight - minWeight;
  final margin = math.max(0.5, span * 0.18);
  minWeight -= margin;
  maxWeight += margin;

  const padding = EdgeInsets.fromLTRB(34, 35, 9, 18);
  final chartWidth = size.width - padding.left - padding.right;
  final chartHeight = size.height - padding.top - padding.bottom;
  final now = DateTime.now();
  final start = now.subtract(Duration(days: days));
  final recordedSpanMinutes = entries.last.recordedAt
      .difference(entries.first.recordedAt)
      .inMinutes
      .abs();
  final spreadRecentEntries = recordedSpanMinutes < 12 * 60;

  Offset pointFor(WeightEntry entry, int index) {
    final temporalRatio =
        entry.recordedAt.difference(start).inMinutes /
        math.max(1, now.difference(start).inMinutes);
    final sequenceRatio = entries.length == 1
        ? 1.0
        : 0.34 + index / (entries.length - 1) * 0.66;
    final xRatio = spreadRecentEntries ? sequenceRatio : temporalRatio;
    final yRatio = (entry.weight - minWeight) / (maxWeight - minWeight);
    return Offset(
      padding.left + chartWidth * xRatio.clamp(0, 1),
      padding.top + chartHeight * (1 - yRatio),
    );
  }

  return _WeightChartGeometry(
    points: [
      for (var index = 0; index < entries.length; index++)
        pointFor(entries[index], index),
    ],
    minWeight: minWeight,
    maxWeight: maxWeight,
    padding: padding,
    plotBottom: padding.top + chartHeight,
  );
}

class _WeightChartPainter extends CustomPainter {
  const _WeightChartPainter({
    required this.entries,
    required this.palette,
    required this.days,
    required this.targetWeight,
    required this.targetLabel,
    required this.selectedIndex,
  });

  final List<WeightEntry> entries;
  final MealWeightPalette palette;
  final int days;
  final double? targetWeight;
  final String targetLabel;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    const emptyPadding = EdgeInsets.fromLTRB(34, 35, 9, 18);
    final geometry = _weightChartGeometry(
      entries: entries,
      size: size,
      days: days,
      targetWeight: targetWeight,
    );
    final padding = geometry?.padding ?? emptyPadding;
    final plotBottom = geometry?.plotBottom ?? size.height - padding.bottom;
    final gridPaint = Paint()
      ..color = palette.border.withValues(alpha: 0.28)
      ..strokeWidth = 1;
    for (final ratio in [0.34, 0.68]) {
      final y = padding.top + (plotBottom - padding.top) * ratio;
      canvas.drawLine(
        Offset(padding.left, y),
        Offset(size.width - padding.right, y),
        gridPaint,
      );
    }
    if (geometry == null) {
      _drawDashedLine(
        canvas,
        Offset(padding.left, plotBottom - 30),
        Offset(size.width - padding.right, plotBottom - 30),
        Paint()
          ..color = palette.border.withValues(alpha: 0.42)
          ..strokeWidth = 1,
      );
      return;
    }

    double yForWeight(double weight) {
      final yRatio =
          (weight - geometry.minWeight) /
          (geometry.maxWeight - geometry.minWeight);
      return padding.top + (plotBottom - padding.top) * (1 - yRatio);
    }

    if (targetWeight != null) {
      final targetY = yForWeight(targetWeight!);
      _drawDashedLine(
        canvas,
        Offset(padding.left, targetY),
        Offset(size.width - padding.right, targetY),
        Paint()
          ..color = palette.accent.withValues(alpha: 0.42)
          ..strokeWidth = 1,
      );
      _drawText(
        canvas,
        '$targetLabel ${targetWeight!.toStringAsFixed(1)} kg',
        Offset(padding.left + 4, targetY - 16),
        palette.muted,
        fontSize: 10,
      );
    }

    final points = geometry.points;
    if (points.length >= 2) {
      final path = _smoothPath(points);
      final fillPath = Path.from(path)
        ..lineTo(points.last.dx, plotBottom)
        ..lineTo(points.first.dx, plotBottom)
        ..close();
      canvas.drawPath(
        fillPath,
        Paint()
          ..shader =
              LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  palette.accent.withValues(alpha: 0.12),
                  palette.accent.withValues(alpha: 0.00),
                ],
              ).createShader(
                Rect.fromLTRB(
                  padding.left,
                  padding.top,
                  size.width - padding.right,
                  plotBottom,
                ),
              ),
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = palette.accent
          ..strokeWidth = 2.4
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    final latestPoint = points.last;
    canvas.drawCircle(latestPoint, 4.5, Paint()..color = palette.accent);
    if (selectedIndex != null && selectedIndex! < points.length) {
      final selectedPoint = points[selectedIndex!];
      _drawDashedLine(
        canvas,
        Offset(selectedPoint.dx, padding.top),
        Offset(selectedPoint.dx, plotBottom),
        Paint()
          ..color = palette.accent.withValues(alpha: 0.28)
          ..strokeWidth = 1,
      );
      canvas.drawCircle(selectedPoint, 7, Paint()..color = palette.card);
      canvas.drawCircle(selectedPoint, 5, Paint()..color = palette.accent);
      _drawTooltip(canvas, size, selectedPoint, entries[selectedIndex!]);
    }

    _drawText(
      canvas,
      geometry.maxWeight.toStringAsFixed(1),
      Offset(0, padding.top - 4),
      palette.muted,
    );
    _drawText(
      canvas,
      geometry.minWeight.toStringAsFixed(1),
      Offset(0, plotBottom - 8),
      palette.muted,
    );
  }

  Path _smoothPath(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var index = 0; index < points.length - 1; index++) {
      final current = points[index];
      final next = points[index + 1];
      final middleX = (current.dx + next.dx) / 2;
      path.cubicTo(middleX, current.dy, middleX, next.dy, next.dx, next.dy);
    }
    return path;
  }

  void _drawTooltip(
    Canvas canvas,
    Size size,
    Offset selectedPoint,
    WeightEntry entry,
  ) {
    final label =
        '${entry.recordedAt.month.toString().padLeft(2, '0')}.'
        '${entry.recordedAt.day.toString().padLeft(2, '0')}.  ·  '
        '${entry.weight.toStringAsFixed(1)} kg';
    final textPainter = _textPainter(
      label,
      palette.text,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    );
    final width = textPainter.width + 20;
    final left = (selectedPoint.dx - width / 2).clamp(
      2.0,
      size.width - width - 2,
    );
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, 1, width, 28),
      const Radius.circular(12),
    );
    canvas.drawRRect(rect, Paint()..color = palette.card);
    canvas.drawRRect(
      rect,
      Paint()
        ..color = palette.border.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke,
    );
    textPainter.paint(canvas, Offset(left + 10, 8));
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dash = 4.0;
    const gap = 4.0;
    final distance = (end - start).distance;
    final direction = (end - start) / distance;
    for (var travelled = 0.0; travelled < distance; travelled += dash + gap) {
      final segmentEnd = math.min(distance, travelled + dash);
      canvas.drawLine(
        start + direction * travelled,
        start + direction * segmentEnd,
        paint,
      );
    }
  }

  TextPainter _textPainter(
    String text,
    Color color, {
    double fontSize = 10,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontFamily: MealText.family,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    Color color, {
    double fontSize = 10,
  }) {
    _textPainter(text, color, fontSize: fontSize).paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) {
    return oldDelegate.entries != entries ||
        oldDelegate.palette != palette ||
        oldDelegate.days != days ||
        oldDelegate.targetWeight != targetWeight ||
        oldDelegate.targetLabel != targetLabel ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppListRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      value: value,
      onTap: onTap,
    );
  }
}

class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return AppSheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: p.resultBg,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: p.resultBorder.withValues(alpha: 0.72),
                  ),
                ),
                child: Icon(CupertinoIcons.globe, color: p.accent, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx(context, 'Nyelv'),
                      style: TextStyle(
                        color: p.text,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.4,
                      ),
                    ),
                    Text(
                      tx(context, 'System nyelv automatikus felismerése'),
                      style: TextStyle(color: p.muted, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                minimumSize: const Size(30, 30),
                padding: EdgeInsets.zero,
                color: p.bg,
                borderRadius: BorderRadius.circular(15),
                onPressed: () => Navigator.pop(context),
                child: Icon(CupertinoIcons.xmark, color: p.muted, size: 17),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final language in AppLanguage.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _LanguageOption(
                language: language,
                active: state.language == language,
              ),
            ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({required this.language, required this.active});

  final AppLanguage language;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: withAppActionHaptic(() {
        state.selectLanguage(language);
        Navigator.pop(context);
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        decoration: BoxDecoration(
          color: active ? p.resultBg : p.bg.withValues(alpha: 0.76),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active
                ? p.resultBorder.withValues(alpha: 0.78)
                : p.border.withValues(alpha: 0.64),
          ),
        ),
        child: Row(
          children: [
            Text(
              _languageLabel(context, language),
              style: TextStyle(
                color: active ? p.accent : p.text,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (active)
              Icon(CupertinoIcons.check_mark_circled_solid, color: p.accent),
          ],
        ),
      ),
    );
  }
}

String _languageLabel(BuildContext context, AppLanguage language) {
  if (language == AppLanguage.system) return tx(context, 'Rendszer');
  return language.label;
}

String _brightnessModeLabel(BuildContext context, AppBrightnessMode mode) {
  return switch (mode) {
    AppBrightnessMode.system => tx(context, 'Rendszer'),
    AppBrightnessMode.light => tx(context, 'Világos'),
    AppBrightnessMode.dark => tx(context, 'Sötét'),
  };
}

IconData _brightnessModeIcon(AppBrightnessMode mode) {
  return switch (mode) {
    AppBrightnessMode.system => CupertinoIcons.device_phone_portrait,
    AppBrightnessMode.light => CupertinoIcons.sun_max,
    AppBrightnessMode.dark => CupertinoIcons.moon,
  };
}

String _subscriptionExpiryLabel(BuildContext context, AppState state) {
  if (!state.isPro || state.proExpiresAt == null) {
    return tx(context, 'Nincs aktív előfizetés');
  }
  final date = state.proExpiresAt!;
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${tx(context, 'Lejár: ')}${date.year}. $month. $day.';
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AppSheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetHeader(
            icon: CupertinoIcons.gear_alt_fill,
            title: tx(context, 'Beállítások'),
          ),
          const SizedBox(height: 14),
          SectionLabel(tx(context, 'Megjelenés')),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _ProfileRow(
                  icon: CupertinoIcons.paintbrush,
                  title: tx(context, 'Téma'),
                  value: tx(context, state.theme.name),
                  onTap: () => showThemePickerSheet(context),
                ),
                _ProfileRow(
                  icon: CupertinoIcons.globe,
                  title: tx(context, 'Nyelv'),
                  value: _languageLabel(context, state.language),
                  onTap: () => _showLanguageSheet(context),
                ),
                _ProfileRow(
                  icon: CupertinoIcons.moon,
                  title: tx(context, 'Megjelenés módja'),
                  value: _brightnessModeLabel(context, state.brightnessMode),
                  onTap: () => _showBrightnessModeSheet(context),
                ),
              ],
            ),
          ),
          SectionLabel(tx(context, 'Névjegy')),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _ProfileRow(
                  icon: CupertinoIcons.sparkles,
                  title: tx(context, 'Onboarding újraindítása'),
                  subtitle: tx(context, 'Nyisd meg újra a bevezetőt'),
                  onTap: () {
                    Navigator.pop(context);
                    state.restartOnboarding();
                  },
                ),
                _ProfileRow(
                  icon: CupertinoIcons.info,
                  title: tx(context, 'Verzió 1.0.0'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0x99000000),
      builder: (context) => const _LanguageSheet(),
    );
  }

  void _showBrightnessModeSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0x99000000),
      builder: (context) => const _BrightnessModeSheet(),
    );
  }
}

class _BrightnessModeSheet extends StatelessWidget {
  const _BrightnessModeSheet();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return AppSheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetHeader(
            icon: CupertinoIcons.moon,
            title: tx(context, 'Megjelenés módja'),
          ),
          const SizedBox(height: 16),
          for (final mode in AppBrightnessMode.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: withAppActionHaptic(() {
                  state.selectBrightnessMode(mode);
                  Navigator.pop(context);
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: state.brightnessMode == mode
                        ? p.resultBg
                        : p.bg.withValues(alpha: 0.76),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: state.brightnessMode == mode
                          ? p.resultBorder.withValues(alpha: 0.78)
                          : p.border.withValues(alpha: 0.64),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _brightnessModeIcon(mode),
                        color: state.brightnessMode == mode
                            ? p.accent
                            : p.muted,
                        size: 17,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _brightnessModeLabel(context, mode),
                        style: TextStyle(
                          color: state.brightnessMode == mode
                              ? p.accent
                              : p.text,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (state.brightnessMode == mode)
                        Icon(
                          CupertinoIcons.check_mark_circled_solid,
                          color: p.accent,
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: p.resultBg,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: p.resultBorder.withValues(alpha: 0.72)),
          ),
          child: Icon(icon, color: p.accent, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: p.text,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
            ),
          ),
        ),
        CupertinoButton(
          minimumSize: const Size(30, 30),
          padding: EdgeInsets.zero,
          color: p.bg,
          borderRadius: BorderRadius.circular(15),
          onPressed: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.xmark, color: p.muted, size: 17),
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: state.isDark ? p.bg : p.resultBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: p.accent.withValues(alpha: state.isDark ? 0.74 : 0.58),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: p.text,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: p.accent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
