import UIKit


class TimeWipeButton: UIButton {
  
  var highlightOpacity = CGFloat(1.0)
  
  var viewA: ShapesView? {
    willSet(newView) {
      newView?.userInteractionEnabled = false
      if let viewA   = viewA   { viewA.removeFromSuperview() }
      if let newView = newView {
        maskAContainer.opaque = false
        newView.addSubview(maskAContainer)
        addSubview(newView)
      }
    
      
      switch viewVisible {
      case .ViewA:
        newView?.alpha = 1.0
      case .ViewB:
        newView?.alpha = 0.0
      }
    }
  }
  
  
  var viewB: ShapesView? {
    willSet(newView) {
      newView?.userInteractionEnabled = false
      if let viewB   = viewB   { viewB.removeFromSuperview() }
      if let newView = newView { addSubview(newView) }

      switch viewVisible {
      case .ViewA:
        newView?.alpha = 0.0
      case .ViewB:
        newView?.alpha = 1.0
      }
    }
  }

  
  enum ViewVisible {
    case ViewA
    case ViewB
  }
  
  var viewVisible = ViewVisible.ViewA {
    willSet(newView) {
      switch newView {
      case .ViewA:
        transitionFromAToB()
      case .ViewB:
        transitionFromBToA()
      }
    }
    // TODO: Remove once animation of views is in place
    didSet {
      updateViewVisibility()
    }
  }
  
  var currentShapeView: ShapesView? {
    switch viewVisible {
    case .ViewA:
      return viewA
    case .ViewB:
      return viewB
    }
  }

  
  
  private let maskAContainer = SizeToSuperView()
  private let maskA = PieShapeView()
  private let maskB = PieShapeView()


  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  
  func setup() {
    setupPieShapeViews()
  }
  
  func setupPieShapeViews() {
    maskA.opaque = false
    maskAContainer.addSubview(maskA)
    maskA.pieLayer.clipToCircle = false
    maskA.startAngle = Rotation(degrees: 0)
    maskA.endAngle   = Rotation(degrees: 200)
  }
  
  
  override func beginTrackingWithTouch(touch: UITouch,
                             withEvent event: UIEvent) -> Bool {
    let superResult =  super.beginTrackingWithTouch(touch, withEvent: event)
    currentShapeView?.fillOpacity = highlightOpacity
    return superResult
  }
  
  override func cancelTrackingWithEvent(event: UIEvent?) {
    super.cancelTrackingWithEvent(event)
    currentShapeView?.fillOpacity = 0.0
  }
  
  override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
    super.endTrackingWithTouch(touch, withEvent: event)
    currentShapeView?.fillOpacity = 0.0
    
  }
  
  func applyMask() {
    viewA?.maskView = maskAContainer
  }
  
  func updateViewVisibility() {
    switch viewVisible {
    case .ViewA:
      viewA?.alpha = 1.0
      viewB?.alpha = 0.0
    case .ViewB:
      viewA?.alpha = 0.0
      viewB?.alpha = 1.0
    }

  }
  
  func transitionFromAToB() {

  }

  func transitionFromBToA() {

  }

  
}