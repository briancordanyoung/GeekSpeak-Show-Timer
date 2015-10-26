import UIKit
import AngleGear


public class RingPoint: NSObject {
  
  public let x: CGFloat
  public let y: CGFloat
  
  public init( x: CGFloat,
        y: CGFloat) {
        self.x = x
        self.y = y
  }
  
  public override init() {
      self.x = CGFloat(0)
      self.y = CGFloat(0)
  }

  
  public func subtract(point: RingPoint) -> RingPoint {
    return RingPoint(x: x - point.x,
                     y: y - point.y)
  }
  
  public func add(point: RingPoint) -> RingPoint {
    return RingPoint( x: x + point.x,
                      y: y + point.y)
  }
  
  public func scale(multiple: CGFloat) -> RingPoint {
    return RingPoint(x: x * multiple,
                     y: y * multiple)
  }
  
  public func distance(point: RingPoint) -> CGFloat {
    return sqrt((x - point.x)*(x - point.x) +
                (y - point.y)*(y - point.y))
  }
  
 public  func angleBetweenPoint( point: RingPoint, fromMutualCenter center: RingPoint)
                                                                   -> TauAngle {
    let selfAngle  = self.dynamicType.angleFrom2Points(self,center)
    let otherAngle = self.dynamicType.angleFrom2Points(point,center)
    
    return selfAngle - otherAngle
  }
  
  public func angleFromCenter(center: RingPoint)  -> TauAngle {
    return self.dynamicType.angleFrom2Points(self,center)
  }
  
  public class func angleFrom2Points(point1: RingPoint, _ point2: RingPoint)
                                                                   -> TauAngle {
    let dx = point1.x - point2.x
    let dy = point1.y - point2.y
    let radian = atan2(dy,dx)
    return TauAngle(radian)
  }

  public func ringRadialPointUsingCenter(center: RingPoint) -> RingRadialPoint {
    let angle  = angleFromCenter(center)
    let radius = distance(center)
    return RingRadialPoint(center: center,
                           radius: radius,
                            angle: angle  )
  }
  
  public override var description: String {
    return "x: \(x) y: \(y))"
  }
}
