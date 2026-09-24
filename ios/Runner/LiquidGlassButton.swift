import UIKit
import Flutter

final class LiquidGlassButton: UIView {
  let button = UIButton()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    addSubview(button)
    if #available(iOS 26.0, *) {
        var config = UIButton.Configuration.glass()
        config.image = UIImage(systemName: "trash")?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        button.configuration = config
    } else {
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    button.frame = bounds
  }
}

final class LiquidGlassButtonPlatformView: NSObject, FlutterPlatformView {
  private let glassButton = LiquidGlassButton()

  func view() -> UIView { glassButton }
}

final class LiquidGlassButtonFactory: NSObject, FlutterPlatformViewFactory {
  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    LiquidGlassButtonPlatformView()
  }
}
