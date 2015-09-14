// Ring Classes:  Refactor!!!
//                The classes for drawing and layingout the ring are completely
//                messing confussing, uses similar but different propery  names
//                mix obj-c and swift cause type conversions that are confusing
//                and general a mess.  Clean this mess up!!!
//                Draw cleanly and be nice.  ;)
//
//                  GSTRing.h
//                  GSTRing.m
//                  GSTRingLayer.h
//                  RingCircle.swift
//                  RingFillView.swift
//                  RingPoint.swift
//                  RingView+Progress.swift
//                  RingView.swift

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
    ringWidth  = CGFloat(0.12228)
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
  
  var viewSize: relativeViewSize? {
    get {
      return ringLayer.viewSize
    }
    set(newViewSize) {
      ringLayer.viewSize = newViewSize
    }
  }
  
  var cornerRounding: CGFloat {
    get {
      return ringLayer.cornerRounding
    }
    set(newCornerRounding) {
      ringLayer.cornerRounding = newCornerRounding
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
      ringLayer.setNeedsDisplay()
    }
  }
  
  var additionalColors: [[String:AnyObject]] {
    get {
      var castColors: [[String:AnyObject]] = []
      for colorDictionary in ringLayer.additionalColors {
        if let dictionary = colorDictionary as? [String:AnyObject] {
          castColors.append(dictionary)
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
