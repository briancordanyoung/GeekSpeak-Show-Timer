import UIKit


// MARK: -
// MARK: UnselectedNextView

class UnselectedNextView: ControlsView {
  override func drawRect(rect: CGRect) {
    color.setStroke()
    NextShapes.rightBezier().stroke()
    NextShapes.leftBezier().stroke()
  }
}


// MARK: -
// MARK: SelectedNextView

class SelectedNextView: ControlsView {
  override func drawRect(rect: CGRect) {
    color.setFill()
    NextShapes.rightBezier().fill()
    NextShapes.leftBezier().fill()
  }
}



// MARK: -
// MARK: NextView

class NextView: UIStackView {
  
  var unhighlightDuration = Appearance.Constants.ButtonFadeDuration
  
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
  
  private let dimention = Appearance.Constants.ButtonDimension
  private let symbolContainer = UIView()
  private let unselectedView  = UnselectedNextView(frame: CGRect(x:0, y:0,
                                   width: Appearance.Constants.ButtonDimension,
                                  height: Appearance.Constants.ButtonDimension))
  private let selectedView    = SelectedNextView(frame: CGRect(x:0, y:0,
                                   width: Appearance.Constants.ButtonDimension,
                                  height: Appearance.Constants.ButtonDimension))
  
  
  // MARK: -
  // MARK: Setup
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  convenience init() {
    let defaultRect = CGRect(x: CGFloat(0),
                             y: CGFloat(0),
                         width: CGFloat(Appearance.Constants.ButtonDimension),
                        height: CGFloat(Appearance.Constants.ButtonDimension))
    
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
    symbolContainer.heightAnchor
                             .constraintEqualToConstant(dimention).active = true
    symbolContainer.widthAnchor
                            .constraintEqualToConstant(dimention).active  = true
    symbolContainer.opaque = false

    symbolContainer.addSubview(unselectedView)
    symbolContainer.addSubview(selectedView)
    
    selectedView.color   = highlightColor
    unselectedView.color = tintColor
    unhighlight()
    
    
    label.text = "Next Segment"
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