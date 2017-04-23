import UIKit


final public class NextButton: UIButton {
  
  public var nextView: NextView?
  
  // MARK:
  // MARK: UIControl Methods
  public override func beginTracking(_ touch: UITouch,
    with event: UIEvent?) -> Bool {
      let superResult =  super.beginTracking(touch, with: event)
      nextView?.highlight()
      return superResult
  }
  
  public override func cancelTracking(with event: UIEvent?) {
    super.cancelTracking(with: event)
    nextView?.unhighlight()
  }
  
  public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    super.endTracking(touch, with: event)

    if isTouchInside {
      nextView?.unhighlightUsingBehavior(.fade)
    } else {
      nextView?.unhighlight()
    }
  }
  
}


