import UIKit


final public class StartPauseButton: UIButton {
  
  public var startPauseView: StartPauseView?
  
  // MARK:
  // MARK: UIControl Methods
  public override func beginTracking(_ touch: UITouch,
    with event: UIEvent?) -> Bool {
      let superResult =  super.beginTracking(touch, with: event)
      startPauseView?.highlight()
      return superResult
  }
  
  public override func cancelTracking(with event: UIEvent?) {
    super.cancelTracking(with: event)
    startPauseView?.unhighlight()
  }
  
  public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    super.endTracking(touch, with: event)
    
    if isTouchInside {
      if let startPauseView = startPauseView {
        switch startPauseView.currentButton {
        case .start:
          startPauseView.currentButton = .pause
        case .pause:
          startPauseView.currentButton = .start
        }
      }
      startPauseView?.unhighlightUsingBehavior(.fade)


    } else {
      startPauseView?.unhighlight()
    }
  }
  
}


