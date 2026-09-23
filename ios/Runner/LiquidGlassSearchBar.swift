import UIKit
import Flutter

final class LiquidGlassSearchBar: UIView {
  let searchBar = UISearchBar()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    addSubview(searchBar)
    searchBar.searchBarStyle = .minimal
    searchBar.backgroundImage = UIImage()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    searchBar.frame = bounds
  }
}

final class LiquidGlassSearchBarPlatformView: NSObject, FlutterPlatformView {
  private let searchBarView = LiquidGlassSearchBar()

  init(channel: FlutterMethodChannel) {
    super.init()
    channel.setMethodCallHandler { [searchBarView] call, result in
      if call.method == "unfocus" {
        searchBarView.searchBar.resignFirstResponder()
        result(nil)
        return
      }
      result(FlutterMethodNotImplemented)
    }
  }

  func view() -> UIView { searchBarView }
}

final class LiquidGlassSearchBarFactory: NSObject, FlutterPlatformViewFactory {
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
      name: "playtick-liquid-glass-search/\(viewId)",
      binaryMessenger: messenger
    )
    return LiquidGlassSearchBarPlatformView(channel: channel)
  }
}
