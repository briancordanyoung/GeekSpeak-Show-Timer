import UIKit

class BackButton: UIButton {
  
  var color = UIColor.whiteColor()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    color = tintColor
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    color = tintColor
  }

  override func drawRect(rect: CGRect) {

    color.setStroke()
    
    let origSizeX = CGFloat(37)
    let origSizeY = CGFloat(47)
    let xOffset = center.x - (origSizeX / 2)
    let yOffset = center.y - (origSizeY / 2)
    
    
    let backPath = UIBezierPath()
    backPath.moveToPoint(     CGPointMake(24.5 + xOffset,  8.5 + yOffset))
    backPath.addCurveToPoint( CGPointMake(10.5 + xOffset, 22.5 + yOffset),
               controlPoint1: CGPointMake(10.5 + xOffset, 22.5 + yOffset),
               controlPoint2: CGPointMake(10.5 + xOffset, 22.5 + yOffset))
    backPath.addLineToPoint(  CGPointMake(24.5 + xOffset, 36.5 + yOffset))
    backPath.lineWidth = 5
    backPath.stroke()
  }
  
  func highlight() {
    color = UIColor.whiteColor()
    drawRect(frame)
  }
  
  func unhighlight() {
    color = tintColor
    drawRect(frame)
  }
  
  
  // MARK:
  // MARK: UIControl Methods
  override func beginTrackingWithTouch(touch: UITouch,
                                            withEvent event: UIEvent?) -> Bool {
    let superResult =  super.beginTrackingWithTouch(touch, withEvent: event)
    highlight()
    return superResult
  }
  
  override func cancelTrackingWithEvent(event: UIEvent?) {
    super.cancelTrackingWithEvent(event)
    unhighlight()
  }
  
  override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
    super.endTrackingWithTouch(touch, withEvent: event)
    unhighlight()
  }
  
}


