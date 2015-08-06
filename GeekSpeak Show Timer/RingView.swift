import UIKit

class RingView: FillView {
  
  struct Constants {
    static let LineWidth  = "ringViewLineWidthId"
    static let ColorRed   = "ringViewColorRedId"
    static let ColorGreen = "ringViewColorGreenId"
    static let ColorBlue  = "ringViewColorBlueId"
    static let ColorAlpha = "ringViewColorAlphaId"
  }
  
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
    lineWidth = CGFloat(aDecoder.decodeDoubleForKey(Constants.LineWidth))
    let r = CGFloat(aDecoder.decodeDoubleForKey(Constants.ColorRed))
    let g = CGFloat(aDecoder.decodeDoubleForKey(Constants.ColorGreen))
    let b = CGFloat(aDecoder.decodeDoubleForKey(Constants.ColorBlue))
    let a = CGFloat(aDecoder.decodeDoubleForKey(Constants.ColorAlpha))
    lineColor = UIColor(red: r, green: g, blue: b, alpha: a)
  }
  
  override func encodeWithCoder(aCoder: NSCoder) {
    super.encodeWithCoder(aCoder)
    aCoder.encodeDouble(Double(lineWidth),  forKey: Constants.LineWidth)
    
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0

    if lineColor.getRed(&r, green: &g, blue: &b, alpha: &a) {
      aCoder.encodeDouble(Double(r),  forKey: Constants.ColorRed)
      aCoder.encodeDouble(Double(g),  forKey: Constants.ColorGreen)
      aCoder.encodeDouble(Double(b),  forKey: Constants.ColorBlue)
      aCoder.encodeDouble(Double(a),  forKey: Constants.ColorAlpha)
    }
    
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