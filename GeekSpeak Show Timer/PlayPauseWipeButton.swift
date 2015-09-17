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

    let minHeightWidth = min(size.height,size.width)
    
    func m(p: CGFloat) -> CGFloat {
      let percent = p / CGFloat(1000)
      return percent * minHeightWidth
    }
    
    var x = CGFloat(526.04 + 20)
    var y = CGFloat(475.72)
    var bezierPath = UIBezierPath()
    
    bezierPath.moveToPoint(CGPointMake(    m( 430.84 + x), m(-36.03  + y)))
    bezierPath.addLineToPoint(CGPointMake( m(-438.12 + x), m(-448.77 + y)))
    bezierPath.addCurveToPoint(CGPointMake(m(-473    + x), m(-441.42 + y)),
              controlPoint1: CGPointMake(  m(-438.12 + x), m(-448.77 + y)),
              controlPoint2: CGPointMake(  m(-455.62 + x), m(-455.06 + y)))
    bezierPath.addCurveToPoint(CGPointMake(m(-487.94 + x), m(-409.96 + y)),
              controlPoint1: CGPointMake(  m(-490.38 + x), m(-427.79 + y)),
              controlPoint2: CGPointMake(  m(-487.94 + x), m(-409.96 + y)))
    bezierPath.addLineToPoint(CGPointMake( m(-488.48 + x), m(457.66  + y)))
    bezierPath.addCurveToPoint(CGPointMake(m(-473    + x), m(489.62  + y)),
              controlPoint1: CGPointMake(  m(-488.48 + x), m(457.66  + y) ),
              controlPoint2: CGPointMake(  m(-490.38 + x), m(475.98  + y)))
    bezierPath.addCurveToPoint(CGPointMake(m(-438.7  + x), m(493.22  + y)),
              controlPoint1: CGPointMake(  m(-455.62 + x), m(503.26  + y)),
              controlPoint2: CGPointMake(  m(-438.7  + x), m(493.22  + y)))
    bezierPath.addLineToPoint(CGPointMake( m( 430.65 + x), m(38.32   + y)))
    bezierPath.addCurveToPoint(CGPointMake(m( 449.46 + x), m(-0.08   + y)),
              controlPoint1: CGPointMake(  m( 430.65 + x), m(38.32   + y)),
              controlPoint2: CGPointMake(  m( 449.46 + x), m(27.2    + y)))
    bezierPath.addCurveToPoint(CGPointMake(m( 430.84 + x), m(-36.03  + y)),
              controlPoint1: CGPointMake(  m( 449.46 + x), m(-27.35  + y)),
              controlPoint2: CGPointMake(  m( 430.84 + x), m(-36.03  + y)))
    bezierPath.closePath()
    return bezierPath
  }
  
  let pauseShapeLeft: SizableBezierPathFunc = { size in
    let minHeightWidth = min(size.height,size.width)
    
    func m(p: CGFloat) -> CGFloat {
      return (p / CGFloat(1000)) * minHeightWidth
    }
    
    var x = CGFloat(-20)
    var y = CGFloat(0.0)
    
    let bezierPath = UIBezierPath()
    
    bezierPath.moveToPoint(    CGPointMake( m( 375.5 + x), m(   24.5 + y)))
    bezierPath.addLineToPoint( CGPointMake( m( 125.5 + x), m(   24.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 72.5 + x), m(    47.5 + y)),
                controlPoint1: CGPointMake( m( 125.5 + x), m(   24.5 + y)),
                controlPoint2: CGPointMake( m( 94.5 + x), m(    25.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 50.5 + x), m(    99.5 + y)),
                controlPoint1: CGPointMake( m( 50.5 + x), m(    69.5 + y)),
                controlPoint2: CGPointMake( m( 50.5 + x), m(    99.5 + y)))
    bezierPath.addLineToPoint( CGPointMake( m( 50.5 + x), m(   899.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 72.5 + x), m(   951.5 + y)),
                controlPoint1: CGPointMake( m( 50.5 + x), m(   899.5 + y)),
                controlPoint2: CGPointMake( m( 49.5 + x), m(   927.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 125.5 + x), m(  974.5 + y)),
                controlPoint1: CGPointMake( m( 95.5 + x), m(   975.5 + y)),
                controlPoint2: CGPointMake( m( 125.5 + x), m(  974.5 + y)))
    bezierPath.addLineToPoint( CGPointMake( m( 375.5 + x), m(  974.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 427.5 + x), m(  951.5 + y)),
                controlPoint1: CGPointMake( m( 375.5 + x), m(  974.5 + y)),
                controlPoint2: CGPointMake( m( 403.5 + x), m(  975.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 449.5 + x), m(  899.5 + y)),
                controlPoint1: CGPointMake( m( 451.5 + x), m(  927.5 + y)),
                controlPoint2: CGPointMake( m( 449.5 + x), m(  899.5 + y)))
    bezierPath.addLineToPoint( CGPointMake( m( 449.5 + x), m(   99.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 427.5 + x), m(   47.5 + y)),
                controlPoint1: CGPointMake( m( 449.5 + x), m(   99.5 + y)),
                controlPoint2: CGPointMake( m( 449.5 + x), m(   70.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 375.5 + x), m(   24.5 + y)),
                controlPoint1: CGPointMake( m( 405.5 + x), m(   24.5 + y)),
                controlPoint2: CGPointMake( m( 375.5 + x), m(   24.5 + y)))
    bezierPath.closePath()
    return bezierPath
  }

  let pauseShapeRight: SizableBezierPathFunc = { size in
    let minHeightWidth = min(size.height,size.width)
    
    func m(p: CGFloat) -> CGFloat {
      let percent = abs((p / CGFloat(1000)) - 1)
      return percent * minHeightWidth
    }
    
    var x = CGFloat(-20)
    var y = CGFloat(0.0)
    
    let bezierPath = UIBezierPath()
    
    bezierPath.moveToPoint(    CGPointMake( m( 375.5 + x), m(   24.5 + y)))
    bezierPath.addLineToPoint( CGPointMake( m( 125.5 + x), m(   24.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 72.5 + x), m(    47.5 + y)),
                controlPoint1: CGPointMake( m( 125.5 + x), m(   24.5 + y)),
                controlPoint2: CGPointMake( m( 94.5 + x), m(    25.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 50.5 + x), m(    99.5 + y)),
                controlPoint1: CGPointMake( m( 50.5 + x), m(    69.5 + y)),
                controlPoint2: CGPointMake( m( 50.5 + x), m(    99.5 + y)))
    bezierPath.addLineToPoint( CGPointMake( m( 50.5 + x), m(   899.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 72.5 + x), m(   951.5 + y)),
                controlPoint1: CGPointMake( m( 50.5 + x), m(   899.5 + y)),
                controlPoint2: CGPointMake( m( 49.5 + x), m(   927.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 125.5 + x), m(  974.5 + y)),
                controlPoint1: CGPointMake( m( 95.5 + x), m(   975.5 + y)),
                controlPoint2: CGPointMake( m( 125.5 + x), m(  974.5 + y)))
    bezierPath.addLineToPoint( CGPointMake( m( 375.5 + x), m(  974.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 427.5 + x), m(  951.5 + y)),
                controlPoint1: CGPointMake( m( 375.5 + x), m(  974.5 + y)),
                controlPoint2: CGPointMake( m( 403.5 + x), m(  975.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 449.5 + x), m(  899.5 + y)),
                controlPoint1: CGPointMake( m( 451.5 + x), m(  927.5 + y)),
                controlPoint2: CGPointMake( m( 449.5 + x), m(  899.5 + y)))
    bezierPath.addLineToPoint( CGPointMake( m( 449.5 + x), m(   99.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 427.5 + x), m(   47.5 + y)),
                controlPoint1: CGPointMake( m( 449.5 + x), m(   99.5 + y)),
                controlPoint2: CGPointMake( m( 449.5 + x), m(   70.5 + y)))
    bezierPath.addCurveToPoint(CGPointMake( m( 375.5 + x), m(   24.5 + y)),
                controlPoint1: CGPointMake( m( 405.5 + x), m(   24.5 + y)),
                controlPoint2: CGPointMake( m( 375.5 + x), m(   24.5 + y)))
    bezierPath.closePath()
    return bezierPath
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
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupPlayPauseView()
  }

  func setupPlayPauseView() {
    pauseButtonView = ShapesView()
    let pauseButtonLeftShape = SizableBezierPath()
    pauseButtonLeftShape.pathForSize = pauseShapeLeft
    pauseButtonView?.shapes.append(pauseButtonLeftShape)

    let pauseButtonRightShape = SizableBezierPath()
    pauseButtonRightShape.pathForSize = pauseShapeRight
    pauseButtonView?.shapes.append(pauseButtonRightShape)

    playButtonView = ShapesView()
    let playButtonShape = SizableBezierPath()
    playButtonShape.pathForSize = playShape
    playButtonView?.shapes.append(playButtonShape)
    
    showViewA()
  }

}