import Flutter
import GoogleMaps
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Key comes from ios/Flutter/Secrets.xcconfig (git-ignored) via Info.plist,
    // so it is never hard-coded here. A missing key leaves the map grey rather
    // than crashing the app on a machine that has not been set up.
    if let key = Bundle.main.object(forInfoDictionaryKey: "MapsApiKey") as? String,
       !key.isEmpty {
      GMSServices.provideAPIKey(key)
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
