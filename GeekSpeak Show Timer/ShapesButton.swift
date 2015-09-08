import UIKit


class ShapesButton: UIButton {
  
  var highlightOpacity = CGFloat(1.0)
  
  var percentageOfSuperviewSize: CGFloat {
    get {
      var percentage = CGFloat(1)
      if let percente = shapesView?.percentageOfSuperviewSize {
          percentage = percente
      }
      return percentage
    }
    set(newPercentage) {
      shapesView?.percentageOfSuperviewSize = newPercentage
    }
  }
  
  func animatePercentageOfSuperviewSize( newPercentage: CGFloat) {
    shapesView?.animatePercentageOfSuperviewSize(newPercentage)
  }

  
  var shapesView: ShapesView? {
    willSet(newView) {
      if let shapesView   = shapesView   { shapesView.removeFromSuperview() }
      if let newView = newView {
        newView.userInteractionEnabled = false
        addSubview(newView)
      }
    }
  }
  
  
  // MARK: Setup
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  

  
  
  
  // MARK:
  // MARK: UIControl Methods
  override func beginTrackingWithTouch(touch: UITouch,
                                            withEvent event: UIEvent) -> Bool {
      let superResult =  super.beginTrackingWithTouch(touch, withEvent: event)
      highlight()
      return superResult
  }
  
  override func cancelTrackingWithEvent(event: UIEvent?) {
    super.cancelTrackingWithEvent(event)
    unhighlight()
  }
  
  override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
    super.endTrackingWithTouch(touch, withEvent: event)
    unhighlight()
  }
  
  
  
  // MARK:
  // MARK: Actions
  
  
  func highlight() {
    setFillOpacity(shapesView, ifNotAlready: 1.0)
  }
  
  func unhighlight() {
    setFillOpacity(shapesView, ifNotAlready: 0.0)
  }
  
  func setFillOpacity(view: ShapesView?,ifNotAlready value: CGFloat) {
    if let view = view {
      if view.fillOpacity != value {
        view.fillOpacity = value
      }
    }
  }
  
  
  
  
  
  // MARK:
  // MARK: Mask Animation Methods
  
  
  
  // MARK: check for existence of animation
  
  // MARK: remove animation
  
  
  // MARK: CAAnimation delegate callbacks
  override func animationDidStart(anim: CAAnimation!) {
  }
  
  override func animationDidStop(animation: CAAnimation! ,finished: Bool) {
    if finished {
    }
  }
  
  
  
}