import UIKit

class NextSegmentButton: ShapesButton {
  
  
  // Button Shapes
  let shape: SizableBezierPathFunc = { size in
    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    return UIBezierPath(roundedRect: rect, cornerRadius: size.height / 5)
  }
  

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupShapeView()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupShapeView()
  }
  
  func setupShapeView() {
    shapesView = ShapesView()
    let buttonShape = SizableBezierPath()
    buttonShape.pathForSize = shape
    shapesView?.shapes.append(buttonShape)
    
  }
  
}