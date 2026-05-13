import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class SpringPressable extends StatefulWidget {
  const SpringPressable({
    required this.child,
    this.enabled = true,
    this.haptics = true,
    this.pressedScale = 0.96,
    super.key,
  });

  final Widget child;
  final bool enabled;
  final bool haptics;
  final double pressedScale;

  @override
  State<SpringPressable> createState() => _SpringPressableState();
}

class _SpringPressableState extends State<SpringPressable> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: widget.enabled ? (_) => _press() : null,
      onPointerUp: widget.enabled ? (_) => _setPressed(false) : null,
      onPointerCancel: widget.enabled ? (_) => _setPressed(false) : null,
      child: AnimatedScale(
        scale: pressed ? widget.pressedScale : 1,
        duration: Duration(milliseconds: pressed ? 70 : 180),
        curve: pressed ? Curves.easeOutCubic : Curves.easeOutBack,
        child: widget.child,
      ),
    );
  }

  void _setPressed(bool next) {
    if (pressed == next) return;
    setState(() => pressed = next);
  }

  void _press() {
    if (widget.haptics) HapticFeedback.selectionClick();
    _setPressed(true);
  }
}
