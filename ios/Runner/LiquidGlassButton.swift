import UIKit

final class LiquidGlassButton: UIView {
  let button = UIButton()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    addSubview(button)
    if #available(iOS 26.0, *) {
      button.configuration = .glass()
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
