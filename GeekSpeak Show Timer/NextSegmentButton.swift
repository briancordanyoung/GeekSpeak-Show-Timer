import UIKit

class NextSegmentButton: ShapesButton {
  
  // Button Shapes
  let arrow: SizableBezierPathFunc = { size in

    let minHeightWidth = min(size.height,size.width)
    
    func modifyPoint(x: CGFloat,y: CGFloat ) -> CGPoint {
      let scaleFactor = CGFloat(1.10)
      let diff = CGFloat(0)

      func m(p: CGFloat) -> CGFloat {
        let scaleP = p * scaleFactor
        let percent = scaleP / CGFloat(1000)
        return percent * minHeightWidth
      }
      
      return CGPointMake(m(x - 94) , m(y))
    }

    var bezierPath = UIBezierPath()

    
    let arrowPath = UIBezierPath()
    arrowPath.moveToPoint(   modifyPoint(500.5, 93.5))
    arrowPath.addLineToPoint(modifyPoint(500.5, 4.5))
    arrowPath.addLineToPoint(modifyPoint(739.5, 160.5))
    arrowPath.addLineToPoint(modifyPoint(500.5, 319.5))
    arrowPath.addLineToPoint(modifyPoint(500.5, 228.5))
    return arrowPath
  }
  
  
  let circle: SizableBezierPathFunc = { size in
    
    let minHeightWidth = min(size.height,size.width)
    func modifyPoint(x: CGFloat,y: CGFloat ) -> CGPoint {
      let scaleFactor = CGFloat(1.10)
      let diff = CGFloat(0)
      
      func m(p: CGFloat) -> CGFloat {
        let scaleP = p * scaleFactor
        let percent = scaleP / CGFloat(1000)
        return percent * minHeightWidth
      }
      
      return CGPointMake(m(x - 93) , m(y))
    }
    

    let circlePath = UIBezierPath()
    circlePath.moveToPoint(    modifyPoint(501.5, 94.5))
    circlePath.addCurveToPoint(modifyPoint(94.5, 500.5),
                controlPoint1: modifyPoint(265.5, 94.5),
                controlPoint2: modifyPoint(94.5, 287.5))
    circlePath.addCurveToPoint(modifyPoint(501.5, 908.5),
                controlPoint1: modifyPoint(94.5, 713.5),
                controlPoint2: modifyPoint(266.5, 908.5))
    circlePath.addCurveToPoint(modifyPoint(906.5, 500.5),
                controlPoint1: modifyPoint(736.5, 908.5),
                controlPoint2: modifyPoint(906.5, 712.5))
    circlePath.addCurveToPoint(modifyPoint(773.5, 500.5),
                  controlPoint1: modifyPoint(862, 500.5),
                  controlPoint2: modifyPoint(835, 500.5))
    circlePath.addCurveToPoint(modifyPoint(501.5, 774.5),
                controlPoint1: modifyPoint(773.5, 640.5),
                controlPoint2: modifyPoint(662.5, 774.5))
    circlePath.addCurveToPoint(modifyPoint(227.5, 500.5),
                controlPoint1: modifyPoint(340.5, 774.5),
                controlPoint2: modifyPoint(227.5, 642.5))
    circlePath.addCurveToPoint(modifyPoint(500.5, 228.5),
                controlPoint1: modifyPoint(227.5, 358.5),
                controlPoint2: modifyPoint(343.5, 228.5))
    return circlePath
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupShapeView()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupShapeView()
  }
  
  func setupRingViews() {
//    let ring1 = RingView()
  }
  
  func setupShapeView() {
    shapesView = ShapesView()
    
    let arrowShape = SizableBezierPath()
    arrowShape.pathForSize = arrow
    shapesView?.shapes.append(arrowShape)

    let circleShape = SizableBezierPath()
    circleShape.pathForSize = circle
    shapesView?.shapes.append(circleShape)

  }
  
}