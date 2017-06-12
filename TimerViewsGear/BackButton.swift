import UIKit

final public class BackButton: UIButton {
  
  public var backView: BackView?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK:
  // MARK: UIControl Methods
  public override func beginTracking(_ touch: UITouch,
                                            with event: UIEvent?) -> Bool {
    let superResult =  super.beginTracking(touch, with: event)
    backView?.highlight()
    return superResult
  }
  
  public override func cancelTracking(with event: UIEvent?) {
    super.cancelTracking(with: event)
    backView?.unhighlight()
  }
  
  public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    super.endTracking(touch, with: event)
    backView?.unhighlight()
  }
  
}


