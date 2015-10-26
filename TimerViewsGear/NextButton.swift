import UIKit


final public class NextButton: UIButton {
  
  public var nextView: NextView?
  
  // MARK:
  // MARK: UIControl Methods
  public override func beginTrackingWithTouch(touch: UITouch,
    withEvent event: UIEvent?) -> Bool {
      let superResult =  super.beginTrackingWithTouch(touch, withEvent: event)
      nextView?.highlight()
      return superResult
  }
  
  public override func cancelTrackingWithEvent(event: UIEvent?) {
    super.cancelTrackingWithEvent(event)
    nextView?.unhighlight()
  }
  
  public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
    super.endTrackingWithTouch(touch, withEvent: event)

    if touchInside {
      nextView?.unhighlightUsingBehavior(.Fade)
    } else {
      nextView?.unhighlight()
    }
  }
  
}


