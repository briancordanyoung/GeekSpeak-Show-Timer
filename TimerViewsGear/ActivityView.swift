import UIKit

final public class ActivityView: UIView {
  enum Parity {
    case even
    case odd
  }

  // If there is no change in the activity value, and fadeoutWithoutActivity is
  // true, then animate this view to transparent.

  public var fadeoutWithoutActivity = true
  public var fadeoutDelay    = TimeInterval(1)
  public var fadeoutDuration = TimeInterval(1)
  
  fileprivate var timer = Timer()
  
  public var activity = CGFloat(0) {
    didSet(oldActivity) {
      resetFadeAnimation()
      
      let angle = CGFloat(Double.pi*2) * activityPercentage
      
      switch activityParity {
      case .even:
        pieLayer.startAngle = 0
        pieLayer.endAngle   = angle
      case .odd:
        pieLayer.startAngle = angle
        pieLayer.endAngle   = CGFloat(Double.pi*2)
      }
    }
  }
  
  public var fillColor: UIColor {
    get {
      return pieLayer.fillColor
    }
    set(newColor) {
      pieLayer.fillColor = newColor
    }
  }
  
  
  // MARK:
  // MARK: Init

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  fileprivate func setup() {
    isOpaque = false
    pieLayer.polarity = .negative
  }

  
  // MARK:
  
  fileprivate var activityPercentage: CGFloat {
    return percentageFromActivity(activity)
  }
  
  fileprivate func percentageFromActivity(_ activity: CGFloat) -> CGFloat {
    let rounded = floor(activity)
    return activity - rounded
  }
  
  fileprivate var activityParity: Parity {
    let parity: Parity
    if Int(activity) % 2 == 0 {
      parity = .even
    } else {
      parity = .odd
    }
    return parity
  }
  
  
  func resetFadeAnimation() {
    layer.removeAllAnimations()
    alpha = 1.0
    timer.invalidate()
    timer = Timer.scheduledTimer( timeInterval: fadeoutDelay,
                                            target: self,
                                          selector: #selector(ActivityView.fadeAnimation),
                                          userInfo: nil,
                                           repeats: false)
    timer.tolerance = fadeoutDelay / 2
  }
  
  
  @objc func fadeAnimation() {
    UIView.animate(withDuration: fadeoutDuration, animations: {
      self.alpha = 0
    }) 
  }
  
  
  
  public override class var layerClass : AnyClass {
    return PieLayer.self
  }
  
  fileprivate var pieLayer: PieLayer {
    return self.layer as! PieLayer
  }
}
