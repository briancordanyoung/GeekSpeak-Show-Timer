import UIKit

// Swift 2: Create protocal with methods

public class SizeToSuperView: UIView {
  
  public var sizeConstraintsActive:   [NSLayoutConstraint] = []
  public var sizeConstraintsInactive: [NSLayoutConstraint] = []

  public var percentageOfSuperViewAnimationDuration = NSTimeInterval(0.25)
  private var _percentageOfSuperviewSize: CGFloat = 1.0
  
  public var percentageOfSuperviewSize: CGFloat {
    set(newPercentage) {
      _percentageOfSuperviewSize = newPercentage
      animatePercentageOfSuperviewSizeWithDuration(0.0)
    }
    get {
      return _percentageOfSuperviewSize
    }
  }
  
  
  public func animatePercentageOfSuperviewSize(newPercentage: CGFloat) {
    _percentageOfSuperviewSize = newPercentage
    animatePercentageOfSuperviewSizeWithDuration(percentageOfSuperViewAnimationDuration)
  }

  public func animatePercentageOfSuperviewSizeWithDuration(duration: NSTimeInterval) {
    
    // replace the current inactive contraints with one that will use the
    // newly set percentage
    if let superview = self.superview {
    let sizeInactive = createHeightAndWidthContraintsForView( self,
                                          toSuperview: superview,
                                      usingMultiplier: percentageOfSuperviewSize)
      sizeInactive.forEach({$0.priority = $0.priority * 0.1})
      sizeConstraintsInactive.forEach({superview.removeConstraint($0)})
      sizeConstraintsInactive = sizeInactive
      superview.addConstraints(sizeInactive)
    }
    
    if let superview = superview  {
      layoutIfNeeded()
      
      func changePercentage() {
        self.sizeConstraintsInactive.forEach({$0.priority = $0.priority * 10 })
        self.sizeConstraintsActive.forEach(  {$0.priority = $0.priority * 0.1})
        let newInactive = self.sizeConstraintsActive
        let newActive   = self.sizeConstraintsInactive
        self.sizeConstraintsInactive = newInactive
        self.sizeConstraintsActive   = newActive
        self.layoutIfNeeded()
      }
      
      if duration == 0 {
        changePercentage()
      }
      
      let options = UIViewAnimationOptions.CurveEaseInOut
      UIView.animateWithDuration( duration,
                           delay: 0.0,
                         options: options,
                      animations: changePercentage,
                      completion: { completed in self.setNeedsDisplay() }
      )
    }
  }
  
  
  // MARK: UIView Methods
  public override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSelfContraints()
  }
  
  
  private func addSelfContraints() {
    self.translatesAutoresizingMaskIntoConstraints = false
    
    if let superview = self.superview {
      
      let centerContraints = createCenterContraintsForView(self,
                                                        toSuperview: superview)
      let sizeActive = createHeightAndWidthContraintsForView( self,
                                         toSuperview: superview,
                                     usingMultiplier: percentageOfSuperviewSize)
      
      let sizeInactive = createHeightAndWidthContraintsForView( self,
                                         toSuperview: superview,
                                     usingMultiplier: percentageOfSuperviewSize)
      
      sizeInactive.forEach({$0.priority = $0.priority * 0.1})
      
      superview.addConstraints(centerContraints)
      superview.addConstraints(sizeActive)
      superview.addConstraints(sizeInactive)
      sizeConstraintsActive = sizeActive
      sizeConstraintsActive = sizeInactive
      
    }
  }
  
  

  private func createCenterContraintsForView(aView: UIView,
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
  

  
  private func createHeightAndWidthContraintsForView(aView: UIView,
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