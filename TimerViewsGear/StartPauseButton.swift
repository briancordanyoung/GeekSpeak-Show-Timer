import UIKit


final public class StartPauseButton: UIButton {
  
  public var startPauseView: StartPauseView?
  
  // MARK:
  // MARK: UIControl Methods
  public override func beginTrackingWithTouch(touch: UITouch,
    withEvent event: UIEvent?) -> Bool {
      let superResult =  super.beginTrackingWithTouch(touch, withEvent: event)
      startPauseView?.highlight()
      return superResult
  }
  
  public override func cancelTrackingWithEvent(event: UIEvent?) {
    super.cancelTrackingWithEvent(event)
    startPauseView?.unhighlight()
  }
  
  public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
    super.endTrackingWithTouch(touch, withEvent: event)
    
    if touchInside {
      if let startPauseView = startPauseView {
        switch startPauseView.currentButton {
        case .Start:
          startPauseView.currentButton = .Pause
        case .Pause:
          startPauseView.currentButton = .Start
        }
      }
      startPauseView?.unhighlightUsingBehavior(.Fade)


    } else {
      startPauseView?.unhighlight()
    }
  }
  
}


