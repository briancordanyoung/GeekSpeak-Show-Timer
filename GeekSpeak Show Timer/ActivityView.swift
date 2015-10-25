import UIKit

class ActivityView: UIView {
  enum Parity {
    case Even
    case Odd
  }

  // If there is no change in the activity value, and fadeoutWithoutActivity is
  // true, then animate this view to transparent.

  var fadeoutWithoutActivity = true
  var fadeoutDelay    = NSTimeInterval(1)
  var fadeoutDuration = NSTimeInterval(1)
  
  private var timer = NSTimer()
  
  var activity = CGFloat(0) {
    didSet(oldActivity) {
      resetFadeAnimation()
      
      let angle = CGFloat(M_PI*2) * activityPercentage
      
      switch activityParity {
      case .Even:
        pieLayer.startAngle = 0
        pieLayer.endAngle   = angle
      case .Odd:
        pieLayer.startAngle = angle
        pieLayer.endAngle   = CGFloat(M_PI*2)
      }
    }
  }
  
  var fillColor: UIColor {
    get {
      return pieLayer.fillColor
    }
    set(newColor) {
      pieLayer.fillColor = newColor
    }
  }
  
  
  // MARK:
  // MARK: Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  func setup() {
    opaque = false
  }

  
  // MARK:
  
  private var activityPercentage: CGFloat {
    return percentageFromActivity(activity)
  }
  
  private func percentageFromActivity(activity: CGFloat) -> CGFloat {
    let rounded = floor(activity)
    return activity - rounded
  }
  
  private var activityParity: Parity {
    let parity: Parity
    if Int(activity) % 2 == 0 {
      parity = .Even
    } else {
      parity = .Odd
    }
    return parity
  }
  
  
  func resetFadeAnimation() {
    layer.removeAllAnimations()
    alpha = 1.0
    timer.invalidate()
    timer = NSTimer.scheduledTimerWithTimeInterval( fadeoutDelay,
                                            target: self,
                                          selector: Selector("fadeAnimation"),
                                          userInfo: nil,
                                           repeats: false)
    timer.tolerance = fadeoutDelay / 2
  }
  
  
  func fadeAnimation() {
    UIView.animateWithDuration(fadeoutDuration) {
      self.alpha = 0
    }
  }
  
  
  
  override class func layerClass() -> AnyClass {
    return PieLayer.self
  }
  
  private var pieLayer: PieLayer {
    return self.layer as! PieLayer
  }
}