import 'package:flutter/services.dart';

class ShareService {
  const ShareService();

  static const _channel = MethodChannel('mealweight/share');

  Future<void> shareText(String text) async {
    try {
      await _channel.invokeMethod<void>('shareText', {'text': text});
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }
}
