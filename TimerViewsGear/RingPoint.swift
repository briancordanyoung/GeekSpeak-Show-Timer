import UIKit
import AngleGear


open class RingPoint: NSObject {
  
  open let x: CGFloat
  open let y: CGFloat
  
  public init( x: CGFloat,
        y: CGFloat) {
        self.x = x
        self.y = y
  }
  
  public override init() {
      self.x = CGFloat(0)
      self.y = CGFloat(0)
  }
  
  open var point: CGPoint {
    return CGPoint(x: self.x, y: self.y)
  }
  
  open func subtract(_ point: RingPoint) -> RingPoint {
    return RingPoint(x: x - point.x,
                     y: y - point.y)
  }
  
  open func add(_ point: RingPoint) -> RingPoint {
    return RingPoint( x: x + point.x,
                      y: y + point.y)
  }
  
  open func scale(_ multiple: CGFloat) -> RingPoint {
    return RingPoint(x: x * multiple,
                     y: y * multiple)
  }
  
  open func distance(_ point: RingPoint) -> CGFloat {
    return sqrt((x - point.x)*(x - point.x) +
                (y - point.y)*(y - point.y))
  }
  
 open func angleBetweenPoint( _ point: RingPoint, fromMutualCenter center: RingPoint)
                                                                   -> TauAngle {
    let selfAngle  = type(of: self).angleFrom2Points(self,center)
    let otherAngle = type(of: self).angleFrom2Points(point,center)
    
    return selfAngle - otherAngle
  }
  
  open func angleFromCenter(_ center: RingPoint)  -> TauAngle {
    return type(of: self).angleFrom2Points(self,center)
  }
  
  open class func angleFrom2Points(_ point1: RingPoint, _ point2: RingPoint)
                                                                   -> TauAngle {
    let dx = point1.x - point2.x
    let dy = point1.y - point2.y
    let radian = atan2(dy,dx)
    return TauAngle(radian)
  }

  open func ringRadialPointUsingCenter(_ center: RingPoint) -> RingRadialPoint {
    let angle  = angleFromCenter(center)
    let radius = distance(center)
    return RingRadialPoint(center: center,
                           radius: radius,
                            angle: angle  )
  }
  
  open override var description: String {
    return "x: \(x) y: \(y))"
  }
}
