import UIKit


class ShapesView: SizeToSuperView {

  var shapes: [SizableBezierPath] = []  {
    didSet { setNeedsDisplay() }
  }
  
  var fillOpacity = CGFloat(0.0) {
    didSet { setNeedsDisplay() }
  }
  
  var lineWidth = CGFloat(1.0) {
    didSet { setNeedsDisplay() }
  }
  
  var lineColor = UIColor.whiteColor() {
    didSet { setNeedsDisplay() }
  }

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  
  func setup() {
    opaque = false
    contentMode = .Redraw
  }
  
  override func drawRect(rect: CGRect) {
    // optimize for drawing only inside rect?
    // fill with background color when opaque?
    
    for shape in shapes {
      shape.size = bounds.size
      
      if fillOpacity > 0 {
        let fillColor = tintColor.colorWithAlphaComponent(fillOpacity)
        fillColor.setFill()
        shape.path.fill()
      }
      
      if lineWidth > 0 {
        lineColor.setStroke()
        shape.path.lineWidth = lineWidth
        shape.path.stroke()
      }
    }
    

  }
  
  
  
  
}