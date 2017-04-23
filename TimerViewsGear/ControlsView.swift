import UIKit

class ControlsView: UIView {
  
  var color = UIColor.white {
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
    isOpaque        = false
    translatesAutoresizingMaskIntoConstraints = false
    
    self.heightAnchor.constraint(equalToConstant: frame.size.maxLeg).isActive = true
    self.widthAnchor.constraint(equalToConstant: frame.size.maxLeg).isActive  = true
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    guard let parent = superview else {
      assertionFailure("superview does not exist")
      return
    }
    
    centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
    centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
  }
  
}

