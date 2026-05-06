import 'package:flutter/cupertino.dart';

import '../../app/app_layout.dart';
import '../../app/app_state.dart';
import '../../app/app_strings.dart';
import '../../models/food_item.dart';
import '../../models/meal_prep_plan.dart';
import '../../models/shopping_list.dart';
import '../../services/share_service.dart';
import '../../utils/calculators.dart';
import '../../widgets/app_card.dart';
import '../../widgets/glass_surface.dart';
import '../../widgets/mealweight_mark.dart';
import '../../widgets/spring_pressable.dart';

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
        if (!state.isPro) ...[
          _FreeLimitStrip(
            mainCount: mainFoods.length,
            sideCount: sideFoods.length,
          ),
          const SizedBox(height: 14),
        ],
        SectionLabel(tx(context, 'Főételek')),
        for (final food in mainFoods) FoodTile(food: food),
        SectionLabel(tx(context, 'Köretek')),
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
        if (!state.isPro) ...[
          const SizedBox(height: 16),
          const ProCompactUpsellCard(),
        ],
      ],
    );
  }
}

void showProPaywallSheet(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    barrierColor: const Color(0x99000000),
    builder: (context) {
      return Container(
        color: CupertinoColors.transparent,
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: const ProUpsellCard(),
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
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
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
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (filled ? p.accent : p.border).withValues(alpha: 0.72),
        ),
      ),
      child: Row(
        children: [
          Icon(
            filled ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.plus,
            color: filled ? p.accent : p.muted,
            size: 17,
          ),
          const SizedBox(width: 8),
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

    return AppCard(
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
                        '${tx(context, 'Hozzáadva')}: ${widget.food.addedLabel}',
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
                if (sharingEnabled)
                  _IconChip(
                    icon: CupertinoIcons.square_arrow_up,
                    color: p.accent,
                    onPressed: () => _shareFood(context),
                  ),
                if (notesEnabled)
                  _IconChip(
                    icon: CupertinoIcons.doc_text,
                    color: widget.food.hasNote ? p.noteColor : p.muted,
                    onPressed: () => setState(() => noteOpen = !noteOpen),
                  ),
                _IconChip(
                  icon: CupertinoIcons.trash,
                  color: const Color(0xFFC04040),
                  onPressed: () => state.deleteFood(widget.food.id),
                ),
                Icon(
                  expanded
                      ? CupertinoIcons.chevron_down
                      : CupertinoIcons.chevron_right,
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
            Icon(CupertinoIcons.chevron_right, color: p.border, size: 18),
          ],
        ),
      ),
    );
  }
}

class AddShoppingListSheet extends StatefulWidget {
  const AddShoppingListSheet({super.key});

  @override
  State<AddShoppingListSheet> createState() => _AddShoppingListSheetState();
}

class _AddShoppingListSheetState extends State<AddShoppingListSheet> {
  final nameController = TextEditingController();
  final itemRows = <_ShoppingDraftItem>[_ShoppingDraftItem()];

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
              constraints: const BoxConstraints(maxHeight: 640),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SheetHeader(
                      icon: CupertinoIcons.cart_badge_plus,
                      title: tx(context, 'Új bevásárlólista'),
                      subtitle: tx(
                        context,
                        'Nevezd el és add hozzá a tételeket',
                      ),
                    ),
                    const SizedBox(height: 16),
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
                                    state.addShoppingList(
                                      name: nameController.text,
                                      items: [
                                        for (final row in itemRows)
                                          ShoppingListItem(
                                            name: row.controller.text,
                                            checked: row.checked,
                                          ),
                                      ],
                                    );
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
  final controller = TextEditingController();
  bool checked = false;

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
          width: 42,
          height: 42,
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
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              Text(subtitle, style: TextStyle(color: p.muted, fontSize: 13)),
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
    );
  }
}

String _shoppingDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}. $month. $day.';
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
  const AddMealPrepSheet({this.plan, super.key});

  final MealPrepPlan? plan;

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
    nameController = TextEditingController(text: plan?.name ?? '');
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
    selectedFood ??=
        _findFoodByName(state.foods, widget.plan?.foodName) ??
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
              constraints: const BoxConstraints(maxHeight: 660),
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
                    const SizedBox(height: 16),
                    _Input(
                      controller: nameController,
                      placeholder: tx(context, 'Terv neve'),
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 10),
                    Text(
                      tx(context, 'Főétel'),
                      style: TextStyle(
                        color: p.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _MealPrepFoodPicker(
                      foods: mainFoods.isEmpty ? state.foods : mainFoods,
                      selected: selectedFood,
                      onSelected: (food) => setState(() => selectedFood = food),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tx(context, 'Köret hozzáadása'),
                      style: TextStyle(
                        color: p.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 8),
                    AppCard(
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
            padding: const EdgeInsets.only(bottom: 7),
            child: _MealPrepFoodOption(
              label: optionalLabel!,
              active: selected == null,
              onPressed: onClear ?? () {},
            ),
          ),
        for (final item in foods)
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
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
              constraints: const BoxConstraints(maxHeight: 600),
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
                    const SizedBox(height: 14),
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
                    const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      Text(
                        plan.note,
                        style: TextStyle(
                          color: p.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Text(
                      tx(context, 'Dobozok'),
                      style: TextStyle(
                        color: p.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (var i = 0; i < plan.boxes.length; i++)
                      _MealPrepBoxRow(
                        index: i,
                        checked: plan.boxes[i],
                        onPressed: () => state.toggleMealPrepBox(
                          planId: plan!.id,
                          boxIndex: i,
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      radius: 26,
      tint: p.card,
      opacity: 1,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tx(context, 'Új étel hozzáadása'),
              style: TextStyle(
                color: p.text,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 10),
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
                const SizedBox(width: 8),
                Expanded(
                  child: _Input(
                    controller: cooked,
                    placeholder: tx(context, 'Kész g'),
                    numericTitle: tx(context, 'Kész súly'),
                    onChanged: () => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
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
            const SizedBox(height: 8),
            AppCard(
              color: p.resultBg,
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
        padding: const EdgeInsets.symmetric(vertical: 10),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: CupertinoTextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        placeholder: placeholder,
        keyboardType: isNumeric
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        onChanged: (_) => onChanged(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      radius: 28,
      tint: p.resultBg,
      opacity: 0.58,
      borderColor: p.resultBorder.withValues(alpha: 0.72),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: const MealWeightMark(size: 50, radius: 15),
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
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.6,
                      ),
                    ),
                    Text(
                      tx(context, 'Korlátlan mentés és extra funkciók'),
                      style: TextStyle(
                        color: p.muted,
                        fontSize: 15,
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
          const SizedBox(height: 18),
          _FeatureComparisonTable(),
          const SizedBox(height: 18),
          _PricingCard(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 12),
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
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
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

class _FeatureComparisonTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    final rows = [
      _ComparisonRow(
        tx(context, 'Főétel mentés'),
        '1 ${tx(context, 'db')}',
        '∞',
      ),
      _ComparisonRow(
        tx(context, 'Köret mentés'),
        '1 ${tx(context, 'db')}',
        '∞',
      ),
      _ComparisonRow('Recept & ${tx(context, 'Jegyzet')}', 'x', 'check'),
      _ComparisonRow(tx(context, 'Étel megosztás'), 'x', 'check'),
      _ComparisonRow(tx(context, 'Bevásárlás+ listák'), 'x', 'check'),
      _ComparisonRow(
        tx(context, 'Meal Prep tervező'),
        '1 ${tx(context, 'db')}',
        '∞',
      ),
      _ComparisonRow(
        tx(context, 'Súlykövetés diagram'),
        '7 ${tx(context, 'nap')}',
        '7/30/60 ${tx(context, 'nap')}',
      ),
      _ComparisonRow(tx(context, 'Súlynapló szerkesztés'), 'x', 'check'),
      _ComparisonRow(tx(context, 'Fogyás statisztika'), 'x', 'check'),
      _ComparisonRow(
        tx(context, 'Témák (6 db)'),
        '2 ${tx(context, 'db')}',
        '6 ${tx(context, 'db')}',
      ),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: p.card,
          border: Border.all(color: p.border, width: 1.2),
        ),
        child: Column(
          children: [_ComparisonHeader(), for (final row in rows) row],
        ),
      ),
    );
  }
}

class _ComparisonHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return _ComparisonLine(
      feature: Text(
        tx(context, 'FUNKCIÓ'),
        style: TextStyle(
          color: p.muted,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.7,
        ),
      ),
      free: Text(
        tx(context, 'Ingyenes'),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: p.muted,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      pro: Text(
        tx(context, 'Pro'),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: p.accent,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow(this.feature, this.free, this.pro);

  final String feature;
  final String free;
  final String pro;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return _ComparisonLine(
      feature: Text(
        feature,
        style: TextStyle(
          color: p.text,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      free: _CellValue(value: free, muted: true),
      pro: _CellValue(value: pro, muted: false),
    );
  }
}

class _ComparisonLine extends StatelessWidget {
  const _ComparisonLine({
    required this.feature,
    required this.free,
    required this.pro,
  });

  final Widget feature;
  final Widget free;
  final Widget pro;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: p.border, width: 1)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: feature,
              ),
            ),
            _VerticalDivider(),
            Expanded(flex: 3, child: Center(child: free)),
            _VerticalDivider(),
            Expanded(flex: 3, child: Center(child: pro)),
          ],
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Container(width: 1, color: p.border);
  }
}

class _CellValue extends StatelessWidget {
  const _CellValue({required this.value, required this.muted});

  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    if (value == 'check') {
      return Icon(CupertinoIcons.check_mark, color: p.accent, size: 20);
    }
    if (value == 'x') {
      return Icon(CupertinoIcons.xmark, color: p.border, size: 20);
    }
    return Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: muted ? p.muted : p.accent,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: p.card,
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
            Container(height: 1, color: p.border),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
