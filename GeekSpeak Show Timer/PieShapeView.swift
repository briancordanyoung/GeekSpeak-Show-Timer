import UIKit

class PieShapeView: UIView {
  
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