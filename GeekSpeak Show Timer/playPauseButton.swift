import UIKit

class playPauseButton: UIButton {
  
  var fillColor: UIColor {
    if let tintColor = tintColor {
      return tintColor
    } else {
      return UIColor.clearColor()
    }
  }

  
  
func drawButton() {

    //// play Drawing
    var playPath = UIBezierPath()
    playPath.moveToPoint(CGPointMake(943.5, 499.5))
    playPath.addCurveToPoint(CGPointMake(935.5, 484.5), controlPoint1: CGPointMake(943.5, 488.5), controlPoint2: CGPointMake(935.5, 484.5))
    playPath.addLineToPoint(CGPointMake(70.5, 9.5))
    playPath.addCurveToPoint(CGPointMake(55.5, 9.5), controlPoint1: CGPointMake(70.5, 9.5), controlPoint2: CGPointMake(62.5, 5.5))
    playPath.addCurveToPoint(CGPointMake(49.5, 24.5), controlPoint1: CGPointMake(48.5, 13.5), controlPoint2: CGPointMake(49.5, 24.5))
    playPath.addLineToPoint(CGPointMake(49.5, 949.5))
    playPath.addCurveToPoint(CGPointMake(55.5, 965.5), controlPoint1: CGPointMake(49.5, 949.5), controlPoint2: CGPointMake(48.5, 961.5))
    playPath.addCurveToPoint(CGPointMake(70.5, 965.5), controlPoint1: CGPointMake(62.5, 969.5), controlPoint2: CGPointMake(70.5, 965.5))
    playPath.addLineToPoint(CGPointMake(935.5, 515.5))
    playPath.addCurveToPoint(CGPointMake(943.5, 499.5), controlPoint1: CGPointMake(935.5, 515.5), controlPoint2: CGPointMake(943.5, 510.5))
    playPath.closePath()
    fillColor.setFill()
    playPath.fill()
    UIColor.blackColor().setStroke()
    playPath.lineWidth = 2
    playPath.stroke()
}
  
  override func drawRect(rect: CGRect) {
    drawButton()
  }

  
}