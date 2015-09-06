import UIKit


class TimeWipeButton: UIButton {
  
  struct Constants {
    static let startAngleAnimKey = "startAngle"
    static let endAngleAnimKey   = "endAngle"
  }
  
  var highlightOpacity = CGFloat(1.0)
  var wipeDuration     = CFTimeInterval(3)
  
  var viewA: ShapesView? {
    willSet(newView) {
      newView?.userInteractionEnabled = false
      if let viewA   = viewA   { viewA.removeFromSuperview() }
      if let newView = newView {
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
      if let newView = newView {
        newView.addSubview(maskBContainer)
        addSubview(newView)
      }

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
    willSet(nextView) {
      switch nextView {
      case .ViewA:
        if viewVisible != nextView { transitionFromBToA() }
      case .ViewB:
        if viewVisible != nextView { transitionFromAToB() }
      }
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

  var otherShapeView: ShapesView? {
    switch viewVisible {
    case .ViewA:
      return viewB
    case .ViewB:
      return viewA
    }
  }

  
  private var viewIsReady = false
  private let maskAContainer = SizeToSuperView()
  private let maskBContainer = SizeToSuperView()
  private let maskA = PieShapeView()
  private let maskB = PieShapeView()
  private var applyMaskLater: () -> () = {}

  // MARK: Setup
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupPieShapeViews()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupPieShapeViews()
  }
  
  func setupPieShapeViews() {
    maskA.opaque = false
    maskA.pieLayer.clipToCircle = false
    maskA.startAngle = Rotation(degrees: 0)
    maskA.endAngle   = Rotation(degrees: 360)
    maskAContainer.opaque = false
    maskAContainer.addSubview(maskA)

    maskB.opaque = false
    maskB.pieLayer.clipToCircle = false
    maskB.startAngle = Rotation(degrees: 0)
    maskB.endAngle   = Rotation(degrees: 360)
    maskBContainer.opaque = false
    maskBContainer.addSubview(maskB)
    
    applyMaskLater = {
      self.viewA?.maskView = self.maskAContainer
      self.viewB?.maskView = self.maskBContainer
    }
  }
  
  override func needsUpdateConstraints() -> Bool {
    applyMaskLater()
    return super.needsUpdateConstraints()
  }
  
  // MARK:
  // MARK: UIControl Methods
  override func beginTrackingWithTouch(touch: UITouch,
                             withEvent event: UIEvent) -> Bool {
    let superResult =  super.beginTrackingWithTouch(touch, withEvent: event)
                                                            
    if removeAnimationsFromLayers() {
      otherShapeView?.fillOpacity   = highlightOpacity
      currentShapeView?.fillOpacity = 0.0
    } else {
      currentShapeView?.fillOpacity = highlightOpacity
      otherShapeView?.fillOpacity   = 0.0
    }
    return superResult
  }
  
  override func cancelTrackingWithEvent(event: UIEvent?) {
    super.cancelTrackingWithEvent(event)
    viewA?.fillOpacity = 0.0
    viewB?.fillOpacity = 0.0
  }
  
  override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
    super.endTrackingWithTouch(touch, withEvent: event)
    if !touchInside {
      viewA?.fillOpacity = 0.0
      viewB?.fillOpacity = 0.0
    }
    
  }


  
  // MARK:
  // MARK: Actions
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
    
    if removeAnimationsFromLayers() {
      viewA?.fillOpacity = highlightOpacity
      viewB?.fillOpacity = 0.0
    }

    wipeAnimationForLayer(maskA.pieLayer, forKey: Constants.startAngleAnimKey)
    wipeAnimationForLayer(maskB.pieLayer, forKey: Constants.endAngleAnimKey)
    
    if let viewA = viewA {
      self.bringSubviewToFront(viewA)
    }
    viewA?.alpha = 1.0
    viewB?.alpha = 1.0
  }

  
  
  func transitionFromBToA() {
    if removeAnimationsFromLayers() {
      viewB?.fillOpacity = highlightOpacity
      viewA?.fillOpacity = 0.0
    }

    wipeAnimationForLayer(maskB.pieLayer, forKey: Constants.startAngleAnimKey)
    wipeAnimationForLayer(maskA.pieLayer, forKey: Constants.endAngleAnimKey)
    
    if let viewB = viewB {
      self.bringSubviewToFront(viewB)
    }
    viewA?.alpha = 1.0
    viewB?.alpha = 1.0
  }
  
  func removeAnimationsFromLayers() -> Bool {
    return removeAnimationsFromLayers([maskA.pieLayer,
                                       maskB.pieLayer])
  }
  
  func removeAnimationsFromLayers(layers: [GSTPieLayer]) -> Bool {
    var didRemove = false

    for layer in layers {
      if removeAnimationsFromLayer(layer) {
        didRemove = true
      }
    }
    
    return didRemove
  }
  
  
  func removeAnimationsFromLayer(layer: GSTPieLayer) -> Bool {
    var didRemove = false
    
    for key in [Constants.startAngleAnimKey,
                Constants.endAngleAnimKey] {
      if removeAnimationFromLayer(layer, forKey: key) {
        didRemove = true
      }
    }

    return didRemove
  }

  
  func removeAnimationFromLayer(layer: GSTPieLayer, forKey key: String) -> Bool {
    var didRemove = false
    if (layer.animationForKey(key) != nil) {

      didRemove = true
      layer.removeAnimationForKey(key)
    }
    
    return didRemove
  }

  func wipeAnimationForLayer(layer: GSTPieLayer, forKey key: String) {
    let animation = CABasicAnimation(keyPath:key)
    
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    animation.fromValue      = CGFloat(Rotation(degrees: 0))
    animation.toValue        = CGFloat(Rotation(degrees: 360))
    animation.duration       = wipeDuration
    animation.delegate       = self
    layer.setValue(CGFloat(Rotation(degrees: 360)), forKey: key)
    layer.addAnimation(animation, forKey: key)
  }
  
  
  // CAAnimation delegate callbacks
  override func animationDidStart(anim: CAAnimation!) {
  
  }

  override func animationDidStop(animation: CAAnimation! ,finished: Bool) {
    if finished {
      viewA?.fillOpacity = 0.0
      viewB?.fillOpacity = 0.0
    }
    updateViewVisibility()
    maskA.startAngle = Rotation(degrees: 0)
    maskA.endAngle   = Rotation(degrees: 360)
    maskB.startAngle = Rotation(degrees: 0)
    maskB.endAngle   = Rotation(degrees: 360)
  }
  

  
}