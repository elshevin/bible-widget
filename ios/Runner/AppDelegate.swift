import Flutter
import UIKit
import home_widget

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle URL schemes for widget deep linking
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    // Let home_widget handle the URL if it's from the widget
    if url.scheme == "biblewidgets" {
      // The home_widget package will handle this through initiallyLaunchedFromHomeWidget
      return true
    }
    return super.application(app, open: url, options: options)
  }
}
