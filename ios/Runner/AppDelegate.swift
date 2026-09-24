import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "LiquidGlassPlatformView") else {
      return;
    }
    let factory = LiquidGlassPlatformViewFactory(messenger: registrar.messenger());
    registrar.register(factory, withId: "playtick-liquid-glass");

    let searchFactory = LiquidGlassSearchBarFactory(messenger: registrar.messenger())
    registrar.register(searchFactory, withId: "playtick-liquid-glass-search");

    let buttonFactory = LiquidGlassButtonFactory(messenger: registrar.messenger())
    registrar.register(buttonFactory, withId: "playtick-liquid-glass-button");

    let barFactory = LiquidGlassBarFactory()
    registrar.register(barFactory, withId: "playtick-liquid-glass-bar");
  }
}
