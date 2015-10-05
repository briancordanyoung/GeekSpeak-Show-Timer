import Foundation

class RingCircle: NSObject {
  
  let center : RingPoint
  let radius : CGFloat
  
  init( center: RingPoint,
        radius: CGFloat) {
    self.center  = center
    self.radius = radius
  }
  
  override init() {
      center  = RingPoint(x:0,y:0)
      radius = CGFloat(1)
  }
  
  func intersecetions(circle: RingCircle) -> [RingPoint]{
    let distance = self.center.distance(circle.center)
    let a = (radius * radius -
             circle.radius * circle.radius +
             distance * distance ) /
             (2 * distance)
    let h = sqrt(radius * radius - a * a)
    
    let point2 = circle.center.subtract(self.center).scale( a / distance ).add( self.center)
    
    let x3 = point2.x + h*(circle.center.y - self.center.y)/distance
    let y3 = point2.y - h*(circle.center.x - self.center.x)/distance
    let x4 = point2.x - h*(circle.center.y - self.center.y)/distance
    let y4 = point2.y + h*(circle.center.x - self.center.x)/distance
                                        
    var points: [RingPoint] = []
    
    if (x3.isNaN == false && y3.isNaN == false) {
      points.append(RingPoint(x:x3,y:y3))
    }
    if (x4.isNaN == false && y4.isNaN == false) {
      points.append(RingPoint(x:x4,y:y4))
    }
    
    return points
  }
  
  override var description: String {
    return "center: (\(center)) y: \(radius))"
  }

}
