import UIKit

class RingView: SizeToSuperView {
  
  struct Constants {
  }
  
  private var _progressPastCompleted = CGFloat(0)
  
  convenience init() {
    self.init(frame: CGRectMake(0,0,100,100))
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    startAngle = TauAngle(degrees: 0)
    endAngle   = TauAngle(degrees: 360)
    ringWidth  = CGFloat(0.12228)
  }
  

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  var startAngle: TauAngle {
    get {
      return TauAngle(ringLayer.startAngle)
    }
    set(newAngle) {
      ringLayer.startAngle = CGFloat(newAngle)
    }
  }
  
  var endAngle: TauAngle {
    get {
      return TauAngle(ringLayer.endAngle)
    }
    set(newAngle) {
      ringLayer.endAngle = CGFloat(newAngle)
    }
  }
  
  var ringWidth: CGFloat {
    get {
      return ringLayer.ringWidth
    }
    set(newRingWidth) {
      ringLayer.ringWidth = newRingWidth
    }
  }
  
  var fillScale: CGFloat {
    get {
      return ringLayer.fillScale
    }
    set(newFillScale) {
      ringLayer.fillScale = newFillScale
    }
  }
  
  var ringStyle: RingDrawing.Style {
    get {
      return ringLayer.ringStyle
    }
    set(newStyle) {
      ringLayer.ringStyle = newStyle
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
  
  var colors: [RingColor] {
    get {
      return ringLayer.colors
    }
    set(newColors) {
      ringLayer.colors = newColors
    }
  }
  
  var percent: CGFloat {
    get {
      let minAngle = min(startAngle,endAngle)
      let maxAngle = max(startAngle,endAngle)
      let diff     = maxAngle - minAngle
      let percent  = CGFloat(TauAngle(degrees: 360)) / CGFloat(diff)
      
      return percent
    }
    set(newPercentage) {
      let additional = TauAngle(degrees: 360 * newPercentage)
      endAngle = startAngle + additional
    }
  }
  
  // Unlike the percent property which accounts for the startAngle and adds
  // the "percentage complete" to the startAngle to get the endAngle....
  // This progress progress property assumes the startAngle is at 0 degrees.
  // But, if the endAngle is greater than 360 degrees then the startAngle is
  // 0 + 5 + the degrees past 360 that the endAngle is at.
  // This makes a 5 degree gap in the circle the indicates the progress
  // past 100%
  var progress: CGFloat {
    get {
      let minAngle = min(startAngle,endAngle)
      let maxAngle = max(startAngle,endAngle)
      let diff     = maxAngle - minAngle
      let percent  = CGFloat(TauAngle(degrees: 360)) / CGFloat(diff)
      if percent == 1.0 {
        
      }
      
      return percent
    }
    set(newPercentage) {
      endAngle = TauAngle(degrees: 360 * newPercentage)
      if endAngle > TauAngle(degrees: 360) {
        startAngle = endAngle - TauAngle(degrees: 360)
      } else {
        startAngle = TauAngle(degrees: 0)
      }
    }
  }
  

  
  override class func layerClass() -> AnyClass {
    return RingLayer.self
  }
  
  var ringLayer: RingLayer {
    return self.layer as! RingLayer
  }
}
