import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }
    let channel = FlutterMethodChannel(
      name: "mealweight/share",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "shareText" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard
        let arguments = call.arguments as? [String: Any],
        let text = arguments["text"] as? String
      else {
        result(FlutterError(code: "bad_args", message: "Missing text", details: nil))
        return
      }
      self?.presentShareSheet(text: text)
      result(nil)
    }

    let preferencesChannel = FlutterMethodChannel(
      name: "mealweight/preferences",
      binaryMessenger: controller.binaryMessenger
    )
    preferencesChannel.setMethodCallHandler { call, result in
      let defaults = UserDefaults.standard
      switch call.method {
      case "loadThemeId":
        result(defaults.string(forKey: "themeId"))
      case "saveThemeId":
        guard
          let arguments = call.arguments as? [String: Any],
          let themeId = arguments["themeId"] as? String
        else {
          result(FlutterError(code: "bad_args", message: "Missing themeId", details: nil))
          return
        }
        defaults.set(themeId, forKey: "themeId")
        result(nil)
      case "loadLanguageCode":
        result(defaults.string(forKey: "languageCode"))
      case "saveLanguageCode":
        guard
          let arguments = call.arguments as? [String: Any],
          let languageCode = arguments["languageCode"] as? String
        else {
          result(FlutterError(code: "bad_args", message: "Missing languageCode", details: nil))
          return
        }
        defaults.set(languageCode, forKey: "languageCode")
        result(nil)
      case "loadOnboardingCompleted":
        result(defaults.object(forKey: "onboardingCompleted") as? Bool)
      case "saveOnboardingCompleted":
        guard
          let arguments = call.arguments as? [String: Any],
          let completed = arguments["completed"] as? Bool
        else {
          result(FlutterError(code: "bad_args", message: "Missing completed", details: nil))
          return
        }
        defaults.set(completed, forKey: "onboardingCompleted")
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func presentShareSheet(text: String) {
    guard let controller = window?.rootViewController else {
      return
    }
    let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
    if let popover = activity.popoverPresentationController {
      popover.sourceView = controller.view
      popover.sourceRect = CGRect(
        x: controller.view.bounds.midX,
        y: controller.view.bounds.midY,
        width: 0,
        height: 0
      )
      popover.permittedArrowDirections = []
    }
    controller.present(activity, animated: true)
  }
}
