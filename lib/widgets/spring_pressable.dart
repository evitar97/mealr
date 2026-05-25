import 'package:flutter/cupertino.dart';

class SpringPressable extends StatefulWidget {
  const SpringPressable({
    required this.child,
    this.enabled = true,
    this.pressedScale = 0.975,
    super.key,
  });

  final Widget child;
  final bool enabled;
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
        duration: Duration(milliseconds: pressed ? 65 : 150),
        curve: pressed ? Curves.easeOutCubic : Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }

  void _setPressed(bool next) {
    if (pressed == next) return;
    setState(() => pressed = next);
  }

  void _press() {
    _setPressed(true);
  }
}
