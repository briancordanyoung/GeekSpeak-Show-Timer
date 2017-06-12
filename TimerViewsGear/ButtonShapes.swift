import UIKit

// MARK: -
// MARK: NextShapes
prefix operator ✂️

private prefix func ✂️(n: CGFloat) -> CGFloat {
  return n * 0.75
}


final class NextShapes: NSObject {
class func rightBezier() -> UIBezierPath {
  let rightBezier = UIBezierPath()
  rightBezier.move(     to: CGPoint( x: ✂️50.5 , y: ✂️19.5 ))
  rightBezier.addCurve( to: CGPoint( x: ✂️51   , y: ✂️78   ),
                controlPoint1: CGPoint( x: ✂️50.51, y: ✂️20.99),
                controlPoint2: CGPoint( x: ✂️51.03, y: ✂️76.53))
  rightBezier.addCurve( to: CGPoint( x: ✂️53   , y: ✂️80   ),
                controlPoint1: CGPoint( x: ✂️50.97, y: ✂️79.47),
                controlPoint2: CGPoint( x: ✂️51.91, y: ✂️80.7 ))
  rightBezier.addCurve( to: CGPoint( x: ✂️99   , y: ✂️50   ),
                controlPoint1: CGPoint( x: ✂️54.09, y: ✂️79.3 ),
                controlPoint2: CGPoint( x: ✂️98.18, y: ✂️50.54))
  rightBezier.addCurve( to: CGPoint( x: ✂️99   , y: ✂️48   ),
                controlPoint1: CGPoint( x: ✂️99.82, y: ✂️49.46),
                controlPoint2: CGPoint( x: ✂️99.9 , y: ✂️48.59))
  rightBezier.addCurve( to: CGPoint( x: ✂️53   , y: ✂️18   ),
                controlPoint1: CGPoint( x: ✂️98.1 , y: ✂️47.41),
                controlPoint2: CGPoint( x: ✂️54.29, y: ✂️18.76))
  rightBezier.addCurve( to: CGPoint( x: ✂️50.5 , y: ✂️19.5 ),
                controlPoint1: CGPoint( x: ✂️51.71, y: ✂️17.24),
                controlPoint2: CGPoint( x: ✂️50.49, y: ✂️18.01))
  rightBezier.close()
  return rightBezier
}
  
  
final class func leftBezier() -> UIBezierPath {
  let leftBezier = UIBezierPath()
  leftBezier.move(     to: CGPoint(  x: ✂️0.5 , y: ✂️19.5 ))
  leftBezier.addCurve( to: CGPoint(  x: ✂️1   , y: ✂️78   ),
               controlPoint1: CGPoint(  x: ✂️0.51, y: ✂️20.99),
               controlPoint2: CGPoint(  x: ✂️1.03, y: ✂️76.53))
  leftBezier.addCurve( to: CGPoint(  x: ✂️3   , y: ✂️80   ),
               controlPoint1: CGPoint(  x: ✂️0.97, y: ✂️79.47),
               controlPoint2: CGPoint(  x: ✂️1.91, y: ✂️80.7 ))
  leftBezier.addCurve( to: CGPoint( x: ✂️49   , y: ✂️50   ),
               controlPoint1: CGPoint(  x: ✂️4.09, y: ✂️79.3 ),
               controlPoint2: CGPoint( x: ✂️48.18, y: ✂️50.54))
  leftBezier.addCurve( to: CGPoint( x: ✂️49   , y: ✂️48   ),
               controlPoint1: CGPoint( x: ✂️49.82, y: ✂️49.46),
               controlPoint2: CGPoint( x: ✂️49.9 , y: ✂️48.59))
  leftBezier.addCurve( to: CGPoint(  x: ✂️3   , y: ✂️18   ),
               controlPoint1: CGPoint( x: ✂️48.1 , y: ✂️47.41),
               controlPoint2: CGPoint(  x: ✂️4.29, y: ✂️18.76))
  leftBezier.addCurve( to: CGPoint(  x: ✂️0.5 , y: ✂️19.5 ),
               controlPoint1: CGPoint(  x: ✂️1.71, y: ✂️17.24),
               controlPoint2: CGPoint(  x: ✂️0.49, y: ✂️18.01))
  leftBezier.close()
    return leftBezier
  }

}

// MARK: -
// MARK: StartPauseShapes

final class StartPauseShapes: NSObject {
  
  class func startBezier() -> UIBezierPath {
    let startBezier = UIBezierPath()
    startBezier.move(     to: CGPoint( x: ✂️25.5 , y: ✂️19.5 ))
    startBezier.addCurve( to: CGPoint( x: ✂️26   , y: ✂️78   ),
                  controlPoint1: CGPoint( x: ✂️25.51, y: ✂️20.99),
                  controlPoint2: CGPoint( x: ✂️26.03, y: ✂️76.53))
    startBezier.addCurve( to: CGPoint( x: ✂️28   , y: ✂️80   ),
                  controlPoint1: CGPoint( x: ✂️25.97, y: ✂️79.47),
                  controlPoint2: CGPoint( x: ✂️26.91, y: ✂️80.7 ))
    startBezier.addCurve( to: CGPoint( x: ✂️74   , y: ✂️50   ),
                  controlPoint1: CGPoint( x: ✂️29.09, y: ✂️79.3 ),
                  controlPoint2: CGPoint( x: ✂️73.18, y: ✂️50.54))
    startBezier.addCurve( to: CGPoint( x: ✂️74   , y: ✂️48   ),
                  controlPoint1: CGPoint( x: ✂️74.82, y: ✂️49.46),
                  controlPoint2: CGPoint( x: ✂️74.9 , y: ✂️48.59))
    startBezier.addCurve( to: CGPoint( x: ✂️28   , y: ✂️18   ),
                  controlPoint1: CGPoint( x: ✂️73.1 , y: ✂️47.41),
                  controlPoint2: CGPoint( x: ✂️29.29, y: ✂️18.76))
    startBezier.addCurve( to: CGPoint( x: ✂️25.5 , y: ✂️19.5 ),
                  controlPoint1: CGPoint( x: ✂️26.71, y: ✂️17.24),
                  controlPoint2: CGPoint( x: ✂️25.49, y: ✂️18.01))
    startBezier.close()
    return startBezier
  }
  
  
  
  class func pointMakeAndScale(_ x: CGFloat,_ y:CGFloat) -> CGPoint {
    let scaleFactor = CGFloat(0.7)
    let xx = ((x - 50) * scaleFactor) + 50
    let yy = ((y - 50) * scaleFactor) + 50
    return CGPoint( x: ✂️xx, y: ✂️yy)
  }
  
  class func rightPauseBezier() -> UIBezierPath {
    let rightPauseBezier = UIBezierPath()
    rightPauseBezier.move(      to: pointMakeAndScale( 64.01,  0.31))
    rightPauseBezier.addCurve(  to: pointMakeAndScale( 61.43,  2.57),
                        controlPoint1: pointMakeAndScale( 62.05,  0.31),
                        controlPoint2: pointMakeAndScale( 61.43,  1.46))
    rightPauseBezier.addCurve(  to: pointMakeAndScale( 61.43,  97.04),
                        controlPoint1: pointMakeAndScale( 61.43,  3.68),
                        controlPoint2: pointMakeAndScale( 61.43,  95.16))
    rightPauseBezier.addCurve(  to: pointMakeAndScale( 63.95,  99.26),
                        controlPoint1: pointMakeAndScale( 61.43,  98.92),
                        controlPoint2: pointMakeAndScale( 62.08,  99.26))
    rightPauseBezier.addCurve(  to: pointMakeAndScale( 84.12,  99.26),
                        controlPoint1: pointMakeAndScale( 65.82,  99.26),
                        controlPoint2: pointMakeAndScale( 82.22,  99.26))
    rightPauseBezier.addCurve(  to: pointMakeAndScale( 86.61,  96.76),
                        controlPoint1: pointMakeAndScale( 86.01,  99.26),
                        controlPoint2: pointMakeAndScale( 86.61,  98.91))
    rightPauseBezier.addCurve(  to: pointMakeAndScale( 86.61,  3.54),
                        controlPoint1: pointMakeAndScale( 86.61,  94.62),
                        controlPoint2: pointMakeAndScale( 86.61,  5.57))
    rightPauseBezier.addCurve(  to: pointMakeAndScale( 84.17,  0.29),
                        controlPoint1: pointMakeAndScale( 86.61,  1.5),
                        controlPoint2: pointMakeAndScale( 86.48,  0.29))
    rightPauseBezier.addCurve(  to: pointMakeAndScale( 64.01,  0.31),
                        controlPoint1: pointMakeAndScale( 81.85,  0.29),
                        controlPoint2: pointMakeAndScale( 65.97,  0.31))
    rightPauseBezier.close()
    return rightPauseBezier
  }
  
  
  

  class func leftPauseBezier() -> UIBezierPath {
    let leftPauseBezier = UIBezierPath()
    leftPauseBezier.move(     to: pointMakeAndScale( 14.01,  0.31))
    leftPauseBezier.addCurve( to: pointMakeAndScale( 11.43,  2.57),
                      controlPoint1: pointMakeAndScale( 12.05,  0.31),
                      controlPoint2: pointMakeAndScale( 11.43,  1.46))
    leftPauseBezier.addCurve( to: pointMakeAndScale( 11.43,  97.04),
                      controlPoint1: pointMakeAndScale( 11.43,  3.68),
                      controlPoint2: pointMakeAndScale( 11.43,  95.16))
    leftPauseBezier.addCurve( to: pointMakeAndScale( 13.95,  99.26),
                      controlPoint1: pointMakeAndScale( 11.43,  98.92),
                      controlPoint2: pointMakeAndScale( 12.08,  99.26))
    leftPauseBezier.addCurve( to: pointMakeAndScale( 34.12,  99.26),
                      controlPoint1: pointMakeAndScale( 15.82,  99.26),
                      controlPoint2: pointMakeAndScale( 32.22,  99.26))
    leftPauseBezier.addCurve( to: pointMakeAndScale( 36.61,  96.76),
                      controlPoint1: pointMakeAndScale( 36.01,  99.26),
                      controlPoint2: pointMakeAndScale( 36.61,  98.91))
    leftPauseBezier.addCurve( to: pointMakeAndScale( 36.61,  3.54),
                      controlPoint1: pointMakeAndScale( 36.61,  94.62),
                      controlPoint2: pointMakeAndScale( 36.61,  5.57))
    leftPauseBezier.addCurve( to: pointMakeAndScale( 34.17,  0.29),
                      controlPoint1: pointMakeAndScale( 36.61,  1.5),
                      controlPoint2: pointMakeAndScale( 36.48,  0.29))
    leftPauseBezier.addCurve( to: pointMakeAndScale( 14.01,  0.31),
                      controlPoint1: pointMakeAndScale( 31.85,  0.29),
                      controlPoint2: pointMakeAndScale( 15.97,  0.31))
    leftPauseBezier.close()
    return leftPauseBezier
  }
  
}
