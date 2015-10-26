import Foundation
import AngleGear


// RingColor - A simple container for a color and how much of the ring the
//             color fills.
//             portion property is relative. 
//             Any number can be assigned.
//             Before the portion property is used, it is compared to all the
//             other RingColors in an array and translated to a ColorSection.

public struct RingColor {
  public let portion: CGFloat
  public let color: UIColor
  
  public init( portion: CGFloat,
                 color: UIColor) {
    self.portion = portion
    self.color   = color
  }
}



final class RingLayer : CALayer {

  // ColorSection - The ColorSection is a simple container for a color and
  //                how much of the ring the color fills.
  //                percentToEnd property is a value from 0-1 representing
  //                how far around the ring the color fills before stopping.
  struct ColorSection {
    let percentToEnd: CGFloat
    let color: UIColor
  }
  
  
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
  private var _colors: [RingColor] = [RingColor(portion: 1.0,
                                                  color: Constants.DefaultColor)]
  var ringStyle: RingDrawing.Style = .Rounded {
    didSet {
      setNeedsDisplay()
    }
  }
  
  var colors: [RingColor] {
    get {
      return _colors
    }
    set(newColors) {
      self._colors = newColors
      setNeedsDisplay()
    }
  }
  
  // A convience property that sets the colors array to a single color
  var color: UIColor {
    get {
      if let color = _colors.first?.color {
        return color
      } else {
        return Constants.DefaultColor
      }
    }
    set(newColor) {
      _colors = [RingColor(portion: 1.0, color: newColor)]
    }
  }
  
  // Translate the RingColor array to a ColorSection array
  var colorSections: [ColorSection] {
    get {
      let portionTotal = colors.reduce(CGFloat(0), combine: {$0 + $1.portion})
      var sections: [ColorSection] = []
      var portionTally = CGFloat(0)
      
      for section in colors {
        portionTally += section.portion
        sections.append(ColorSection(percentToEnd: portionTally / portionTotal,
                                            color: section.color))
      }
      
      return sections
    }
  }

  override init() {
    super.init()
    
    startAngle = CGFloat(TauAngle(degrees: 0))
    endAngle   = CGFloat(TauAngle(degrees: 360))
    ringWidth  = CGFloat(0.2)
    fillScale  = CGFloat(1.0)
    backgroundColor = UIColor.clearColor().CGColor
    opaque = false
    self.needsDisplay()
  }
  
  override init(layer: AnyObject) {
    super.init(layer: layer)
    if let layer = layer as? RingLayer {
      startAngle = layer.startAngle
      endAngle   = layer.endAngle
      ringWidth  = layer.ringWidth
      fillScale  = layer.fillScale
    } else {
      startAngle = CGFloat(TauAngle(degrees: 0))
      endAngle   = CGFloat(TauAngle(degrees: 360))
      ringWidth  = CGFloat(0.2)
      fillScale  = CGFloat(1.0)
    }
    backgroundColor = UIColor.clearColor().CGColor
    opaque = false
    self.needsDisplay()
  }
  
  init?(startAngle: CGFloat,
         endAngle: CGFloat,
        ringWidth: CGFloat,
           colors: [RingColor]) {
          
    super.init()
    self.startAngle = startAngle
    self.endAngle   = endAngle
    self.ringWidth  = ringWidth
    self._colors    = colors
    backgroundColor = UIColor.clearColor().CGColor
    opaque = false
    self.needsDisplay()
  }
  
  convenience init?(startAngle: CGFloat,
                     endAngle: CGFloat,
                    ringWidth: CGFloat,
                        color: UIColor) {
                      
    let colors = [RingColor(portion: 1.0, color: color)]
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
    backgroundColor = UIColor.clearColor().CGColor
    opaque = false
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
  
  
  // MARK: Drawing
  override func drawInContext(ctx: CGContext) {
    
    maskRingInContext(ctx)
    
    let percentVisible = endAngle / Constants.Tau
    
    for section in colorSections.reverse() {
      drawRing(       section.color,
          fromStartTo: min(section.percentToEnd, percentVisible),
            inContext: ctx)
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
  

  func drawRing(    color: UIColor,
    fromStartTo percentage: CGFloat,
    inContext ctx: CGContext) {

      let maxRingWidthInPoints = maxRingRadius * ringWidth
      let ringWidthInPoints  = min(ringRadius, maxRingWidthInPoints)
      
      let maskDrawing = RingDrawing(center: center,
                               outerRadius: ringRadius + 2,
                                 ringWidth: ringWidthInPoints + 2,
                                startAngle: TauAngle(degrees: 0),
                                  endAngle: TauAngle(degrees: (360 * percentage)))
      maskDrawing.fillColor = color
      maskDrawing.style     = .Sharp
      
      maskDrawing.drawInContext(ctx)
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