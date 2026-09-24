import UIKit
import Flutter

final class LiquidGlassSearchBar: UIView {
  let searchBar = UISearchBar()
  var onClear: (() -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    addSubview(searchBar)
    searchBar.searchBarStyle = .minimal
    searchBar.backgroundImage = UIImage()
    searchBar.searchTextField.clearButtonMode = .always
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    searchBar.frame = bounds
  }

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let hit = super.hitTest(point, with: event)
    guard !searchBar.isFirstResponder, isClearButton(hit) else {
      return hit
    }

    searchBar.text = ""
    onClear?()
    return self
  }

  private func isClearButton(_ view: UIView?) -> Bool {
    var current = view
    while let candidate = current, candidate !== searchBar {
      if candidate is UIButton {
        return true
      }
      current = candidate.superview
    }
    return false
  }
}

final class LiquidGlassSearchBarPlatformView: NSObject, FlutterPlatformView, UISearchBarDelegate {
  private let searchBarView = LiquidGlassSearchBar()
  private let channel: FlutterMethodChannel
  
  private let placeholderMinifed: String
  private let placeholder: String

  init(channel: FlutterMethodChannel, args: [AnyHashable: Any]) {
    self.channel = channel
    self.placeholderMinifed = args["placeholderMinifed"] as? String ?? ""
    self.placeholder = args["placeholder"] as? String ?? ""

    super.init()

    searchBarView.searchBar.placeholder = placeholderMinifed

    searchBarView.searchBar.delegate = self
    searchBarView.onClear = { [channel] in
      channel.invokeMethod("search", arguments: "")
    }
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

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    channel.invokeMethod("editing", arguments: true)
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
      guard searchBar.isFirstResponder else { return }
      searchBar.placeholder = self.placeholder
    }
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    DispatchQueue.main.async { [channel] in
      searchBar.placeholder = self.placeholderMinifed
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
    let params = args as? [AnyHashable: Any] ?? [:]
    return LiquidGlassSearchBarPlatformView(channel: channel, args: params)
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec.sharedInstance()
  }
}
