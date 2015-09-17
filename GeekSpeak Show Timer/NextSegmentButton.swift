import UIKit

class NextSegmentButton: ShapesButton {

  var animationDuration     = NSTimeInterval(0.25)
  
  
  let darkRing1  = RingView()
  let darkRing2  = RingView()
  let darkRing3  = RingView()
  let lightRing1 = RingView()
  let lightRing2 = RingView()
  let lightRing3 = RingView()
  let container = SizeToSuperView()
  
  var rings: [RingView] {
    return darkRings + lightRings
  }
  
  var darkRings: [RingView] {
    return [darkRing1,darkRing2,darkRing3]
  }
  
  var lightRings: [RingView] {
    return [lightRing1,lightRing2,lightRing3]
  }
  
  
  // Button Shapes
  let arrow: SizableBezierPathFunc = { size in

    let minHeightWidth = min(size.height,size.width)
    
    func modifyPoint(x: CGFloat,y: CGFloat ) -> CGPoint {
      let scaleFactor = CGFloat(1.0)
      let diff = CGFloat(0)

      func m(p: CGFloat) -> CGFloat {
        let scaleP = p * scaleFactor
        let percent = scaleP / CGFloat(1000)
        return percent * minHeightWidth
      }
      
      return CGPointMake(m(x - 1) , m(y))
    }

    var bezierPath = UIBezierPath()

    
    let arrowPath = UIBezierPath()
    arrowPath.moveToPoint(   modifyPoint(500.5, y: 93.5))
    arrowPath.addLineToPoint(modifyPoint(500.5, y: 4.5))
    arrowPath.addLineToPoint(modifyPoint(739.5, y: 160.5))
    arrowPath.addLineToPoint(modifyPoint(500.5, y: 319.5))
    arrowPath.addLineToPoint(modifyPoint(500.5, y: 228.5))
    return arrowPath
  }
  
  
  let circle: SizableBezierPathFunc = { size in
    
    let minHeightWidth = min(size.height,size.width)
    func modifyPoint(x: CGFloat,y: CGFloat ) -> CGPoint {
      let scaleFactor = CGFloat(1.0)
      let diff = CGFloat(0)
      
      func m(p: CGFloat) -> CGFloat {
        let scaleP = p * scaleFactor
        let percent = scaleP / CGFloat(1000)
        return percent * minHeightWidth
      }
      
      return CGPointMake(m(x) , m(y))
    }
    

    let circlePath = UIBezierPath()
    circlePath.moveToPoint(    modifyPoint(501.5, y: 94.5))
    circlePath.addCurveToPoint(modifyPoint(94.5, y: 500.5),
                controlPoint1: modifyPoint(265.5, y: 94.5),
                controlPoint2: modifyPoint(94.5, y: 287.5))
    circlePath.addCurveToPoint(modifyPoint(501.5, y: 908.5),
                controlPoint1: modifyPoint(94.5, y: 713.5),
                controlPoint2: modifyPoint(266.5, y: 908.5))
    circlePath.addCurveToPoint(modifyPoint(906.5, y: 500.5),
                controlPoint1: modifyPoint(736.5, y: 908.5),
                controlPoint2: modifyPoint(906.5, y: 712.5))
    circlePath.addCurveToPoint(modifyPoint(773.5, y: 500.5),
                  controlPoint1: modifyPoint(862, y: 500.5),
                  controlPoint2: modifyPoint(835, y: 500.5))
    circlePath.addCurveToPoint(modifyPoint(501.5, y: 774.5),
                controlPoint1: modifyPoint(773.5, y: 640.5),
                controlPoint2: modifyPoint(662.5, y: 774.5))
    circlePath.addCurveToPoint(modifyPoint(227.5, y: 500.5),
                controlPoint1: modifyPoint(340.5, y: 774.5),
                controlPoint2: modifyPoint(227.5, y: 642.5))
    circlePath.addCurveToPoint(modifyPoint(500.5, y: 228.5),
                controlPoint1: modifyPoint(227.5, y: 358.5),
                controlPoint2: modifyPoint(343.5, y: 228.5))
    return circlePath
  }
  
  
  // MARK:
  // MARK: Initialization and setup
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    rings.forEach({$0.layer.setNeedsDisplay()})
  }
  
  func setup() {
    setupShapeView()
    setupRingViews()
  }
  
  
  func setupRingViews() {
    container.userInteractionEnabled = false
    rings.forEach({self.configureRing($0)})
    darkRings.forEach({ self.container.sendSubviewToBack($0) })
    darkRing1.percentageOfSuperviewSize  = 0.95
    lightRing1.percentageOfSuperviewSize = 0.95
    darkRing2.percentageOfSuperviewSize  = 0.64
    lightRing2.percentageOfSuperviewSize = 0.64
    darkRing3.percentageOfSuperviewSize  = 0.33
    lightRing3.percentageOfSuperviewSize = 0.33
    
    lightRing1.color = TimerViewController.Constants.GeekSpeakBlueColor
    lightRing2.color = TimerViewController.Constants.GeekSpeakBlueColor
    lightRing3.color = TimerViewController.Constants.GeekSpeakBlueColor
  }

  func configureRing(ringView: RingView) {
      ringView.userInteractionEnabled = false
      ringView.opaque    = false
      ringView.alpha     = 0.0
      let darkenBy       = TimerViewController.Constants.RingDarkeningFactor
      ringView.color     = TimerViewController.Constants.GeekSpeakBlueColor
                                            .darkenColorWithMultiplier(darkenBy)
      ringView.ringWidth = TimerViewController.Constants.LineWidth
      ringView.viewSize  = {[weak shapesView] in
                              if let shapesView = shapesView {
                                return min(shapesView.bounds.height,
                                           shapesView.bounds.width)
                              } else {
                                return .None
                              }
                            }
      container.addSubview(ringView)
  }
 
  
  
  func setupShapeView() {
    shapesView = ShapesView()
    
    let arrowShape = SizableBezierPath()
    arrowShape.pathForSize = arrow
    shapesView?.shapes.append(arrowShape)

    let circleShape = SizableBezierPath()
    circleShape.pathForSize = circle
    shapesView?.shapes.append(circleShape)

    if let shapesView = shapesView {
      insertSubview(container, belowSubview: shapesView)
    }
  }
  
  
  // MARK:
  // MARK: UIControl Methods
  override func beginTrackingWithTouch(touch: UITouch,
    withEvent event: UIEvent?) -> Bool {
      let superResult =  super.beginTrackingWithTouch(touch, withEvent: event)
      
      interuptAnimation()
      return superResult
  }
  
  override func cancelTrackingWithEvent(event: UIEvent?) {
    super.cancelTrackingWithEvent(event)
  }
  
  override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
    super.endTrackingWithTouch(touch, withEvent: event)
    if touchInside {
      animateRings()
    }
  }
  
  
  
  
  // MARK:
  // MARK:  Animation Methods
  private let phaseCount    =  NSTimeInterval(2)
  private let stepCount     =  NSTimeInterval(6)
  private let instant       =  NSTimeInterval(0.05)

  private var phaseDuration : NSTimeInterval {
    return (animationDuration / phaseCount)
  }
  private var stepDuration  : NSTimeInterval {
    return (animationDuration / stepCount) / phaseCount
  }

  
  func animateRings() {
//    darkRings.map( {$0.alpha = 1.0} )
    animationStep1()
   }
  
  
  func animationStep1() {
      UIView.animateWithDuration( instant,
                           delay: stepDuration,
                         options: [],
                      animations: {
                                    self.darkRing3.alpha = 1.0
                                  },
                      completion: { completed in
                                    self.animationStep2()
                                  })
  }
  
  func animationStep2() {
      UIView.animateWithDuration( instant,
                           delay: stepDuration,
                         options: [],
                      animations: {
                                    self.darkRing3.alpha = 0.0
                                  },
                      completion: { completed in
                                    self.animationStep3()
                                  })
  }
  
  func animationStep3() {
      UIView.animateWithDuration( instant,
                           delay: stepDuration,
                         options: [],
                      animations: {
                                    self.darkRing2.alpha = 1.0
                                  },
                      completion: { completed in
                                    self.animationStep4()
                                  })
  }
  
  func animationStep4() {
      UIView.animateWithDuration( instant,
                           delay: stepDuration,
                         options: [],
                      animations: {
                                    self.darkRing2.alpha = 0.0
                                  },
                      completion: { completed in
                                    self.animationStep5()
                                  })
  }
  
  func animationStep5() {
      UIView.animateWithDuration( instant,
                           delay: stepDuration,
                         options: [],
                      animations: {
                                    self.darkRing1.alpha = 1.0
                                  },
                      completion: { completed in
                                    self.animationStep6()
                                  })
  }
  
  func animationStep6() {
      UIView.animateWithDuration( instant,
                           delay: stepDuration,
                         options: [],
                      animations: {
                                    self.darkRing1.alpha = 0.0
                                  },
                      completion: { completed in
                                    self.animationFadeOut()
                                  })
  }
  
  func animationFadeOut() {
      UIView.animateWithDuration( phaseDuration,
                           delay: instant,
                         options: .CurveEaseOut,
                      animations: {
                                    self.rings.forEach( {$0.alpha = 0.0} )
                                  },
                      completion: { completed in
                                    self.rings.forEach( {$0.alpha = 0.0} )
                                  })
  }
  
  func interuptAnimation() {
    rings.forEach({$0.layer.removeAllAnimations()})
    rings.forEach({$0.alpha = 0.0} )
  }
  
}