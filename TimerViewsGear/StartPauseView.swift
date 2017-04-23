import UIKit

// MARK: -
// MARK: UnselectedStartView

final class UnselectedStartView: ControlsView {
  override func draw(_ rect: CGRect) {
    color.setStroke()
    StartPauseShapes.startBezier().stroke()
  }
}


// MARK: -
// MARK: SelectedStartView

final class SelectedStartView: ControlsView {
  override func draw(_ rect: CGRect) {
    color.setFill()
    StartPauseShapes.startBezier().fill()
  }
  
}

// MARK: -
// MARK: UnselectedPauseView

final class UnselectedPauseView: ControlsView {
  override func draw(_ rect: CGRect) {
    color.setStroke()
    StartPauseShapes.leftPauseBezier().stroke()
    StartPauseShapes.rightPauseBezier().stroke()
  }
}


// MARK: -
// MARK: SelectedPauseView

final class SelectedPauseView: ControlsView {
  override func draw(_ rect: CGRect) {
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
    case instant
    case fade
  }
  
  public enum highlightState {
    case highlighted
    case unhighlighted
    case transitioning
  }
  
  public enum ButtonState {
    case start
    case pause
  }
  
  public var currentButton = ButtonState.start
  
  public var highlightColor = UIColor.white {
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
      return .unhighlighted
    case (false,true):
      return .highlighted
    case (_,_):
      return .transitioning
    }
  }
  
  public let label = UILabel()
  
  fileprivate let dimention = Appearance.Constants.ButtonDimension
  fileprivate let symbolContainer = UIView()
  fileprivate let unselectedStartView  = UnselectedStartView(frame: CGRect(x:0, y:0,
                                   width: Appearance.Constants.ButtonDimension,
                                  height: Appearance.Constants.ButtonDimension))
  fileprivate let selectedStartView    = SelectedStartView(frame: CGRect(x:0, y:0,
                                   width: Appearance.Constants.ButtonDimension,
                                  height: Appearance.Constants.ButtonDimension))
  
  fileprivate let unselectedPauseView  = UnselectedPauseView(frame: CGRect(x:0, y:0,
                                   width: Appearance.Constants.ButtonDimension,
                                  height: Appearance.Constants.ButtonDimension))
  fileprivate let selectedPauseView    = SelectedPauseView(frame: CGRect(x:0, y:0,
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
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

  func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
    axis          = .vertical
    alignment     = .center
    distribution  = .fill
    spacing       = CGFloat(5)
    addArrangedSubview(symbolContainer)
    addArrangedSubview(label)
    
    symbolContainer.translatesAutoresizingMaskIntoConstraints = false
    symbolContainer.heightAnchor.constraint(equalToConstant: dimention).isActive = true
    symbolContainer.widthAnchor.constraint(equalToConstant: dimention).isActive  = true
    symbolContainer.isOpaque = false
    
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
    if let font = UIFont(name: Appearance.Constants.ButtonTextFont,
                         size: Appearance.Constants.ButtonTextFontSize) {
      label.font = font
    }
  }
  
  
  
  
  // MARK: -
  // MARK: Actions
  public func highlight() {
    switch currentButton {
      case .start:
        selectedStartView.alpha   = 1.0
        unselectedStartView.alpha = 0.0
        selectedPauseView.alpha   = 0.0
        unselectedPauseView.alpha = 0.0
      case .pause:
        selectedStartView.alpha   = 0.0
        unselectedStartView.alpha = 0.0
        selectedPauseView.alpha   = 1.0
        unselectedPauseView.alpha = 0.0
    }
  }
  
  public func unhighlight() {
    switch currentButton {
    case .start:
      selectedStartView.alpha   = 0.0
      unselectedStartView.alpha = 1.0
      selectedPauseView.alpha   = 0.0
      unselectedPauseView.alpha = 0.0
    case .pause:
      selectedStartView.alpha   = 0.0
      unselectedStartView.alpha = 0.0
      selectedPauseView.alpha   = 0.0
      unselectedPauseView.alpha = 1.0
    }
    
  }
  
  fileprivate func unhighlightWithFade() {
    selectedStartView.layer.removeAllAnimations()
    unselectedStartView.layer.removeAllAnimations()
    selectedPauseView.layer.removeAllAnimations()
    unselectedPauseView.layer.removeAllAnimations()
    UIView.animate(withDuration: unhighlightDuration, animations: {
      self.unhighlight()
    }) 
  }
  
  public func unhighlightUsingBehavior(_ behavior: UnhighlightBehavior) {
    switch behavior {
    case .instant:
      unhighlight()
    case .fade:
      unhighlightWithFade()
    }
  }
  
  
}
