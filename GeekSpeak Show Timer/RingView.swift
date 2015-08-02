import UIKit

class RingView: FillView {
  
  convenience init() {
    self.init(frame: CGRectMake(0,0,100,100))
    lineWidth = 15.0
    lineColor = UIColor.redColor()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    lineWidth = 15.0
    lineColor = UIColor.redColor()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    // TODO: impliment coder
//    lineWidth = 15.0
//    lineColor = UIColor.redColor()
  }
  
  var lineWidth: CGFloat {
    get {
      return ringLayer.strokeWidth
    }
    set(newAngle) {
      ringLayer.strokeWidth = newAngle
    }
  }
  
  var lineColor: UIColor {
    get {
      return ringLayer.strokeColor
    }
    set(newColor) {
      ringLayer.strokeColor = newColor
    }
  }
  
  
  override class func layerClass() -> AnyClass {
    return RingLayer.self
  }
  
  var ringLayer: RingLayer {
    return self.layer as! RingLayer
  }
  
}