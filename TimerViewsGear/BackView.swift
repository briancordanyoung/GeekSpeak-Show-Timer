import UIKit

final public class BackView: UIView {
  
  public var highlightColor = UIColor.white {
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
    case highlighted
    case unhighlighted
  }
  
  // The highlight state is derived from the current color used to draw
  // the back image.
  public var highlighted: highlightState {
    if color.isEqual(tintColor) {
      return .highlighted
    } else {
      return .unhighlighted
    }
  }
  
  fileprivate let origSizeX = CGFloat(17.5)
  fileprivate let origSizeY = CGFloat(23)
  
  fileprivate var color = UIColor.white
  
  public override var intrinsicContentSize : CGSize {
    return CGSize(width: origSizeX, height: origSizeY)
  }
  
  
  public override func draw(_ rect: CGRect) {
    
    color.setStroke()
    
    let xOffset = (bounds.width  / 2) - (origSizeX / 2)
    let yOffset = (bounds.height / 2) - (origSizeY / 2)
    
    let backPath = UIBezierPath()
    backPath.move(     to: CGPoint(x: 13.5  + xOffset,  y: 2 + yOffset))
    backPath.addCurve( to: CGPoint( x: 4    + xOffset, y: 12 + yOffset),
               controlPoint1: CGPoint( x: 4    + xOffset, y: 12 + yOffset),
               controlPoint2: CGPoint( x: 4    + xOffset, y: 12 + yOffset))
    backPath.addLine(  to: CGPoint(x: 13.5  + xOffset, y: 21 + yOffset))
    backPath.lineWidth = 3.5
    backPath.stroke()
    
    UIColor.yellow.setStroke()
    
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
