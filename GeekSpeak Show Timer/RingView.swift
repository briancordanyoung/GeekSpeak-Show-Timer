import UIKit

class RingView: RingFillView {

  struct Constants {
    static let StartAngle = "ringViewStartAngleId"
    static let EndAngle   = "ringViewEndAngleId"
    static let RingWidth  = "ringViewRingWidthId"
  }
  
  convenience init() {
    self.init(frame: CGRectMake(0,0,100,100))
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    startAngle = Rotation(degrees: 0)
    endAngle   = Rotation(degrees: 360)
    ringWidth  = CGFloat(10)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    startAngle = Rotation(aDecoder.decodeDoubleForKey(Constants.StartAngle))
    endAngle   = Rotation(aDecoder.decodeDoubleForKey(Constants.EndAngle))
    ringWidth  = CGFloat( aDecoder.decodeDoubleForKey(Constants.RingWidth))
  }
  
  override func encodeWithCoder(aCoder: NSCoder) {
    super.encodeWithCoder(aCoder)
    aCoder.encodeDouble(startAngle.value,  forKey: Constants.StartAngle)
    aCoder.encodeDouble(endAngle.value,    forKey: Constants.EndAngle)
    aCoder.encodeDouble(Double(ringWidth), forKey: Constants.RingWidth)
  }
  
  class func sectionColor(color: UIColor,
        atPercentage percentage: Double ) -> [String:AnyObject] {

    var dictionary: [String:AnyObject] = [:]
    dictionary["color"] = color
    dictionary["percentage"] = percentage

    return dictionary
  }
  
  var startAngle: Rotation {
    get {
      return Rotation(ringLayer.startAngle)
    }
    set(newAngle) {
      ringLayer.startAngle = CGFloat(newAngle)
    }
  }
  
  var endAngle: Rotation {
    get {
      return Rotation(ringLayer.endAngle)
    }
    set(newAngle) {
      ringLayer.endAngle = CGFloat(newAngle)
    }
  }
  
  var ringWidth: CGFloat {
    get {
      return CGFloat(ringLayer.ringWidth)
    }
    set(newRingWidth) {
      ringLayer.ringWidth = CGFloat(newRingWidth)
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
      return ringLayer.color
    }
    set(newColor) {
      ringLayer.color = newColor
    }
  }
  
  var additionalColors: [[String:AnyObject]] {
    get {
      var castColors: [[String:AnyObject]] = []
      if let addCol = ringLayer.additionalColors {
        for colorDictionary in addCol {
          if let dictionary = colorDictionary as? [String:AnyObject] {
            castColors.append(dictionary)
          }
        }
      }
      return castColors
    }
    set(newArray) {
      ringLayer.additionalColors = newArray
    }
  }
  
  
  override class func layerClass() -> AnyClass {
    return GSTRingLayer.self
  }
  
  var ringLayer: GSTRingLayer {
    return self.layer as! GSTRingLayer
  }
}
