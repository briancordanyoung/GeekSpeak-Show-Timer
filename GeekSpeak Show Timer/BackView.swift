import UIKit

class BackView: UIView {
  
  var color = UIColor.whiteColor()
  let origSizeX = CGFloat(17.5)
  let origSizeY = CGFloat(23)
  
  
  
  override func intrinsicContentSize() -> CGSize {
    return CGSize(width: origSizeX, height: origSizeY)
  }
  
  
  
  override func drawRect(rect: CGRect) {
    
    color.setStroke()
    
    let xOffset = (bounds.width  / 2) - (origSizeX / 2)
    let yOffset = (bounds.height / 2) - (origSizeY / 2)
    
    let backPath = UIBezierPath()
    backPath.moveToPoint(     CGPointMake(13.5  + xOffset,  2 + yOffset))
    backPath.addCurveToPoint( CGPointMake( 4    + xOffset, 12 + yOffset),
      controlPoint1: CGPointMake( 4    + xOffset, 12 + yOffset),
      controlPoint2: CGPointMake( 4    + xOffset, 12 + yOffset))
    backPath.addLineToPoint(  CGPointMake(13.5  + xOffset, 21 + yOffset))
    backPath.lineWidth = 3.5
    backPath.stroke()
    
    UIColor.yellowColor().setStroke()
    
    //    UIRectFrame(rect)
  }
  
  func highlight() {
    color = UIColor.whiteColor()
    setNeedsDisplay()
  }
  
  func unhighlight() {
    color = tintColor
    setNeedsDisplay()
  }

}