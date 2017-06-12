import UIKit


// MARK: -
// MARK: UnselectedNextView

final class UnselectedNextView: ControlsView {
  override func draw(_ rect: CGRect) {
    color.setStroke()
    NextShapes.rightBezier().stroke()
    NextShapes.leftBezier().stroke()
  }
}


// MARK: -
// MARK: SelectedNextView

final class SelectedNextView: ControlsView {
  override func draw(_ rect: CGRect) {
    color.setFill()
    NextShapes.rightBezier().fill()
    NextShapes.leftBezier().fill()
  }
}



// MARK: -
// MARK: NextView

final public class NextView: UIStackView {
  
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
  
  
  
  public var highlightColor = UIColor.white {
    didSet(oldColor) {
      selectedView.color = highlightColor
    }
  }
  
  public override var tintColor: UIColor! {
    didSet(oldColor) {
      unselectedView.color = tintColor
    }
  }
  
  
  // The highlight state is derived from the current alpha of the 2 views.
  public var highlighted: highlightState {
    let   selected = unselectedView.alpha == 0.0
    let unselected =   selectedView.alpha == 0.0
    
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
  fileprivate let unselectedView  = UnselectedNextView(frame: CGRect(x:0, y:0,
                                   width: Appearance.Constants.ButtonDimension,
                                  height: Appearance.Constants.ButtonDimension))
  fileprivate let selectedView    = SelectedNextView(frame: CGRect(x:0, y:0,
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
  
  fileprivate func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
    axis          = .vertical
    alignment     = .center
    distribution  = .fill
    spacing       = CGFloat(5)
    addArrangedSubview(symbolContainer)
    addArrangedSubview(label)

    symbolContainer.translatesAutoresizingMaskIntoConstraints = false
    symbolContainer.heightAnchor
                             .constraint(equalToConstant: dimention).isActive = true
    symbolContainer.widthAnchor
                            .constraint(equalToConstant: dimention).isActive  = true
    symbolContainer.isOpaque = false

    symbolContainer.addSubview(unselectedView)
    symbolContainer.addSubview(selectedView)
    
    selectedView.color   = highlightColor
    unselectedView.color = tintColor
    unhighlight()
    
    
    label.text = "Next Section"
    label.textColor = tintColor
    if let font = UIFont(name: Appearance.Constants.ButtonTextFont,
                         size: Appearance.Constants.ButtonTextFontSize) {
      label.font = font
    }
  }
  
  
  
  
  // MARK: -
  // MARK: Actions
  public func highlight() {
    selectedView.alpha   = 1.0
    unselectedView.alpha = 0.0
  }
  
  public func unhighlight() {
    selectedView.alpha   = 0.0
    unselectedView.alpha = 1.0
  }

  fileprivate func unhighlightWithFade() {
    selectedView.layer.removeAllAnimations()
    unselectedView.layer.removeAllAnimations()
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
