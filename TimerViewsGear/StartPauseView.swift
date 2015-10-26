import UIKit

// MARK: -
// MARK: UnselectedStartView

final class UnselectedStartView: ControlsView {
  override func drawRect(rect: CGRect) {
    color.setStroke()
    StartPauseShapes.startBezier().stroke()
  }
}


// MARK: -
// MARK: SelectedStartView

final class SelectedStartView: ControlsView {
  override func drawRect(rect: CGRect) {
    color.setFill()
    StartPauseShapes.startBezier().fill()
  }
  
}

// MARK: -
// MARK: UnselectedPauseView

final class UnselectedPauseView: ControlsView {
  override func drawRect(rect: CGRect) {
    color.setStroke()
    StartPauseShapes.leftPauseBezier().stroke()
    StartPauseShapes.rightPauseBezier().stroke()
  }
}


// MARK: -
// MARK: SelectedPauseView

final class SelectedPauseView: ControlsView {
  override func drawRect(rect: CGRect) {
    color.setFill()
    StartPauseShapes.leftPauseBezier().fill()
    StartPauseShapes.rightPauseBezier().fill()
  }
  
}



// MARK: -
// MARK: SelectedStartView

final public class StartPauseView: UIStackView {
  
  public var unhighlightDuration = Appearance.Constants.ButtonFadeDuration
  
  public enum UnhighlightBehavior {
    case Instant
    case Fade
  }
  
  public enum highlightState {
    case Highlighted
    case Unhighlighted
    case Transitioning
  }
  
  public enum ButtonState {
    case Start
    case Pause
  }
  
  public var currentButton = ButtonState.Start
  
  public var highlightColor = UIColor.whiteColor() {
    didSet(oldColor) {
      selectedStartView.color = highlightColor
      selectedPauseView.color = highlightColor
    }
  }
  
  public override var tintColor: UIColor! {
    didSet(oldColor) {
      unselectedStartView.color = tintColor
      unselectedPauseView.color = tintColor
    }
  }
  
  
  // The highlight state is derived from the current alpha of the 2 views.
  public var highlighted: highlightState {
    let   selected = unselectedStartView.alpha == 0.0
    let unselected =   selectedStartView.alpha == 0.0
    
    switch (unselected,selected) {
    case (true,false):
      return .Unhighlighted
    case (false,true):
      return .Highlighted
    case (_,_):
      return .Transitioning
    }
  }
  
  public let label = UILabel()
  
  private let dimention = Appearance.Constants.ButtonDimension
  private let symbolContainer = UIView()
  private let unselectedStartView  = UnselectedStartView(frame: CGRect(x:0, y:0,
                                   width: Appearance.Constants.ButtonDimension,
                                  height: Appearance.Constants.ButtonDimension))
  private let selectedStartView    = SelectedStartView(frame: CGRect(x:0, y:0,
                                   width: Appearance.Constants.ButtonDimension,
                                  height: Appearance.Constants.ButtonDimension))
  
  private let unselectedPauseView  = UnselectedPauseView(frame: CGRect(x:0, y:0,
                                   width: Appearance.Constants.ButtonDimension,
                                  height: Appearance.Constants.ButtonDimension))
  private let selectedPauseView    = SelectedPauseView(frame: CGRect(x:0, y:0,
                                   width: Appearance.Constants.ButtonDimension,
                                  height: Appearance.Constants.ButtonDimension))
  
  
  
  // MARK: -
  // MARK: Setup
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  public convenience init() {
    let defaultRect = CGRect(x: CGFloat(0),
      y: CGFloat(0),
      width: CGFloat(Appearance.Constants.ButtonDimension),
      height: CGFloat(Appearance.Constants.ButtonDimension))
    
    self.init(frame: defaultRect)
  }
  
  public required init?(coder aDecoder: NSCoder) {
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
    symbolContainer.heightAnchor.constraintEqualToConstant(dimention).active = true
    symbolContainer.widthAnchor.constraintEqualToConstant(dimention).active  = true
    symbolContainer.opaque = false
    
    symbolContainer.addSubview(unselectedStartView)
    symbolContainer.addSubview(selectedStartView)
    symbolContainer.addSubview(unselectedPauseView)
    symbolContainer.addSubview(selectedPauseView)
    
    selectedStartView.color   = highlightColor
    unselectedStartView.color = tintColor
    selectedPauseView.color   = highlightColor
    unselectedPauseView.color = tintColor
    unhighlight()
    
    
    label.text = "Start Timer"
    label.textColor = tintColor
    if let font = UIFont(name: "Helvetica Neue", size: 12) {
      label.font = font
    }
  }
  
  
  
  
  // MARK: -
  // MARK: Actions
  public func highlight() {
    switch currentButton {
      case .Start:
        selectedStartView.alpha   = 1.0
        unselectedStartView.alpha = 0.0
        selectedPauseView.alpha   = 0.0
        unselectedPauseView.alpha = 0.0
      case .Pause:
        selectedStartView.alpha   = 0.0
        unselectedStartView.alpha = 0.0
        selectedPauseView.alpha   = 1.0
        unselectedPauseView.alpha = 0.0
    }
  }
  
  public func unhighlight() {
    switch currentButton {
    case .Start:
      selectedStartView.alpha   = 0.0
      unselectedStartView.alpha = 1.0
      selectedPauseView.alpha   = 0.0
      unselectedPauseView.alpha = 0.0
    case .Pause:
      selectedStartView.alpha   = 0.0
      unselectedStartView.alpha = 0.0
      selectedPauseView.alpha   = 0.0
      unselectedPauseView.alpha = 1.0
    }
    
  }
  
  private func unhighlightWithFade() {
    selectedStartView.layer.removeAllAnimations()
    unselectedStartView.layer.removeAllAnimations()
    selectedPauseView.layer.removeAllAnimations()
    unselectedPauseView.layer.removeAllAnimations()
    UIView.animateWithDuration(unhighlightDuration) {
      self.unhighlight()
    }
  }
  
  public func unhighlightUsingBehavior(behavior: UnhighlightBehavior) {
    switch behavior {
    case .Instant:
      unhighlight()
    case .Fade:
      unhighlightWithFade()
    }
  }
  
  
}