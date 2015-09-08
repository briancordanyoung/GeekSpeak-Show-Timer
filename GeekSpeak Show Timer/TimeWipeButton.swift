import UIKit


class TimeWipeButton: UIButton {
  
  struct Constants {
    static let startAngleAnimKey = "startAngle"
    static let endAngleAnimKey   = "endAngle"
  }
  
  var highlightOpacity = CGFloat(1.0)
  var wipeDuration     = CFTimeInterval(0.2)
  
  
  var percentageOfSuperviewSize: CGFloat {
    get {
      var percentage = CGFloat(1)
      if let a = viewA?.percentageOfSuperviewSize ,
             b = viewB?.percentageOfSuperviewSize {
        percentage = ((a + b) / 2)
      }
      return percentage
    }
    set(newPercentage) {
      viewA?.percentageOfSuperviewSize = newPercentage
      viewB?.percentageOfSuperviewSize = newPercentage
    }
  }
  
  func animatePercentageOfSuperviewSize( newPercentage: CGFloat) {
    viewA?.animatePercentageOfSuperviewSize(newPercentage)
    viewB?.animatePercentageOfSuperviewSize(newPercentage)
  }
  
  
  var viewA: ShapesView? {
    willSet(newView) {
      newView?.userInteractionEnabled = false
      if let viewA   = viewA   { viewA.removeFromSuperview() }
      if let newView = newView {
        newView.addSubview(maskAContainer)
        addSubview(newView)
        bringViewToFront(newView)
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
        bringViewToFront(newView)
      }
    }
  }

  
  
  var frontView: ShapesView? {
    var frontView: ShapesView?
    for (i,view) in enumerate(subviews)  {
      if view === viewA  { frontView = view as? ShapesView }
      if view === viewB  { frontView = view as? ShapesView }
    }
    return frontView
  }
  
  var backView: ShapesView? {
    var backView: ShapesView?
    for (i,view) in enumerate(reverse(subviews))  {
      if view === viewA  { backView = view as? ShapesView }
      if view === viewB  { backView = view as? ShapesView }
    }
    return backView
  }

  var frontMask: PieShapeView? {
    var frontMask: PieShapeView?
    for (i,view) in enumerate(subviews)  {
      if view === viewA  { frontMask = maskA }
      if view === viewB  { frontMask = maskB }
    }
    return frontMask
  }
  
  var backMask: PieShapeView? {
    var backMask: PieShapeView?
    for (i,view) in enumerate(reverse(subviews))  {
      if view === viewA  { backMask = maskA }
      if view === viewB  { backMask = maskB }
    }
    return backMask
  }

  
  func bringViewToFront(view: UIView?) {
    if let view = view {
      self.bringSubviewToFront(view)
    }
  }
  
  
  private let maskAContainer = SizeToSuperView()
  private let maskBContainer = SizeToSuperView()
  private let maskA = PieShapeView()
  private let maskB = PieShapeView()
  private var applyMaskLater: () -> () = {}
  private var applyWhenAnimationCompletes: () -> () = {}

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
                                                            
    if animationExistsOnLayers() {
      interuptAnimation()
    } else {
      highlight()
    }
    return superResult
  }
  
  override func cancelTrackingWithEvent(event: UIEvent?) {
    super.cancelTrackingWithEvent(event)
    unhighlight()
  }
  
  override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
    super.endTrackingWithTouch(touch, withEvent: event)
    if !touchInside {
      unhighlight()
    }
    
  }


  
  // MARK:
  // MARK: Actions

  func showViewAWithHighlight(highlight: Bool) {
    showViewA()
    if highlight {
      viewA?.fillOpacity = 1.0
      viewB?.fillOpacity = 0.0
    } else {
      viewA?.fillOpacity = 0.0
      viewB?.fillOpacity = 0.0
    }
  }
  
  
  func showViewA() {
    if removeAnimationsFromLayers() {
      resetMasks()
    }
    
    bringViewToFront(viewA)
    viewA?.alpha = 1.0
    viewB?.alpha = 0.0
  }
  
  
  func showViewBWithHighlight(highlight: Bool) {
    showViewB()
    if highlight {
      viewA?.fillOpacity = 1.0
      viewB?.fillOpacity = 0.0
    } else {
      viewA?.fillOpacity = 0.0
      viewB?.fillOpacity = 0.0
    }
  }
  
  func showViewB() {
    if removeAnimationsFromLayers() {
      resetMasks()
    }
    
    bringViewToFront(viewB)
    viewA?.alpha = 0.0
    viewB?.alpha = 1.0
  }
  
  
  
  func resetMasks() {
    maskA.startAngle = Rotation(degrees: 0)
    maskA.endAngle   = Rotation(degrees: 360)
    maskB.startAngle = Rotation(degrees: 0)
    maskB.endAngle   = Rotation(degrees: 360)
  }
  
  func highlight() {
    setFillOpacity(frontView, ifNotAlready: 1.0)
    setFillOpacity(backView,  ifNotAlready: 0.0)
  }

  func highlightBack() {
    setFillOpacity(frontView, ifNotAlready: 0.0)
    setFillOpacity(backView,  ifNotAlready: 1.0)
  }
  
  func unhighlight() {
    setFillOpacity(viewA, ifNotAlready: 0.0)
    setFillOpacity(viewB, ifNotAlready: 0.0)
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
  
  func animateToViewA() {
    if let frontView = frontView ,
               viewA = viewA,
               viewB = viewB {
      if frontView === viewB {
        applyWhenAnimationCompletes = { self.bringViewToFront(viewA) }
        if let frontMask = frontMask , backMask = backMask {
          wipeAnimationForLayer(frontMask.pieLayer, forKey: Constants.startAngleAnimKey)
          wipeAnimationForLayer(backMask.pieLayer, forKey: Constants.endAngleAnimKey)
        }
      }
    }
  }
  
  
  func animateToViewB() {
    if let frontView = frontView ,
               viewA = viewA ,
               viewB = viewB {
      if frontView === viewA {
        applyWhenAnimationCompletes = { self.bringViewToFront(viewB) }
        if let frontMask = frontMask , backMask = backMask {
          wipeAnimationForLayer(frontMask.pieLayer, forKey: Constants.startAngleAnimKey)
          wipeAnimationForLayer(backMask.pieLayer, forKey: Constants.endAngleAnimKey)
        }
      }
    }
  }
  
  func interuptAnimation() {
    removeAnimationsFromLayers()
    applyWhenAnimationCompletes()
    applyWhenAnimationCompletes = {}
    highlight()
    resetMasks()
    frontView?.alpha = 1.0
    backView?.alpha  = 0.0
  }
  
  func animationCompleted() {
    applyWhenAnimationCompletes()
    applyWhenAnimationCompletes = {}
    unhighlight()
    resetMasks()
    frontView?.alpha = 1.0
    backView?.alpha = 0.0
  }
  
  
  // MARK: check for existence of animation
  func animationExistsOnLayer(layer: GSTPieLayer, forKey key: String) -> Bool {
    return layer.animationForKey(key) != nil
  }
  
  func animationExistsOnLayers(layers: [GSTPieLayer], forKey key: String) -> Bool {
    func animationExistsOnLayerForKey(layer: GSTPieLayer) -> Bool {
      return animationExistsOnLayer(layer, forKey: key)
    }
    return layers.anyAreTrue(animationExistsOnLayerForKey)
  }
  
  func animationExistsOnLayers() -> Bool {
    let layers = [maskA.pieLayer,maskB.pieLayer]
    let keys   = [Constants.startAngleAnimKey,Constants.endAngleAnimKey]
    
    // How can this be refactored in to functional code?
    for key in keys {
      for layer in layers {
        if animationExistsOnLayer(layer, forKey: key) {
          return true
        }
      }
    }
    
    return false
  }
  
  
  // MARK: remove animation
  func removeAnimationsFromLayers() -> Bool {
    return removeAnimationsFromLayers([maskA.pieLayer,
                                       maskB.pieLayer])
  }
  
  
  
  func removeAnimationsFromLayers(layers: [GSTPieLayer]) -> Bool {
    return layers.anyAreTrue( removeAnimationsFromLayer )
  }
  
  
  func removeAnimationsFromLayer(layer: GSTPieLayer) -> Bool {
    let keys = [Constants.startAngleAnimKey,
                Constants.endAngleAnimKey]

    func removeAnimationForKey(key: String) -> Bool {
      return removeAnimationFromLayer(layer, forKey: key)
    }

    return keys.anyAreTrue(removeAnimationForKey)
  }

  func removeAnimationFromLayer(layer: GSTPieLayer, forKey key: String) -> Bool {
    if animationExistsOnLayer(layer, forKey: key) {
      layer.removeAnimationForKey(key)
      return true
    } else {
      return false
    }
  }

  // MARK: create animation
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
  
  
  // MARK: CAAnimation delegate callbacks
  override func animationDidStart(anim: CAAnimation!) {
    viewA?.alpha = 1.0
    viewB?.alpha = 1.0
  }

  override func animationDidStop(animation: CAAnimation! ,finished: Bool) {
    if finished {
      animationCompleted()
    }
  }
  

  
}