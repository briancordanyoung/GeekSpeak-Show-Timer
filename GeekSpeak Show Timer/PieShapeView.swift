import UIKit

class PieShapeView: FillView {
  
  struct Constants {
    static let StartAngle = "pieShapeViewStartAngleId"
    static let EndAngle   = "pieShapeViewEndAngleId"
  }

  convenience init() {
    self.init(frame: CGRectMake(0,0,100,100))
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentMode = .Redraw
    startAngle = Rotation(degrees: 0)
    endAngle   = Rotation(degrees: 360)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    contentMode = .Redraw
    startAngle = Rotation(aDecoder.decodeDoubleForKey(Constants.StartAngle))
    endAngle   = Rotation(aDecoder.decodeDoubleForKey(Constants.EndAngle))
  }
  
  override func encodeWithCoder(aCoder: NSCoder) {
    super.encodeWithCoder(aCoder)
    aCoder.encodeDouble(startAngle.value, forKey: Constants.StartAngle)
    aCoder.encodeDouble(endAngle.value,   forKey: Constants.EndAngle)
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
    return GSTPieLayer.self
  }
  
  var pieLayer: GSTPieLayer {
    return self.layer as! GSTPieLayer
  }


}