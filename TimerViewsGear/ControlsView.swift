import UIKit

extension CGSize {
  var maxLeg: CGFloat {
    return max(self.width,self.height)
  }
}


class ControlsView: UIView {
  
  var color = UIColor.whiteColor() {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  func setup() {
    clipsToBounds = false
    opaque        = false
    translatesAutoresizingMaskIntoConstraints = false
    
    self.heightAnchor.constraintEqualToConstant(frame.size.maxLeg).active = true
    self.widthAnchor.constraintEqualToConstant(frame.size.maxLeg).active  = true
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    guard let parent = superview else {
      assertionFailure("superview does not exist")
      return
    }
    
    centerXAnchor.constraintEqualToAnchor(parent.centerXAnchor).active = true
    centerYAnchor.constraintEqualToAnchor(parent.centerYAnchor).active = true
  }
  
}

