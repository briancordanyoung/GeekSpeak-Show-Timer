import UIKit

// Swift 2: Create protocal with methods

class RingFillView: UIView {
  
  var sizeConstraints: [NSLayoutConstraint] = []

  var percentageOfSuperviewSize: CGFloat = 1.0 {
    didSet {
      if let superview = superview  {
      
        for constraint in sizeConstraints {
            superview.removeConstraint(constraint)
        }
      
        sizeConstraints   = createHeightAndWidthContraintsForView( self,
                                         toSuperview: superview,
                                     usingMultiplier: percentageOfSuperviewSize)
        superview.addConstraints(sizeConstraints)
        
      }
    }
  }
  

  
  
  // MARK: UIView Methods
  override func didMoveToSuperview() {
    addSelfContraints()
  }

  
  func addSelfContraints() {
    self.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    if let superview = self.superview {
      
      let centerContraints = createCenterContraintsForView(self,
                                               toSuperview: superview)
      let sizeContraints   = createHeightAndWidthContraintsForView( self,
                                         toSuperview: superview,
                                     usingMultiplier: percentageOfSuperviewSize)
      
      let constraints      = centerContraints + sizeContraints
      
      superview.addConstraints(constraints)
      sizeConstraints = sizeContraints
    }
  }
  
  

  func createCenterContraintsForView(aView: UIView,
                     toSuperview superview: UIView) -> [NSLayoutConstraint] {
      
    var constraints: [NSLayoutConstraint] = []
                        
    let centerY = NSLayoutConstraint(item: aView,
                                attribute: .CenterY,
                                relatedBy: .Equal,
                                   toItem: superview,
                                attribute: .CenterY,
                               multiplier: 1.0,
                                 constant: 0.0)
    constraints.append(centerY)
    
    let centerX = NSLayoutConstraint(item: aView,
                                attribute: .CenterX,
                                relatedBy: .Equal,
                                   toItem: superview,
                                attribute: .CenterX,
                               multiplier: 1.0,
                                 constant: 0.0)
    constraints.append(centerX)
                        
    return constraints
  }
  

  
  func createHeightAndWidthContraintsForView( aView: UIView,
                              toSuperview superview: UIView,
                         usingMultiplier multiplier: CGFloat)
                                                   -> [NSLayoutConstraint] {
      
      var constraints: [NSLayoutConstraint] = []
                      
      let height = NSLayoutConstraint(item: aView,
                                 attribute: .Height,
                                 relatedBy: .Equal,
                                    toItem: superview,
                                 attribute: .Height,
                                multiplier: multiplier,
                                  constant: 0.0)
      constraints.append(height)
      
      let width  = NSLayoutConstraint(item: aView,
                                 attribute: .Width,
                                 relatedBy: .Equal,
                                    toItem: superview,
                                 attribute: .Width,
                                multiplier: multiplier,
                                  constant: 0.0)
      constraints.append(width)
                      
      return constraints
  }
  
}