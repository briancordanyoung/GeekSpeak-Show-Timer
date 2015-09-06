import UIKit

class PlayPauseButton: TimeWipeButton {
  enum VisibleButtonView {
    case Play
    case Pause
  }
  
  var playButtonView: ShapesView? {
    get {
      return viewA
    }
    set(newPlayButtonView) {
      viewA = newPlayButtonView
    }
  }
  
  var pauseButtonView: ShapesView? {
    get {
      return viewB
    }
    set(newPauseButtonView) {
      viewB = newPauseButtonView
    }
  }
  
  var visibleButtonView: VisibleButtonView {
    get {
      switch viewVisible {
      case .ViewA:
        return .Play
      case .ViewB:
        return .Pause
      }
    }
    
    set(newButtonView) {
      switch newButtonView {
      case .Play:
        viewVisible = .ViewA
      case .Pause:
        viewVisible = .ViewB
      }
    }
  }
  
  
  // Button Shapes
  let playShape: SizableBezierPathFunc = { size in
    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    return UIBezierPath(roundedRect: rect, cornerRadius: size.height / 8)
  }
  
  let pauseShape: SizableBezierPathFunc = { size in
    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    return UIBezierPath(roundedRect: rect, cornerRadius: size.height / 3)
  }

  
  

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupPlayPauseView()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupPlayPauseView()
  }

  func setupPlayPauseView() {
    playButtonView = ShapesView()
    let playButtonShape = SizableBezierPath()
    playButtonShape.pathForSize = playShape
    playButtonView?.shapes.append(playButtonShape)
    
    
    pauseButtonView = ShapesView()
    let pauseButtonShape = SizableBezierPath()
    pauseButtonShape.pathForSize = pauseShape
    pauseButtonView?.shapes.append(pauseButtonShape)
  }

}