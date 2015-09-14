import Foundation

class RingPoint: NSObject {
  
  let x: CGFloat
  let y: CGFloat
  
  init( x: CGFloat,
        y: CGFloat) {
        self.x = x
        self.y = y
  }
  
  override init() {
      self.x = CGFloat(0)
      self.y = CGFloat(0)
  }

  
  func subtract(point: RingPoint) -> RingPoint {
    return RingPoint(x: x - point.x,
                     y: y - point.y)
  }
  
  func add(point: RingPoint) -> RingPoint {
    return RingPoint( x: x + point.x,
                      y: y + point.y)
  }
  
  func scale(multiple: CGFloat) -> RingPoint {
    return RingPoint(x: x * multiple,
                     y: y * multiple)
  }
  
  func distance(point: RingPoint) -> CGFloat {
    return sqrt((x - point.x)*(x - point.x) +
                (y - point.y)*(y - point.y))
  }
  
  func angleBetweenPoint( point: RingPoint, fromMutualCenter center: RingPoint)
                                                                   -> Rotation {
    let selfAngle  = self.dynamicType.angleFrom2Points(self,center)
    let otherAngle = self.dynamicType.angleFrom2Points(point,center)
    
    return selfAngle - otherAngle
  }
  
  class func angleFrom2Points(point1: RingPoint, _ point2: RingPoint)
                                                                   -> Rotation {
    let dx = point1.x - point2.x
    let dy = point1.y - point2.y
    let radian = atan2(dy,dx)
    return Rotation(radian)
  }

  override var description: String {
    return "x: \(x) y: \(y))"
  }
}
