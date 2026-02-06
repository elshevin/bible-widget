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

    // Configure home_widget with App Group ID
    if #available(iOS 14.0, *) {
      HomeWidgetPlugin.setAppGroupId("group.com.oneapp.bibleWidgets")
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
