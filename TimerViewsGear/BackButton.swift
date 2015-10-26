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
  public override func beginTrackingWithTouch(touch: UITouch,
                                            withEvent event: UIEvent?) -> Bool {
    let superResult =  super.beginTrackingWithTouch(touch, withEvent: event)
    backView?.highlight()
    return superResult
  }
  
  public override func cancelTrackingWithEvent(event: UIEvent?) {
    super.cancelTrackingWithEvent(event)
    backView?.unhighlight()
  }
  
  public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
    super.endTrackingWithTouch(touch, withEvent: event)
    backView?.unhighlight()
  }
  
}


