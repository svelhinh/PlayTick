final class LiquidGlassButton: UIView {
  let button = UIButton()

  init(icon: String, tint: UIColor) {
    super.init(frame: .zero)
    backgroundColor = .clear
    addSubview(button)
    if #available(iOS 26.0, *) {
      var config = UIButton.Configuration.glass()
      config.image = UIImage(systemName: icon)?
        .withTintColor(tint, renderingMode: .alwaysOriginal)
      button.configuration = config
    } else {
      button.setImage(UIImage(systemName: icon), for: .normal)
      button.tintColor = tint
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
  private let glassButton: LiquidGlassButton
  private let channel: FlutterMethodChannel
  private let method: String

  init(channel: FlutterMethodChannel, args: [AnyHashable: Any]) {
    let icon = args["icon"] as? String ?? "trash"
    let tint: UIColor = (args["tint"] as? String) == "label" ? .label : .systemRed
    glassButton = LiquidGlassButton(icon: icon, tint: tint ?? .systemRed)
    method = args["method"] as? String ?? "delete"
    self.channel = channel
    super.init()
    glassButton.button.addTarget(
      self,
      action: #selector(pressed),
      for: .touchUpInside
    )
  }

  @objc private func pressed() {
    channel.invokeMethod(method, arguments: nil)
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
    let params = args as? [AnyHashable: Any] ?? [:]
    return LiquidGlassButtonPlatformView(channel: channel, args: params)
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec.sharedInstance()
  }
}