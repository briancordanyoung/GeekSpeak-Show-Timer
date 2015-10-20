
class ActivityView: UIView {
  enum Parity {
    case Even
    case Odd
  }
  
  
  var activity = CGFloat(0) {
    didSet(oldActivity) {
      
      let position = CGFloat(M_PI*2) * activityPercentage
      
      switch activityParity {
      case .Even:
        print("Even  \(position)")
        pieLayer.startAngle = 0
        pieLayer.endAngle   = position
      case .Odd:
        print("Odd  \(position)")
        pieLayer.startAngle = position
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
  
  override class func layerClass() -> AnyClass {
    return PieLayer.self
  }
  
  private var pieLayer: PieLayer {
    return self.layer as! PieLayer
  }
}