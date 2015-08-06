import UIKit

class PieShapeView: FillView {
  
  convenience init() {
    self.init(frame: CGRectMake(0,0,100,100))
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    startAngle = Rotation(degrees: 0)
    endAngle   = Rotation(degrees: 360)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    // TODO: impliment coder
//    startAngle = Rotation(degrees: 0)
//    endAngle   = Rotation(degrees: 360)
  }
  
  var startAngle: Rotation {
    get {
      return Rotation(pieLayer.startAngle)
    }
    set(newAngle) {
      pieLayer.startAngle = CGFloat(newAngle)
    }
  }
  
  var endAngle: Rotation {
    get {
      return Rotation(pieLayer.endAngle)
    }
    set(newAngle) {
      pieLayer.endAngle = CGFloat(newAngle)
    }
  }
  
  var percent: CGFloat {
    get {
      let minAngle = min(startAngle,endAngle)
      let maxAngle = max(startAngle,endAngle)
      let diff     = maxAngle - minAngle
      let percent  = CGFloat(Rotation(degrees: 360)) / CGFloat(diff)
      
      return percent
    }
    set(newPercentage) {
      let additional = Rotation(degrees: 360 * newPercentage)
      endAngle = startAngle + additional
    }
  }
  
  var color: UIColor {
    get {
      return pieLayer.fillColor
    }
    set(newColor) {
      pieLayer.fillColor = newColor
    }
  }
  
  
  override class func layerClass() -> AnyClass {
    return PieShapeLayer.self
  }
  
  var pieLayer: PieShapeLayer {
    return self.layer as! PieShapeLayer
  }


}