import UIKit

class PieLayer: CALayer {
  
  struct Constants {
    static let StartAngle   = "pieLayerStartAngleId"
    static let EndAngle     = "pieLayerEndAngleId"
    static let ClipToCircle = "pieLayerClipToCircleId"
    static let FillColor    = "pieLayerFillColorId"
  }
  
  @NSManaged var startAngle: CGFloat
  @NSManaged var endAngle: CGFloat
  
  var clipToCircle = true
  var fillColor = UIColor.whiteColor()
  
  
  
  // MARK: Internal Computed Properties
  private var center: CGPoint {
    let width  = self.bounds.size.width
    let height = self.bounds.size.height
    
    let smaller = min(width , height)
    
    var point = CGPoint(x: smaller / 2,
      y: smaller / 2)
    
    if width > height {
      let diff = (width - height) / 2
      point = CGPoint(x: (smaller / 2) + diff,
        y: (smaller / 2)        )
    }
    
    if width < height {
      let diff = (height - width) / 2
      point = CGPoint(x: (smaller / 2) ,
        y: (smaller / 2) + diff)
    }
    
    return point
  }
  
  private var radius: CGFloat {
    return min(self.bounds.size.width , self.bounds.size.height) / 2
  }
  
  
  
  // MARK: Initialization
  // Internally offset the angles so that they start drawing at the top
  override init() {
    super.init()
    startAngle = CGFloat(TauAngle(degrees: 0))
    endAngle   = CGFloat(TauAngle(degrees: 360))
    self.needsDisplay()
  }
  
  override init(layer: AnyObject) {
    super.init(layer: layer)
    if let layer = layer as? PieLayer {
      startAngle   = layer.startAngle
      endAngle     = layer.endAngle
      clipToCircle = layer.clipToCircle
      fillColor    = layer.fillColor
    } else {
      startAngle   = CGFloat(TauAngle(degrees: 0))
      endAngle     = CGFloat(TauAngle(degrees: 360))
    }
  }
  
  init(startAngle: CGFloat,
    endAngle: CGFloat) {
      
      super.init()
      self.startAngle = startAngle
      self.endAngle   = endAngle
      self.needsDisplay()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    startAngle   = CGFloat(aDecoder.decodeDoubleForKey(Constants.StartAngle))
    endAngle     = CGFloat(aDecoder.decodeDoubleForKey(Constants.EndAngle))
    clipToCircle = aDecoder.decodeBoolForKey(Constants.ClipToCircle)
    // TODO: decode Color
  }
  
  
  override func encodeWithCoder(aCoder: NSCoder) {
    super.encodeWithCoder(aCoder)
    aCoder.encodeDouble(Double(startAngle), forKey: Constants.StartAngle)
    aCoder.encodeDouble(Double(endAngle),   forKey: Constants.EndAngle)
    aCoder.encodeBool(clipToCircle,         forKey: Constants.ClipToCircle)
    // TODO: encode Color
  }
  
  
  
  
  // MARK: Drawing
  override func drawInContext(ctx: CGContext) {
    
    let halfPi = (M_PI / 2)
    let offset = startAngle > endAngle ? CGFloat(halfPi) : -CGFloat(halfPi)
    let start = startAngle + offset
    let end   = endAngle   + offset
    
    CGContextBeginPath(ctx)
    CGContextMoveToPoint(ctx, center.x, center.y)
    
    let p1 = CGPointMake(center.x + radius * cos(start),
      center.y + radius * sin(start))
    CGContextAddLineToPoint(ctx, p1.x, p1.y)
    
    let clockwise = start > end ? Int32(0) : Int32(1)
    CGContextAddArc(ctx, center.x, center.y, radius,
      start,      end, clockwise)
    
    CGContextClosePath(ctx);
    
    CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor)
    CGContextSetStrokeColorWithColor(ctx, self.fillColor.CGColor)
    CGContextSetLineWidth(ctx, 2.0)
    
    CGContextDrawPath(ctx, .Fill)
    
  }
  
  // MARK: Animation
  // Allows CoreAnimation to animate these parameters.
  override class func needsDisplayForKey(key: String) -> Bool {
    if key == "startAngle" ||
      key == "endAngle" {
        return true
    } else {
      return false
    }
  }
  
  func makeAnimationForKey(key: String) -> CABasicAnimation {
    let anim = CABasicAnimation(keyPath: key)
    anim.fromValue = presentationLayer()?.valueForKey(key)
    anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
    anim.duration = 0.0
    return anim
  }
  
}

