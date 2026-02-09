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

  // Handle URL schemes for widget deep linking (cold start and warm start)
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    print("AppDelegate: open url called with: \(url)")
    // Let home_widget handle the URL - it will dispatch to widgetClicked stream
    if url.scheme == "biblewidgets" {
      // home_widget plugin handles both cold start (initiallyLaunchedFromHomeWidget)
      // and warm start (widgetClicked stream) automatically
      return true
    }
    return super.application(app, open: url, options: options)
  }
}
