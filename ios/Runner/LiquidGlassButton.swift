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
  private let channel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    self.channel = channel
    super.init()
    glassButton.button.addTarget(
      self,
      action: #selector(pressed),
      for: .touchUpInside
    )
  }

  @objc private func pressed() {
    channel.invokeMethod("delete", arguments: nil)
  }

  func view() -> UIView { glassButton }
}

final class LiquidGlassButtonFactory: NSObject, FlutterPlatformViewFactory {
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
      name: "playtick-liquid-glass-button/\(viewId)",
      binaryMessenger: messenger
    )

    return LiquidGlassButtonPlatformView(channel: channel)
  }
}
