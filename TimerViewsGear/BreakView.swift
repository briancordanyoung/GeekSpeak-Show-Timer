import UIKit
import AngleGear

final public class BreakView: UIView {
  
  fileprivate var startAngle: TauAngle {
    get {
      return TauAngle(pieLayer.startAngle)
    }
    set(newAngle) {
      pieLayer.startAngle = CGFloat(newAngle)
    }
  }
  
  fileprivate var endAngle: TauAngle {
    get {
      return TauAngle(pieLayer.endAngle)
    }
    set(newAngle) {
      pieLayer.endAngle = CGFloat(newAngle)
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
  
  func setup() {
    isOpaque = false
    pieLayer.clipToCircle = false
    startAngle   = TauAngle(degrees: 0)
    endAngle     = TauAngle(degrees: 360)
  }
  
  
  // MARK:
  public var progress: CGFloat {
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
  
  
  
  
  public override class var layerClass : AnyClass {
    return PieLayer.self
  }
  
  fileprivate var pieLayer: PieLayer {
    return self.layer as! PieLayer
  }
  
  // MARK: UIView Methods
  public override func didMoveToSuperview() {
    super.didMoveToSuperview()
    guard let parent = superview else {return}
    
    self.translatesAutoresizingMaskIntoConstraints = false
    centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
    centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
    heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
    widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
  }

}


