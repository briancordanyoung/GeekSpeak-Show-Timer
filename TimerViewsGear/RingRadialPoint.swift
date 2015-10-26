import UIKit
import AngleGear


public struct RingRadialPoint {
  public let center: RingPoint
  public let radius: CGFloat
  public let angle:  TauAngle
  
  public var ringPoint: RingPoint {
    let x = center.x + radius * cos(CGFloat(angle))
    let y = center.y + radius * sin(CGFloat(angle))
    return RingPoint(x:x, y:y)
  }
  
  public func ringRadialPointRotatedBy(rotateBy: TauAngle) -> RingRadialPoint {
    return RingRadialPoint( center: center,
                            radius: radius,
                             angle: angle + rotateBy)
  }
  
  public func ringPointRotatedBy(rotateBy: TauAngle) -> RingPoint {
    let x = center.x + radius * cos(CGFloat(angle + rotateBy))
    let y = center.y + radius * sin(CGFloat(angle + rotateBy))
    return RingPoint(x:x, y:y)
  }
  
}