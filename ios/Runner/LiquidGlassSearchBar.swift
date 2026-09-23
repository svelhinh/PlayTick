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

final class LiquidGlassSearchBarPlatformView: NSObject, FlutterPlatformView, UISearchBarDelegate {
  private let searchBarView = LiquidGlassSearchBar()
  private let channel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    self.channel = channel
    super.init()
    searchBarView.searchBar.delegate = self
    channel.setMethodCallHandler { [searchBarView] call, result in
      if call.method == "unfocus" {
        searchBarView.searchBar.resignFirstResponder()
        result(nil)
        return
      }
      result(FlutterMethodNotImplemented)
    }
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    channel.invokeMethod("search", arguments: searchText)
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    channel.invokeMethod("editing", arguments: true)
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    DispatchQueue.main.async { [channel] in
      channel.invokeMethod("editing", arguments: false)
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
