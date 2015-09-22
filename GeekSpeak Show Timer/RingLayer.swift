import Foundation


struct RingSection {
  let percentage: CGFloat
  let color: UIColor
}


class RingLayer : CALayer {
  
  struct Constants {
    static let DefaultColor = UIColor.whiteColor()
    static let Tau = CGFloat(M_PI) * 2
    static let Quarter = CGFloat(M_PI) * 0.5
    static let StartAngle = "ringViewStartAngleId"
    static let EndAngle   = "ringViewEndAngleId"
    static let FillScale  = "ringViewFillScaleId"
    static let RingWidth  = "ringViewRingWidthId"
    static let RingStyle  = "ringViewRingStyleId"
  }
  
  @NSManaged var startAngle: CGFloat // radians
  @NSManaged var endAngle:   CGFloat // radians
  @NSManaged var ringWidth:  CGFloat // percentage of the view size (0-1)
  @NSManaged var fillScale:  CGFloat // percentage of the view size (0-1)
  private var _colors: [RingSection] = [RingSection(percentage: 1.0,
                                                  color: Constants.DefaultColor)]
  var ringStyle: RingDrawing.Style = .Rounded {
    didSet {
      setNeedsDisplay()
    }
  }
  
  var colors: [RingSection] {
    get {
      return _colors
    }
    set(newColors) {
      do {
        try self._colors = validateMultipleColors(newColors)
        setNeedsDisplay()
      } catch {
        print("Error: Could not set new colors")
      }
    }
  }
  
  var color: UIColor {
    get {
      if let color = _colors.first?.color {
        return color
      } else {
        return Constants.DefaultColor
      }
    }
    set(newColor) {
      _colors = [RingSection(percentage: 1.0, color: newColor)]
      setNeedsDisplay()
    }
  }

  override init() {
    super.init()
    
    startAngle = CGFloat(TauAngle(degrees: 0))
    endAngle   = CGFloat(TauAngle(degrees: 360))
    ringWidth  = CGFloat(0.2)
    fillScale  = CGFloat(1.0)
    self.needsDisplay()
  }
  
  init?(startAngle: CGFloat,
         endAngle: CGFloat,
        ringWidth: CGFloat,
           colors: [RingSection]) {
          
    do {
      super.init()
      let validColors = try validateMultipleColors(colors)
      self.startAngle = startAngle
      self.endAngle   = endAngle
      self.ringWidth  = ringWidth
      self._colors    = validColors
      self.needsDisplay()
    } catch {
      return nil
    }
  }
  
  convenience init?(startAngle: CGFloat,
                     endAngle: CGFloat,
                    ringWidth: CGFloat,
                        color: UIColor) {
                      
    let colors = [RingSection(percentage: 1.0, color: color)]
    self.init(startAngle: startAngle,
                endAngle: endAngle,
               ringWidth: ringWidth,
                  colors: colors)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    startAngle = CGFloat(aDecoder.decodeDoubleForKey(Constants.StartAngle))
    endAngle   = CGFloat(aDecoder.decodeDoubleForKey(Constants.EndAngle))
    ringWidth  = CGFloat( aDecoder.decodeDoubleForKey(Constants.RingWidth))
    fillScale  = CGFloat( aDecoder.decodeDoubleForKey(Constants.FillScale))
    switch aDecoder.decodeIntForKey(Constants.RingStyle) {
    case 0:
      ringStyle = .Rounded
    case 1:
      ringStyle = .Sharp
    default:
      ringStyle = .Rounded
    }
    // TODO: Add encoder/decoder for colors
  }
  
  
  override func encodeWithCoder(aCoder: NSCoder) {
    super.encodeWithCoder(aCoder)
    aCoder.encodeDouble(Double(startAngle), forKey: Constants.StartAngle)
    aCoder.encodeDouble(Double(endAngle),   forKey: Constants.EndAngle)
    aCoder.encodeDouble(Double(ringWidth),  forKey: Constants.RingWidth)
    aCoder.encodeDouble(Double(fillScale),  forKey: Constants.FillScale)
    switch ringStyle {
    case .Rounded,
    .RoundedWithGuides:
      aCoder.encodeInt(0, forKey: Constants.RingStyle)
    case .Sharp:
      aCoder.encodeInt(1, forKey: Constants.RingStyle)
    }
  }

  
  
  // MARK: Internal Computed Properties
  // Internally offset the angles so that they start drawing at the top
  
  private var start: TauAngle {
    return TauAngle(startAngle)
  }
  
  private var end: TauAngle {
    return TauAngle(endAngle)
  }
    
  private var center: RingPoint {
    let width  = self.bounds.size.width
    let height = self.bounds.size.height
    
    let smaller = min(width , height)
    
    var point = RingPoint(x: smaller / 2,
                          y: smaller / 2)

    if width > height {
      let diff = width - height
      point = RingPoint(x: (smaller / 2) + diff,
                        y: (smaller / 2)        )
    }
    
    if width < height {
      let diff = height - width
      point = RingPoint(x: (smaller / 2) ,
                        y: (smaller / 2) + diff)
    }
    
    return point
  }
  
  private var maxRingRadius: CGFloat {
    return min(self.bounds.size.width , self.bounds.size.height) / 2
  }
  
  private var ringRadius: CGFloat {
    return maxRingRadius * fillScale
  }
  
  
  // MARK:
  enum AdditionalColorError: ErrorType {
    case GreaterThan100Percent
  }
  
  func validateMultipleColors(colors: [RingSection]) throws -> [RingSection] {
    // Make sure the array of RingSection make sense and don't add up to more
    // than 100%
    var totalPercentage = CGFloat(0.0)
    for color in colors { totalPercentage += color.percentage }
    if totalPercentage >= 1.0 {throw AdditionalColorError.GreaterThan100Percent}
    
    return colors
  }
  
  
  // MARK: Drawing
  override func drawInContext(ctx: CGContext) {
    
    maskRingInContext(ctx)
    
    let percentVisible = endAngle / Constants.Tau
    
    for section in colors.reverse() {
      if section.percentage >= percentVisible {
        drawColor(section.color, fromStartTo: percentVisible, inContext: ctx)
      } else {
        drawColor(section.color, fromStartTo: section.percentage, inContext: ctx)
      }
    }
  }
  
  func maskRingInContext(ctx: CGContext) {
    guard let maskCTX   = CGBitmapContextCreate( nil,
                          CGBitmapContextGetWidth(ctx),
                          CGBitmapContextGetHeight(ctx),
                          CGBitmapContextGetBitsPerComponent(ctx),
                          CGBitmapContextGetBytesPerRow(ctx),
                          CGColorSpaceCreateDeviceGray(),
                          UInt32(0) /* kCGImageAlphaNone */) else {return}
    
    let rect = CGRectMake(0 , 0,
                          CGFloat(CGBitmapContextGetWidth(ctx)),
                          CGFloat(CGBitmapContextGetHeight(ctx)))
    
    let maskOutColor = UIColor.blackColor().CGColor
    let maskInColor  = UIColor.whiteColor()
    
    CGContextSetFillColorWithColor(maskCTX, maskOutColor)
    CGContextFillRect(maskCTX, rect)
    
    let maxRingWidthInPoints = maxRingRadius * ringWidth
    let ringWidthInPoints  = min(ringRadius, maxRingWidthInPoints)
    
    let maskDrawing = RingDrawing(center: center,
                             outerRadius: ringRadius,
                               ringWidth: ringWidthInPoints,
                              startAngle: TauAngle(degrees: 0),
                                endAngle: TauAngle(degrees: 360))
    maskDrawing.fillColor = maskInColor
    maskDrawing.style     = ringStyle
    
    maskDrawing.drawInContext(maskCTX)
    let ringMask = CGBitmapContextCreateImage(maskCTX)
    
    CGContextClipToMask(ctx, rect, ringMask)
  }
  
  
  func drawColor(                  color: UIColor,
    fromStartTo percentage: CGFloat,
    inContext ctx: CGContext) {
      let radius     = max(self.bounds.size.width, self.bounds.size.height)
      let north      = CGFloat(TauAngle(degrees: 0)) - Constants.Quarter
      let northPoint = CGPointMake(center.x + radius * cos(north),
                                   center.y + radius * sin(north))
      
      let sectionEnd = CGFloat(Constants.Tau * percentage) - Constants.Quarter
      
      
      CGContextBeginPath(ctx)
      CGContextMoveToPoint(ctx, center.x, center.y)
      CGContextAddLineToPoint(ctx, northPoint.x, northPoint.y)
      CGContextAddArc(ctx, center.x, center.y, radius, north, sectionEnd, Int32(0))
      CGContextClosePath(ctx)
      CGContextSetFillColorWithColor(ctx, color.CGColor)
      CGContextSetStrokeColorWithColor(ctx, UIColor.clearColor().CGColor)
      CGContextSetLineWidth(ctx, 0.0)
      CGContextFillPath(ctx)
  }
  
  
  
  // MARK: Animation
  // Allows CoreAnimation to animate these parameters.
  override class func needsDisplayForKey(key: String) -> Bool {
    if key == "startAngle" ||
       key == "endAngle" ||
       key == "ringWidth" {
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