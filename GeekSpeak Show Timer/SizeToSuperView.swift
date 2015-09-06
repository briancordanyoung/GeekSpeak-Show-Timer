import UIKit

// Swift 2: Create protocal with methods

class SizeToSuperView: UIView {
  
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
    super.didMoveToSuperview()
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
      
      superview.addConstraints(centerContraints)
      superview.addConstraints(sizeContraints)
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
    centerY.identifier = "SizeToSuperView-centerY"
    constraints.append(centerY)
    
    let centerX = NSLayoutConstraint(item: aView,
                                attribute: .CenterX,
                                relatedBy: .Equal,
                                   toItem: superview,
                                attribute: .CenterX,
                               multiplier: 1.0,
                                 constant: 0.0)
    centerX.identifier = "SizeToSuperView-centerX"
    constraints.append(centerX)

    let aspect = NSLayoutConstraint(item: aView,
                               attribute: .Height,
                               relatedBy: .Equal,
                                  toItem: aView,
                               attribute: .Width,
                              multiplier: 1.0,
                                constant: 0.0)
    aspect.priority = 1000
    aspect.identifier = "SizeToSuperView-aspect"
    constraints.append(aspect)
                      
                      
    return constraints
  }
  

  
  func createHeightAndWidthContraintsForView(aView: UIView,
                                  toSuperview superview: UIView,
                             usingMultiplier multiplier: CGFloat)
                                                       -> [NSLayoutConstraint] {
      
      var constraints: [NSLayoutConstraint] = []
                      
      let height = NSLayoutConstraint(item: aView,
                                 attribute: .Height,
                                 relatedBy: .LessThanOrEqual,
                                    toItem: superview,
                                 attribute: .Height,
                                multiplier: multiplier,
                                  constant: 0.0)
      height.priority = 750
      height.identifier = "SizeToSuperView-height"
      constraints.append(height)
      
      let width  = NSLayoutConstraint(item: aView,
                                 attribute: .Width,
                                 relatedBy: .LessThanOrEqual,
                                    toItem: superview,
                                 attribute: .Width,
                                multiplier: multiplier,
                                  constant: 0.0)
      width.priority = 750
      width.identifier = "SizeToSuperView-width"
      constraints.append(width)

                                                        
      let heightToo = NSLayoutConstraint(item: aView,
                                 attribute: .Height,
                                 relatedBy: .Equal,
                                    toItem: superview,
                                 attribute: .Height,
                                multiplier: multiplier,
                                  constant: 0.0)
      heightToo.priority = 500
      heightToo.identifier = "SizeToSuperView-heightToo"
      constraints.append(heightToo)
      
      let widthToo  = NSLayoutConstraint(item: aView,
                                 attribute: .Width,
                                 relatedBy: .Equal,
                                    toItem: superview,
                                 attribute: .Width,
                                multiplier: multiplier,
                                  constant: 0.0)
      widthToo.priority = 500
      widthToo.identifier = "SizeToSuperView-widthToo"
      constraints.append(widthToo)

                                                        
                                                        
      return constraints
  }
  
}