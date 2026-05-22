import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

import '../../app/app_layout.dart';
import '../../app/app_state.dart';
import '../../app/app_strings.dart';
import '../../models/theme_option.dart';
import '../../models/weight_entry.dart';
import '../../widgets/app_card.dart';
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
              Text(
                planLabel,
                style: TextStyle(
                  color: p.text,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isPro
                    ? '${tx(context, 'Aktív előfizetés · ')}$expiryLabel'
                    : '$expiryLabel${tx(context, ' Pro extrák lezárva')}',
                style: TextStyle(
                  color: p.muted,
                  fontSize: 13.5,
                  height: 1.25,
                  fontWeight: FontWeight.w500,
                ),
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
            style: TextStyle(
              color: isPro ? p.accent : p.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
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
    return AppCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tx(context, 'Súly progresszió'),
                  style: TextStyle(
                    color: p.text,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${state.profileWeight.toStringAsFixed(1)} kg',
                style: TextStyle(
                  color: p.accent,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _WeightRangeSelector(selected: state.weightChartRange),
          const SizedBox(height: 14),
          Container(
            height: 170,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
            decoration: BoxDecoration(
              color: p.bg.withValues(alpha: 0.62),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: p.border),
            ),
            child: entries.length < 2
                ? Center(
                    child: Text(
                      tx(context, 'Adj hozzá legalább két súlyt a diagramhoz.'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: p.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : CustomPaint(
                    painter: _WeightChartPainter(
                      entries: entries,
                      palette: p,
                      days: state.weightChartRange.days,
                    ),
                  ),
          ),
          const SizedBox(height: 14),
          if (state.isPro && stats != null) ...[
            _WeightStatsGrid(stats: stats),
            const SizedBox(height: 14),
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

class _WeightStatsGrid extends StatelessWidget {
  const _WeightStatsGrid({required this.stats});

  final WeightStats stats;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: p.bg.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.chart_bar_alt_fill,
                color: p.accent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                tx(context, 'Pro statisztika'),
                style: TextStyle(
                  color: p.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _WeightStatTile(
                  label: tx(context, 'Összes'),
                  value: _formatWeightChange(stats.totalChange),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _WeightStatTile(
                  label: tx(context, '7 nap'),
                  value: _formatOptionalWeightChange(stats.sevenDayChange),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _WeightStatTile(
                  label: tx(context, '30 nap'),
                  value: _formatOptionalWeightChange(stats.thirtyDayChange),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _WeightStatTile(
                  label: tx(context, 'Heti átlag'),
                  value:
                      '${_formatWeightChange(stats.weeklyAverage)}/${tx(context, 'hét')}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _WeightStatTile(
                  label: tx(context, 'Trend'),
                  value: _trendLabel(context, stats.trend),
                  emphasized: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _WeightStatTile(
                  label: tx(context, 'Legalacsonyabb'),
                  value: '${stats.lowestWeight.toStringAsFixed(1)} kg',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatOptionalWeightChange(double? value) {
    if (value == null) return '-';
    return _formatWeightChange(value);
  }

  String _formatWeightChange(double value) {
    if (value == 0) return '0.0 kg';
    return '${value > 0 ? '+' : ''}${value.toStringAsFixed(1)} kg';
  }

  String _trendLabel(BuildContext context, WeightTrend trend) =>
      switch (trend) {
        WeightTrend.down => tx(context, 'Csökkenő'),
        WeightTrend.stable => tx(context, 'Stagnál'),
        WeightTrend.up => tx(context, 'Emelkedő'),
      };
}

class _WeightStatTile extends StatelessWidget {
  const _WeightStatTile({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: emphasized ? p.resultBg : p.card.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: emphasized ? p.resultBorder : p.border.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: p.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                color: emphasized ? p.accent : p.text,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightRangeSelector extends StatelessWidget {
  const _WeightRangeSelector({required this.selected});

  final WeightChartRange selected;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Row(
      children: [
        _RangeButton(range: WeightChartRange.days7, selected: selected),
        const SizedBox(width: 8),
        _RangeButton(
          range: WeightChartRange.days30,
          selected: selected,
          locked: !state.isPro,
        ),
        const SizedBox(width: 8),
        _RangeButton(
          range: WeightChartRange.days60,
          selected: selected,
          locked: !state.isPro,
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: active ? state.primaryActionSurface : p.bg,
        borderRadius: BorderRadius.circular(12),
        onPressed: () => state.selectWeightChartRange(range),
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
                color: active ? p.buttonText : p.muted,
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
    return Row(
      children: [
        Expanded(
          child: Container(
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
                    style: TextStyle(
                      color: p.accent,
                      fontSize: 22,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
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
        ),
        const SizedBox(width: 10),
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          color: AppScope.of(context).primaryActionSurface,
          borderRadius: BorderRadius.circular(16),
          onPressed: () {
            _commit();
            widget.onAdd();
            focusNode.unfocus();
          },
          child: Text(
            tx(context, 'Hozzáadás'),
            style: TextStyle(color: p.buttonText, fontWeight: FontWeight.w600),
          ),
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
      minimumSize: const Size(32, 32),
      padding: EdgeInsets.zero,
      color: p.card.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(10),
      onPressed: onPressed,
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
                      fontSize: 23,
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
                  onPressed: () {
                    state.deleteWeightEntry(widget.entry.id);
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
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: CupertinoButton(
                  color: p.accent,
                  borderRadius: BorderRadius.circular(14),
                  onPressed: () {
                    final next = _currentValue();
                    if (next == null) return;
                    state.updateWeightEntry(widget.entry.id, next);
                    Navigator.pop(context);
                  },
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

class _WeightChartPainter extends CustomPainter {
  const _WeightChartPainter({
    required this.entries,
    required this.palette,
    required this.days,
  });

  final List<WeightEntry> entries;
  final MealWeightPalette palette;
  final int days;

  @override
  void paint(Canvas canvas, Size size) {
    final sorted = [...entries]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    final weights = sorted.map((entry) => entry.weight).toList();
    var minWeight = weights.reduce(math.min);
    var maxWeight = weights.reduce(math.max);
    if (minWeight == maxWeight) {
      minWeight -= 1;
      maxWeight += 1;
    }
    final padding = const EdgeInsets.fromLTRB(28, 10, 10, 24);
    final chartWidth = size.width - padding.left - padding.right;
    final chartHeight = size.height - padding.top - padding.bottom;
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));

    final gridPaint = Paint()
      ..color = palette.border
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = padding.top + chartHeight * i / 3;
      canvas.drawLine(
        Offset(padding.left, y),
        Offset(size.width - padding.right, y),
        gridPaint,
      );
    }

    Offset pointFor(WeightEntry entry) {
      final xRatio =
          entry.recordedAt.difference(start).inMinutes /
          math.max(1, now.difference(start).inMinutes);
      final yRatio = (entry.weight - minWeight) / (maxWeight - minWeight);
      return Offset(
        padding.left + chartWidth * xRatio.clamp(0, 1),
        padding.top + chartHeight * (1 - yRatio),
      );
    }

    final path = Path()
      ..moveTo(pointFor(sorted.first).dx, pointFor(sorted.first).dy);
    for (final entry in sorted.skip(1)) {
      final point = pointFor(entry);
      path.lineTo(point.dx, point.dy);
    }
    final linePaint = Paint()
      ..color = palette.accent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = palette.accent;
    for (final entry in sorted) {
      canvas.drawCircle(pointFor(entry), 4, dotPaint);
    }

    _drawText(
      canvas,
      maxWeight.toStringAsFixed(1),
      Offset(0, padding.top - 3),
      palette.muted,
    );
    _drawText(
      canvas,
      minWeight.toStringAsFixed(1),
      Offset(0, padding.top + chartHeight - 8),
      palette.muted,
    );
  }

  void _drawText(Canvas canvas, String text, Offset offset, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) {
    return oldDelegate.entries != entries ||
        oldDelegate.palette != palette ||
        oldDelegate.days != days;
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
    final state = AppScope.of(context);
    final p = state.palette;
    final rowBorder = p.border.withValues(alpha: state.isDark ? 0.48 : 0.26);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: rowBorder)),
        ),
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
                color: p.accent.withValues(alpha: state.isDark ? 0.95 : 0.78),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: p.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: p.muted,
                        fontSize: 13.5,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: TextStyle(
                  color: p.muted,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (onTap != null) ...[
              const SizedBox(width: 6),
              Icon(CupertinoIcons.chevron_right, color: p.muted, size: 17),
            ],
          ],
        ),
      ),
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
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: p.resultBg,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: p.resultBorder),
                ),
                child: Icon(CupertinoIcons.globe, color: p.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx(context, 'Nyelv'),
                      style: TextStyle(
                        color: p.text,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.4,
                      ),
                    ),
                    Text(
                      tx(context, 'System nyelv automatikus felismerése'),
                      style: TextStyle(color: p.muted, fontSize: 13),
                    ),
                  ],
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
          const SizedBox(height: 18),
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
      onPressed: () {
        state.selectLanguage(language);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: active ? p.resultBg : p.bg.withValues(alpha: 0.76),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? p.resultBorder : p.border),
        ),
        child: Row(
          children: [
            Text(
              _languageLabel(context, language),
              style: TextStyle(
                color: active ? p.accent : p.text,
                fontSize: 16,
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
          const SizedBox(height: 16),
          SectionLabel(tx(context, 'Megjelenés')),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _ProfileRow(
                  icon: CupertinoIcons.paintbrush,
                  title: tx(context, 'Téma'),
                  value: state.theme.name,
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
                onPressed: () {
                  state.selectBrightnessMode(mode);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: state.brightnessMode == mode
                        ? p.resultBg
                        : p.bg.withValues(alpha: 0.76),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: state.brightnessMode == mode
                          ? p.resultBorder
                          : p.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _brightnessModeIcon(mode),
                        color: state.brightnessMode == mode
                            ? p.accent
                            : p.muted,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _brightnessModeLabel(context, mode),
                        style: TextStyle(
                          color: state.brightnessMode == mode
                              ? p.accent
                              : p.text,
                          fontSize: 16,
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
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: p.resultBg,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: p.resultBorder),
          ),
          child: Icon(icon, color: p.accent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: p.text,
              fontSize: 19,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
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
