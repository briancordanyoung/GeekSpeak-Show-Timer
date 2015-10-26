import UIKit
import AngleGear

class BreakView: UIView {
  
  private var startAngle: TauAngle {
    get {
      return TauAngle(pieLayer.startAngle)
    }
    set(newAngle) {
      pieLayer.startAngle = CGFloat(newAngle)
    }
  }
  
  private var endAngle: TauAngle {
    get {
      return TauAngle(pieLayer.endAngle)
    }
    set(newAngle) {
      pieLayer.endAngle = CGFloat(newAngle)
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
    pieLayer.clipToCircle = false
    startAngle   = TauAngle(degrees: 0)
    endAngle     = TauAngle(degrees: 360)
  }
  
  
  // MARK:
  var progress: CGFloat {
    get {
      let minAngle = min(startAngle,endAngle)
      let maxAngle = max(startAngle,endAngle)
      let diff     = maxAngle - minAngle
      let percent  = CGFloat(TauAngle(degrees: 360)) / CGFloat(diff)
      
      return percent
    }
    set(newPercentage) {
      endAngle = TauAngle(degrees: 360 * newPercentage)
      if endAngle > TauAngle(degrees: 360) {
        let past360 = endAngle - TauAngle(degrees: 360)
        startAngle = past360 + TauAngle(degrees: 5)
      } else {
        startAngle = TauAngle(degrees: 0)
      }
    }
  }
  
  
  
  
  override class func layerClass() -> AnyClass {
    return PieLayer.self
  }
  
  private var pieLayer: PieLayer {
    return self.layer as! PieLayer
  }
  
  // MARK: UIView Methods
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    guard let parent = superview else {return}
    
    self.translatesAutoresizingMaskIntoConstraints = false
    centerXAnchor.constraintEqualToAnchor(parent.centerXAnchor).active = true
    centerYAnchor.constraintEqualToAnchor(parent.centerYAnchor).active = true
    heightAnchor.constraintEqualToAnchor(parent.heightAnchor).active = true
    widthAnchor.constraintEqualToAnchor(parent.widthAnchor).active = true
  }

}


