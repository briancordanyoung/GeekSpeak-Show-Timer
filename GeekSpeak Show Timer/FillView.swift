import UIKit

// Swift 2: Create protocal with methods

class FillView: UIView {
  
  var sizeConstraintsActive:   [NSLayoutConstraint] = []
  var sizeConstraintsInactive: [NSLayoutConstraint] = []
  
  var percentageOfSuperViewAnimationDuration = NSTimeInterval(0.25)
  private var _percentageOfSuperviewSize: CGFloat = 1.0
  
  var percentageOfSuperviewSize: CGFloat {
    set(newPercentage) {
      _percentageOfSuperviewSize = newPercentage
      animatePercentageOfSuperviewSizeWithDuration(0.0)
    }
    get {
      return _percentageOfSuperviewSize
    }
  }
  
  
  func animatePercentageOfSuperviewSize(newPercentage: CGFloat) {
    _percentageOfSuperviewSize = newPercentage
    animatePercentageOfSuperviewSizeWithDuration(percentageOfSuperViewAnimationDuration)
  }
  
  func animatePercentageOfSuperviewSizeWithDuration(duration: NSTimeInterval) {
    
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
        print("changePercentage")
        self.sizeConstraintsInactive.forEach({$0.priority = $0.priority * 10 })
        self.sizeConstraintsActive.forEach(  {$0.priority = $0.priority * 0.1})
        let newInactive = self.sizeConstraintsActive
        let newActive   = self.sizeConstraintsInactive
        self.sizeConstraintsInactive = newInactive
        self.sizeConstraintsActive   = newActive
        self.layoutIfNeeded()
      }
      
      if duration == 0 {
        print("duration == 0 ")
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
  override func didMoveToSuperview() {
    addSelfContraints()
  }

  
  func addSelfContraints() {
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
      height.priority = 999
      constraints.append(height)
      
      let width  = NSLayoutConstraint(item: aView,
                                 attribute: .Width,
                                 relatedBy: .Equal,
                                    toItem: superview,
                                 attribute: .Width,
                                multiplier: multiplier,
                                  constant: 0.0)
      width.priority = 999
      constraints.append(width)
                      
      return constraints
  }
  
}