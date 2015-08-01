import UIKit

class RingView: UIView {
  
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
  
  
  // MARK: UIView Methods
  override func didMoveToSuperview() {
    addSelfContraints()
  }
  
  // MARK: Contraints
  func addSelfContraints() {
    self.setTranslatesAutoresizingMaskIntoConstraints(false)
    if let superview = self.superview {
      let viewsDictionary = ["wheel":self]
      
      let height:[AnyObject] =
      NSLayoutConstraint.constraintsWithVisualFormat( "V:|[wheel]|",
        options: NSLayoutFormatOptions(0),
        metrics: nil,
        views: viewsDictionary)
      
      let width:[AnyObject] =
      NSLayoutConstraint.constraintsWithVisualFormat( "H:|[wheel]|",
        options: NSLayoutFormatOptions(0),
        metrics: nil,
        views: viewsDictionary)
      
      superview.addConstraints(height)
      superview.addConstraints(width)
    }
  }

}