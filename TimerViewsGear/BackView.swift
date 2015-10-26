import UIKit

final public class BackView: UIView {
  
  public var highlightColor = UIColor.whiteColor() {
    didSet(oldColor) {
      // If the current drawing color is the same as the old highlightColor
      // then redraw the highlight
      if color.isEqual(oldColor) {
        highlight()
      }
    }
  }
  
  public override var tintColor: UIColor! {
    didSet(oldColor) {
      // If the current drawing color is the same as the old tintColor
      // then redraw the tintColor
      if color.isEqual(oldColor) {
        unhighlight()
      }
    }
  }
  
  public enum highlightState {
    case Highlighted
    case Unhighlighted
  }
  
  // The highlight state is derived from the current color used to draw
  // the back image.
  public var highlighted: highlightState {
    if color.isEqual(tintColor) {
      return .Highlighted
    } else {
      return .Unhighlighted
    }
  }
  
  private let origSizeX = CGFloat(17.5)
  private let origSizeY = CGFloat(23)
  
  private var color = UIColor.whiteColor()
  
  public override func intrinsicContentSize() -> CGSize {
    return CGSize(width: origSizeX, height: origSizeY)
  }
  
  
  public override func drawRect(rect: CGRect) {
    
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
  
  public func highlight() {
    color = highlightColor
    setNeedsDisplay()
  }
  
  public func unhighlight() {
    color = tintColor
    setNeedsDisplay()
  }

}