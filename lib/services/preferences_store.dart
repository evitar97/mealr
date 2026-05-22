import 'package:flutter/services.dart';

class PreferencesStore {
  const PreferencesStore();

  static const _channel = MethodChannel('mealweight/preferences');

  Future<String?> loadThemeId() async {
    try {
      return _channel.invokeMethod<String>('loadThemeId');
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  Future<void> saveThemeId(String themeId) async {
    try {
      await _channel.invokeMethod<void>('saveThemeId', {'themeId': themeId});
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }

  Future<String?> loadLanguageCode() async {
    try {
      return _channel.invokeMethod<String>('loadLanguageCode');
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  Future<void> saveLanguageCode(String languageCode) async {
    try {
      await _channel.invokeMethod<void>('saveLanguageCode', {
        'languageCode': languageCode,
      });
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }

  Future<bool?> loadOnboardingCompleted() async {
    try {
      return _channel.invokeMethod<bool>('loadOnboardingCompleted');
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  Future<void> saveOnboardingCompleted(bool completed) async {
    try {
      await _channel.invokeMethod<void>('saveOnboardingCompleted', {
        'completed': completed,
      });
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }

  Future<String?> loadAppSnapshot() async {
    try {
      return _channel.invokeMethod<String>('loadAppSnapshot');
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  Future<void> saveAppSnapshot(String snapshot) async {
    try {
      await _channel.invokeMethod<void>('saveAppSnapshot', {
        'snapshot': snapshot,
      });
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }
}
