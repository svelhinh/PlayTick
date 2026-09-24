import UIKit
import Flutter

final class LiquidGlassBar: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    if #available(iOS 26.0, *) {
      let effectView = UIVisualEffectView(effect: UIGlassEffect())
      effectView.frame = bounds
      effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      addSubview(effectView)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
final class LiquidGlassBarPlatformView: NSObject, FlutterPlatformView {
  private let bar = LiquidGlassBar()

  func view() -> UIView { bar }
}

final class LiquidGlassBarFactory: NSObject, FlutterPlatformViewFactory {
  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    LiquidGlassBarPlatformView()
  }
}