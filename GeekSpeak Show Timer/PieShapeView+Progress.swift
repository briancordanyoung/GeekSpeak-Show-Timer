import UIKit

extension PieShapeView {
  
  // Unlike the percent property which accounts for the startAngle and adds
  // the "percentage complete" to the startAngle to get the endAngle....
  // This progress progress property assumes the startAngle is at 0 degrees.
  // But, if the endAngle is greater than 360 degrees then the startAngle is
  // 0 + 5 + the degrees past 360 that the endAngle is at.
  // This makes a 5 degree gap in the circle the indicates the progress
  // past 100%
  var progress: CGFloat {
    get {
      let minAngle = min(startAngle,endAngle)
      let maxAngle = max(startAngle,endAngle)
      let diff     = maxAngle - minAngle
      let percent  = CGFloat(Rotation(degrees: 360)) / CGFloat(diff)
      
      return percent
    }
    set(newPercentage) {
      endAngle = Rotation(degrees: 360 * newPercentage)
      if endAngle > Rotation(degrees: 360) {
        let past360 = endAngle - Rotation(degrees: 360)
        startAngle = past360 + Rotation(degrees: 5)
      } else {
        startAngle = Rotation(degrees: 0)
      }
    }
  }
  
  
}