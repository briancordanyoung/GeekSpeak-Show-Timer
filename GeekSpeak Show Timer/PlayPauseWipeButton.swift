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
  
  
  // Button Shapes
  let playShape: SizableBezierPathFunc = { size in
    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    return UIBezierPath(roundedRect: rect, cornerRadius: size.height / 8)
  }
  
  let pauseShape: SizableBezierPathFunc = { size in
    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    return UIBezierPath(roundedRect: rect, cornerRadius: size.height / 3)
  }

  func showPlayView() {
    showViewA()
  }
  
  func showPauseView() {
    showViewB()
  }
  
  func animateToPlayView() {
    animateToViewA()
  }

  func animateToPauseView() {
    animateToViewB()
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
    pauseButtonView = ShapesView()
    let pauseButtonShape = SizableBezierPath()
    pauseButtonShape.pathForSize = pauseShape
    pauseButtonView?.shapes.append(pauseButtonShape)
    
    playButtonView = ShapesView()
    let playButtonShape = SizableBezierPath()
    playButtonShape.pathForSize = playShape
    playButtonView?.shapes.append(playButtonShape)
    
    showViewA()
  }

}