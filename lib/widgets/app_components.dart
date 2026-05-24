import 'package:flutter/cupertino.dart';

import '../app/app_state.dart';
import '../theme/app_typography.dart';
import 'glass_surface.dart';
import 'spring_pressable.dart';

class AppPrimaryPillButton extends StatelessWidget {
  const AppPrimaryPillButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
    super.key,
  });

  final IconData? icon;
  final String label;
  final bool enabled;
  final VoidCallback onPressed;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final disabledContent = state.isDark
        ? p.muted.withValues(alpha: 0.78)
        : p.muted.withValues(alpha: 0.90);
    final disabledFill = state.isDark
        ? Color.alphaBlend(p.accent.withValues(alpha: 0.035), p.card)
        : Color.alphaBlend(p.accent.withValues(alpha: 0.025), p.card);
    final button = SpringPressable(
      enabled: enabled,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: enabled ? state.primaryActionSurface : disabledFill,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: enabled
                ? CupertinoColors.transparent
                : p.border.withValues(alpha: state.isDark ? 0.58 : 0.34),
          ),
        ),
        child: CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          borderRadius: BorderRadius.circular(999),
          color: CupertinoColors.transparent,
          onPressed: enabled ? onPressed : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: enabled
                        ? p.buttonText.withValues(alpha: 0.16)
                        : disabledContent.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    border: enabled
                        ? null
                        : Border.all(
                            color: disabledContent.withValues(alpha: 0.26),
                          ),
                  ),
                  child: Icon(
                    icon,
                    color: enabled ? p.buttonText : disabledContent,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: MealText.button(
                      enabled ? p.buttonText : disabledContent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class AppSecondaryPillButton extends StatelessWidget {
  const AppSecondaryPillButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.enabled = true,
    this.destructive = false,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool enabled;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final color = destructive ? CupertinoColors.systemRed : p.accent;
    final content = enabled ? color : p.muted.withValues(alpha: 0.68);
    return SpringPressable(
      enabled: enabled,
      pressedScale: 0.975,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        color: p.bg.withValues(alpha: state.isDark ? 0.92 : 0.78),
        borderRadius: BorderRadius.circular(12),
        onPressed: enabled ? onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: content, size: 16),
              const SizedBox(width: 7),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: MealText.captionStrong(content),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppMetricTile extends StatelessWidget {
  const AppMetricTile({
    required this.label,
    required this.value,
    this.emphasized = false,
    this.fill,
    super.key,
  });

  final String label;
  final String value;
  final bool emphasized;
  final Color? fill;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: fill ?? (emphasized ? p.resultBg : p.card),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: emphasized
              ? p.resultBorder.withValues(alpha: 0.78)
              : p.border.withValues(alpha: 0.42),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: MealText.bodyStrong(emphasized ? p.accent : p.text),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: MealText.caption(p.muted).copyWith(fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}

class AppPanel extends StatelessWidget {
  const AppPanel({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    super.key,
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
      radius: 20,
      tint: color ?? p.card,
      opacity: color == null ? 0.92 : 0.78,
      borderColor: p.border.withValues(alpha: 0.56),
      child: child,
    );
  }
}

class AppChoicePill extends StatelessWidget {
  const AppChoicePill({
    required this.label,
    required this.active,
    required this.onPressed,
    this.fullWidth = false,
    this.enabled = true,
    super.key,
  });

  final String label;
  final bool active;
  final VoidCallback onPressed;
  final bool fullWidth;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    final child = SpringPressable(
      enabled: enabled,
      pressedScale: 0.96,
      child: CupertinoButton(
        color: active ? state.primaryActionSurface : p.resultBg,
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 13),
        borderRadius: BorderRadius.circular(11),
        onPressed: enabled ? onPressed : null,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            label,
            style: MealText.bodyStrong(
              enabled
                  ? active
                        ? p.buttonText
                        : p.muted
                  : p.muted.withValues(alpha: 0.55),
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

class AppListRow extends StatelessWidget {
  const AppListRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.onTap,
    super.key,
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
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: p.border.withValues(alpha: state.isDark ? 0.48 : 0.26),
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: state.isDark ? p.bg : p.resultBg.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: p.accent.withValues(alpha: state.isDark ? 0.94 : 0.78),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: MealText.bodyStrong(p.text)),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: MealText.callout(
                        p.muted,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                ],
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: MealText.callout(
                  p.muted,
                ).copyWith(fontWeight: FontWeight.w600),
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

class AppSheetHeader extends StatelessWidget {
  const AppSheetHeader({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onClose,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onClose;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: MealText.cardTitle(p.text),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: MealText.caption(p.muted),
                ),
            ],
          ),
        ),
        CupertinoButton(
          minimumSize: const Size(32, 32),
          padding: EdgeInsets.zero,
          color: p.bg,
          borderRadius: BorderRadius.circular(16),
          onPressed: onClose ?? () => Navigator.pop(context),
          child: Icon(CupertinoIcons.xmark, color: p.muted, size: 16),
        ),
      ],
    );
  }
}

class AppTextFieldBox extends StatelessWidget {
  const AppTextFieldBox({
    required this.controller,
    required this.placeholder,
    required this.onChanged,
    this.focusNode,
    this.autofocus = false,
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.start,
    this.minLines,
    this.maxLines = 1,
    super.key,
  });

  final TextEditingController controller;
  final String placeholder;
  final VoidCallback onChanged;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).palette;
    return CupertinoTextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      placeholder: placeholder,
      keyboardType: keyboardType,
      textAlign: textAlign,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: (_) => onChanged(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      style: MealText.body(p.text),
      placeholderStyle: MealText.body(p.muted),
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: p.border.withValues(alpha: 0.64)),
      ),
    );
  }
}
