package com.ati.mealful

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "mealweight/preferences"
        ).setMethodCallHandler { call, result ->
            val prefs = getSharedPreferences("mealweight_preferences", MODE_PRIVATE)
            when (call.method) {
                "loadThemeId" -> result.success(prefs.getString("themeId", null))
                "saveThemeId" -> {
                    prefs.edit().putString("themeId", call.argument<String>("themeId")).apply()
                    result.success(null)
                }
                "loadLanguageCode" -> result.success(prefs.getString("languageCode", null))
                "saveLanguageCode" -> {
                    prefs.edit().putString("languageCode", call.argument<String>("languageCode")).apply()
                    result.success(null)
                }
                "loadOnboardingCompleted" -> {
                    if (prefs.contains("onboardingCompleted")) {
                        result.success(prefs.getBoolean("onboardingCompleted", false))
                    } else {
                        result.success(null)
                    }
                }
                "saveOnboardingCompleted" -> {
                    prefs.edit().putBoolean(
                        "onboardingCompleted",
                        call.argument<Boolean>("completed") ?: false
                    ).apply()
                    result.success(null)
                }
                "loadAppSnapshot" -> result.success(prefs.getString("appSnapshot", null))
                "saveAppSnapshot" -> {
                    prefs.edit().putString("appSnapshot", call.argument<String>("snapshot")).apply()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
