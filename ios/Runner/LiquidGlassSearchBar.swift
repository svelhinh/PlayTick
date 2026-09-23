import UIKit
import Flutter

final class LiquidGlassSearchBar: UIView {
  let searchBar = UISearchBar()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    addSubview(searchBar)
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
  private let searchBar = LiquidGlassSearchBar()

  func view() -> UIView { searchBar }
}

final class LiquidGlassSearchBarFactory: NSObject, FlutterPlatformViewFactory {
  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    LiquidGlassSearchBarPlatformView()
  }
}
