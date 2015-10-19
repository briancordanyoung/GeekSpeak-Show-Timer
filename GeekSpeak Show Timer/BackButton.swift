import UIKit

class BackButton: UIButton {
  
  var backView: BackView?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK:
  // MARK: UIControl Methods
  override func beginTrackingWithTouch(touch: UITouch,
                                            withEvent event: UIEvent?) -> Bool {
    let superResult =  super.beginTrackingWithTouch(touch, withEvent: event)
    backView?.highlight()
    return superResult
  }
  
  override func cancelTrackingWithEvent(event: UIEvent?) {
    super.cancelTrackingWithEvent(event)
    backView?.unhighlight()
  }
  
  override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
    super.endTrackingWithTouch(touch, withEvent: event)
    backView?.unhighlight()
  }
  
}


