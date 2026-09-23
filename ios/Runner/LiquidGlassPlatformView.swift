import Flutter
import UIKit

final class LiquidGlassPlatformView: UIView, UITabBarDelegate {
  private let tabBar = UITabBar()
  private let channel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    self.channel = channel
    super.init(frame: .zero)
    backgroundColor = .clear
    tabBar.items = [
      UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0),
      UITabBarItem(title: "Library", image: UIImage(systemName: "books.vertical"), tag: 1),
    ]
    tabBar.selectedItem = tabBar.items?.first
    tabBar.delegate = self
    addSubview(tabBar)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    tabBar.frame = bounds
  }

  func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    channel.invokeMethod("selectIndex", arguments: item.tag)
  }
}

final class LiquidGlassPlatformViewImpl: NSObject, FlutterPlatformView {
  private let glassView: LiquidGlassPlatformView

  init(channel: FlutterMethodChannel) {
    glassView = LiquidGlassPlatformView(channel: channel)
    super.init()
  }

  func view() -> UIView { glassView }
}

final class LiquidGlassPlatformViewFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    let channel = FlutterMethodChannel(
      name: "playtick-liquid-glass/\(viewId)",
      binaryMessenger: messenger
    )
    return LiquidGlassPlatformViewImpl(channel: channel)
  }
}