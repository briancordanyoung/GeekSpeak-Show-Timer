import UIKit

// MARK: -
// MARK: NextShapes
prefix operator ✂️ {}

private prefix func ✂️(n: CGFloat) -> CGFloat {
  return n * 0.75
}


final class NextShapes: NSObject {
class func rightBezier() -> UIBezierPath {
  let rightBezier = UIBezierPath()
  rightBezier.moveToPoint(     CGPointMake( ✂️50.5 , ✂️19.5 ))
  rightBezier.addCurveToPoint( CGPointMake( ✂️51   , ✂️78   ),
                controlPoint1: CGPointMake( ✂️50.51, ✂️20.99),
                controlPoint2: CGPointMake( ✂️51.03, ✂️76.53))
  rightBezier.addCurveToPoint( CGPointMake( ✂️53   , ✂️80   ),
                controlPoint1: CGPointMake( ✂️50.97, ✂️79.47),
                controlPoint2: CGPointMake( ✂️51.91, ✂️80.7 ))
  rightBezier.addCurveToPoint( CGPointMake( ✂️99   , ✂️50   ),
                controlPoint1: CGPointMake( ✂️54.09, ✂️79.3 ),
                controlPoint2: CGPointMake( ✂️98.18, ✂️50.54))
  rightBezier.addCurveToPoint( CGPointMake( ✂️99   , ✂️48   ),
                controlPoint1: CGPointMake( ✂️99.82, ✂️49.46),
                controlPoint2: CGPointMake( ✂️99.9 , ✂️48.59))
  rightBezier.addCurveToPoint( CGPointMake( ✂️53   , ✂️18   ),
                controlPoint1: CGPointMake( ✂️98.1 , ✂️47.41),
                controlPoint2: CGPointMake( ✂️54.29, ✂️18.76))
  rightBezier.addCurveToPoint( CGPointMake( ✂️50.5 , ✂️19.5 ),
                controlPoint1: CGPointMake( ✂️51.71, ✂️17.24),
                controlPoint2: CGPointMake( ✂️50.49, ✂️18.01))
  rightBezier.closePath()
  return rightBezier
}
  
  
final class func leftBezier() -> UIBezierPath {
  let leftBezier = UIBezierPath()
  leftBezier.moveToPoint(     CGPointMake(  ✂️0.5 , ✂️19.5 ))
  leftBezier.addCurveToPoint( CGPointMake(  ✂️1   , ✂️78   ),
               controlPoint1: CGPointMake(  ✂️0.51, ✂️20.99),
               controlPoint2: CGPointMake(  ✂️1.03, ✂️76.53))
  leftBezier.addCurveToPoint( CGPointMake(  ✂️3   , ✂️80   ),
               controlPoint1: CGPointMake(  ✂️0.97, ✂️79.47),
               controlPoint2: CGPointMake(  ✂️1.91, ✂️80.7 ))
  leftBezier.addCurveToPoint( CGPointMake( ✂️49   , ✂️50   ),
               controlPoint1: CGPointMake(  ✂️4.09, ✂️79.3 ),
               controlPoint2: CGPointMake( ✂️48.18, ✂️50.54))
  leftBezier.addCurveToPoint( CGPointMake( ✂️49   , ✂️48   ),
               controlPoint1: CGPointMake( ✂️49.82, ✂️49.46),
               controlPoint2: CGPointMake( ✂️49.9 , ✂️48.59))
  leftBezier.addCurveToPoint( CGPointMake(  ✂️3   , ✂️18   ),
               controlPoint1: CGPointMake( ✂️48.1 , ✂️47.41),
               controlPoint2: CGPointMake(  ✂️4.29, ✂️18.76))
  leftBezier.addCurveToPoint( CGPointMake(  ✂️0.5 , ✂️19.5 ),
               controlPoint1: CGPointMake(  ✂️1.71, ✂️17.24),
               controlPoint2: CGPointMake(  ✂️0.49, ✂️18.01))
  leftBezier.closePath()
    return leftBezier
  }

}

// MARK: -
// MARK: StartPauseShapes

final class StartPauseShapes: NSObject {
  
  class func startBezier() -> UIBezierPath {
    let startBezier = UIBezierPath()
    startBezier.moveToPoint(     CGPointMake( ✂️25.5 , ✂️19.5 ))
    startBezier.addCurveToPoint( CGPointMake( ✂️26   , ✂️78   ),
                  controlPoint1: CGPointMake( ✂️25.51, ✂️20.99),
                  controlPoint2: CGPointMake( ✂️26.03, ✂️76.53))
    startBezier.addCurveToPoint( CGPointMake( ✂️28   , ✂️80   ),
                  controlPoint1: CGPointMake( ✂️25.97, ✂️79.47),
                  controlPoint2: CGPointMake( ✂️26.91, ✂️80.7 ))
    startBezier.addCurveToPoint( CGPointMake( ✂️74   , ✂️50   ),
                  controlPoint1: CGPointMake( ✂️29.09, ✂️79.3 ),
                  controlPoint2: CGPointMake( ✂️73.18, ✂️50.54))
    startBezier.addCurveToPoint( CGPointMake( ✂️74   , ✂️48   ),
                  controlPoint1: CGPointMake( ✂️74.82, ✂️49.46),
                  controlPoint2: CGPointMake( ✂️74.9 , ✂️48.59))
    startBezier.addCurveToPoint( CGPointMake( ✂️28   , ✂️18   ),
                  controlPoint1: CGPointMake( ✂️73.1 , ✂️47.41),
                  controlPoint2: CGPointMake( ✂️29.29, ✂️18.76))
    startBezier.addCurveToPoint( CGPointMake( ✂️25.5 , ✂️19.5 ),
                  controlPoint1: CGPointMake( ✂️26.71, ✂️17.24),
                  controlPoint2: CGPointMake( ✂️25.49, ✂️18.01))
    startBezier.closePath()
    return startBezier
  }
  
  
  
  class func pointMakeAndScale(x: CGFloat,_ y:CGFloat) -> CGPoint {
    let scaleFactor = CGFloat(0.7)
    let xx = ((x - 50) * scaleFactor) + 50
    let yy = ((y - 50) * scaleFactor) + 50
    return CGPointMake( ✂️xx, ✂️yy)
  }
  
  class func rightPauseBezier() -> UIBezierPath {
    let rightPauseBezier = UIBezierPath()
    rightPauseBezier.moveToPoint(      pointMakeAndScale( 64.01,  0.31))
    rightPauseBezier.addCurveToPoint(  pointMakeAndScale( 61.43,  2.57),
                        controlPoint1: pointMakeAndScale( 62.05,  0.31),
                        controlPoint2: pointMakeAndScale( 61.43,  1.46))
    rightPauseBezier.addCurveToPoint(  pointMakeAndScale( 61.43,  97.04),
                        controlPoint1: pointMakeAndScale( 61.43,  3.68),
                        controlPoint2: pointMakeAndScale( 61.43,  95.16))
    rightPauseBezier.addCurveToPoint(  pointMakeAndScale( 63.95,  99.26),
                        controlPoint1: pointMakeAndScale( 61.43,  98.92),
                        controlPoint2: pointMakeAndScale( 62.08,  99.26))
    rightPauseBezier.addCurveToPoint(  pointMakeAndScale( 84.12,  99.26),
                        controlPoint1: pointMakeAndScale( 65.82,  99.26),
                        controlPoint2: pointMakeAndScale( 82.22,  99.26))
    rightPauseBezier.addCurveToPoint(  pointMakeAndScale( 86.61,  96.76),
                        controlPoint1: pointMakeAndScale( 86.01,  99.26),
                        controlPoint2: pointMakeAndScale( 86.61,  98.91))
    rightPauseBezier.addCurveToPoint(  pointMakeAndScale( 86.61,  3.54),
                        controlPoint1: pointMakeAndScale( 86.61,  94.62),
                        controlPoint2: pointMakeAndScale( 86.61,  5.57))
    rightPauseBezier.addCurveToPoint(  pointMakeAndScale( 84.17,  0.29),
                        controlPoint1: pointMakeAndScale( 86.61,  1.5),
                        controlPoint2: pointMakeAndScale( 86.48,  0.29))
    rightPauseBezier.addCurveToPoint(  pointMakeAndScale( 64.01,  0.31),
                        controlPoint1: pointMakeAndScale( 81.85,  0.29),
                        controlPoint2: pointMakeAndScale( 65.97,  0.31))
    rightPauseBezier.closePath()
    return rightPauseBezier
  }
  
  
  

  class func leftPauseBezier() -> UIBezierPath {
    let leftPauseBezier = UIBezierPath()
    leftPauseBezier.moveToPoint(     pointMakeAndScale( 14.01,  0.31))
    leftPauseBezier.addCurveToPoint( pointMakeAndScale( 11.43,  2.57),
                      controlPoint1: pointMakeAndScale( 12.05,  0.31),
                      controlPoint2: pointMakeAndScale( 11.43,  1.46))
    leftPauseBezier.addCurveToPoint( pointMakeAndScale( 11.43,  97.04),
                      controlPoint1: pointMakeAndScale( 11.43,  3.68),
                      controlPoint2: pointMakeAndScale( 11.43,  95.16))
    leftPauseBezier.addCurveToPoint( pointMakeAndScale( 13.95,  99.26),
                      controlPoint1: pointMakeAndScale( 11.43,  98.92),
                      controlPoint2: pointMakeAndScale( 12.08,  99.26))
    leftPauseBezier.addCurveToPoint( pointMakeAndScale( 34.12,  99.26),
                      controlPoint1: pointMakeAndScale( 15.82,  99.26),
                      controlPoint2: pointMakeAndScale( 32.22,  99.26))
    leftPauseBezier.addCurveToPoint( pointMakeAndScale( 36.61,  96.76),
                      controlPoint1: pointMakeAndScale( 36.01,  99.26),
                      controlPoint2: pointMakeAndScale( 36.61,  98.91))
    leftPauseBezier.addCurveToPoint( pointMakeAndScale( 36.61,  3.54),
                      controlPoint1: pointMakeAndScale( 36.61,  94.62),
                      controlPoint2: pointMakeAndScale( 36.61,  5.57))
    leftPauseBezier.addCurveToPoint( pointMakeAndScale( 34.17,  0.29),
                      controlPoint1: pointMakeAndScale( 36.61,  1.5),
                      controlPoint2: pointMakeAndScale( 36.48,  0.29))
    leftPauseBezier.addCurveToPoint( pointMakeAndScale( 14.01,  0.31),
                      controlPoint1: pointMakeAndScale( 31.85,  0.29),
                      controlPoint2: pointMakeAndScale( 15.97,  0.31))
    leftPauseBezier.closePath()
    return leftPauseBezier
  }
  
}
