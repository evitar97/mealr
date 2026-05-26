import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

void appActionHaptic() {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    HapticFeedback.lightImpact();
  }
}

VoidCallback withAppActionHaptic(VoidCallback action) {
  return () {
    appActionHaptic();
    action();
  };
}
