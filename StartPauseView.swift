import UIKit


class UnselectedStartView: UIView {
  
  var color = UIColor.whiteColor() {
    didSet {
      setNeedsDisplay()
    }
  }
  
  let origSizeX = CGFloat(75)
  let origSizeY = CGFloat(75)
  
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
    
    self.heightAnchor.constraintEqualToConstant(origSizeX).active = true
    self.widthAnchor.constraintEqualToConstant(origSizeY).active  = true
  }
  
  override func didMoveToSuperview() {
    guard let parent = superview else {
      assertionFailure("superview does not exist")
      return
    }
    
    self.centerXAnchor.constraintEqualToAnchor(parent.centerXAnchor).active = true
    self.centerYAnchor.constraintEqualToAnchor(parent.centerYAnchor).active = true
  }
  
  
  override func drawRect(rect: CGRect) {
    
    color.setStroke()
    UIRectFrame(rect)
    
    // drawDebugRect(rect)
  }
  
  func drawDebugRect(rect: CGRect) {
    UIColor.yellowColor().setStroke()
    UIRectFrame(rect)
  }
  
}










class SelectedStartView: UIView {
  var color = UIColor.whiteColor() {
    didSet {
      setNeedsDisplay()
    }
  }
  
  let origSizeX = CGFloat(75)
  let origSizeY = CGFloat(75)
  
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
    
    self.heightAnchor.constraintEqualToConstant(origSizeX).active = true
    self.widthAnchor.constraintEqualToConstant(origSizeY).active  = true
  }
  
  override func didMoveToSuperview() {
    guard let parent = superview else {
      assertionFailure("superview does not exist")
      return
    }
    
    self.centerXAnchor.constraintEqualToAnchor(parent.centerXAnchor).active = true
    self.centerYAnchor.constraintEqualToAnchor(parent.centerYAnchor).active = true
  }
  
  override func drawRect(rect: CGRect) {
    
    color.setFill()
    UIRectFill(rect)
    
    // drawDebugRect(rect)
  }
  
  func drawDebugRect(rect: CGRect) {
    UIColor.yellowColor().setStroke()
    UIRectFrame(rect)
  }
  
}













class StartPauseView: UIStackView {
  
  var unhighlightDuration = NSTimeInterval(0.25)
  
  enum UnhighlightBehavior {
    case Instant
    case Fade
  }
  
  enum highlightState {
    case Highlighted
    case Unhighlighted
    case Transitioning
  }
  
  
  
  var highlightColor = UIColor.whiteColor() {
    didSet(oldColor) {
      selectedView.color = highlightColor
    }
  }
  
  override var tintColor: UIColor! {
    didSet(oldColor) {
      unselectedView.color = tintColor
    }
  }
  
  
  // The highlight state is derived from the current alpha of the 2 views.
  var highlighted: highlightState {
    let   selected = unselectedView.alpha == 0.0
    let unselected =   selectedView.alpha == 0.0
    
    switch (unselected,selected) {
    case (true,false):
      return .Unhighlighted
    case (false,true):
      return .Highlighted
    case (_,_):
      return .Transitioning
    }
  }
  
  let label = UILabel()
  
  let symbolContainer = UIView()
  private let unselectedView  = UnselectedNextView()
  private let selectedView    = SelectedNextView()
  
  
  
  
  // MARK: -
  // MARK: Setup
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  convenience init() {
    let defaultRect = CGRect(x: CGFloat(0),
      y: CGFloat(0),
      width: CGFloat(75),
      height: CGFloat(75))
    
    self.init(frame: defaultRect)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
    axis          = .Vertical
    alignment     = .Center
    distribution  = .Fill
    spacing       = CGFloat(5)
    addArrangedSubview(symbolContainer)
    addArrangedSubview(label)
    
    symbolContainer.translatesAutoresizingMaskIntoConstraints = false
    symbolContainer.heightAnchor.constraintEqualToConstant(75.0).active = true
    symbolContainer.widthAnchor.constraintEqualToConstant(75.0).active  = true
    symbolContainer.opaque = false
    
    symbolContainer.addSubview(unselectedView)
    symbolContainer.addSubview(selectedView)
    
    selectedView.color   = highlightColor
    unselectedView.color = tintColor
    unhighlight()
    
    
    label.text = "Start Timer"
    label.textColor = tintColor
    if let font = UIFont(name: "Helvetica Neue", size: 12) {
      label.font = font
    }
  }
  
  
  
  
  // MARK: -
  // MARK: Actions
  func highlight() {
    selectedView.alpha   = 1.0
    unselectedView.alpha = 0.0
  }
  
  func unhighlight() {
    selectedView.alpha   = 0.0
    unselectedView.alpha = 1.0
  }
  
  private func unhighlightWithFade() {
    selectedView.layer.removeAllAnimations()
    unselectedView.layer.removeAllAnimations()
    UIView.animateWithDuration(unhighlightDuration) {
      self.unhighlight()
    }
  }
  
  func unhighlightUsingBehavior(behavior: UnhighlightBehavior) {
    switch behavior {
    case .Instant:
      unhighlight()
    case .Fade:
      unhighlightWithFade()
    }
    
  }
  
  
}