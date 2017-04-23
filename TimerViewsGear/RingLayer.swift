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
    static let DefaultColor = UIColor.white
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
  fileprivate var _colors: [RingColor] = [RingColor(portion: 1.0,
                                                  color: Constants.DefaultColor)]
  var ringStyle: RingDrawing.Style = .rounded {
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
      let portionTotal = colors.reduce(CGFloat(0), {$0 + $1.portion})
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
    backgroundColor = UIColor.clear.cgColor
    isOpaque = false
    self.needsDisplay()
  }
  
  override init(layer: Any) {
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
    backgroundColor = UIColor.clear.cgColor
    isOpaque = false
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
    backgroundColor = UIColor.clear.cgColor
    isOpaque = false
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
    startAngle = CGFloat(aDecoder.decodeDouble(forKey: Constants.StartAngle))
    endAngle   = CGFloat(aDecoder.decodeDouble(forKey: Constants.EndAngle))
    ringWidth  = CGFloat( aDecoder.decodeDouble(forKey: Constants.RingWidth))
    fillScale  = CGFloat( aDecoder.decodeDouble(forKey: Constants.FillScale))
    backgroundColor = UIColor.clear.cgColor
    isOpaque = false
    switch aDecoder.decodeCInt(forKey: Constants.RingStyle) {
    case 0:
      ringStyle = .rounded
    case 1:
      ringStyle = .sharp
    default:
      ringStyle = .rounded
    }
    // TODO: Add encoder/decoder for colors
  }
  
  
  override func encode(with aCoder: NSCoder) {
    super.encode(with: aCoder)
    aCoder.encode(Double(startAngle), forKey: Constants.StartAngle)
    aCoder.encode(Double(endAngle),   forKey: Constants.EndAngle)
    aCoder.encode(Double(ringWidth),  forKey: Constants.RingWidth)
    aCoder.encode(Double(fillScale),  forKey: Constants.FillScale)
    switch ringStyle {
    case .rounded,
         .roundedWithGuides:
      aCoder.encodeCInt(0, forKey: Constants.RingStyle)
    case .sharp:
      aCoder.encodeCInt(1, forKey: Constants.RingStyle)
    }
  }

  
  
  // MARK: Internal Computed Properties
  // Internally offset the angles so that they start drawing at the top
  
  fileprivate var start: TauAngle {
    return TauAngle(startAngle)
  }
  
  fileprivate var end: TauAngle {
    return TauAngle(endAngle)
  }
    
  fileprivate var center: RingPoint {
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
  
  fileprivate var maxRingRadius: CGFloat {
    return min(self.bounds.size.width , self.bounds.size.height) / 2
  }
  
  fileprivate var ringRadius: CGFloat {
    return maxRingRadius * fillScale
  }
  
  
  // MARK: Drawing
  override func draw(in ctx: CGContext) {
    
    maskRingInContext(ctx)
    
    let percentVisible = endAngle / Constants.Tau
    
    for section in colorSections.reversed() {
      drawRing(       section.color,
          fromStartTo: min(section.percentToEnd, percentVisible),
            inContext: ctx)
    }
  }
  
  func maskRingInContext(_ ctx: CGContext) {
    guard let maskCTX   = CGContext( data: nil,
                          width: ctx.width,
                          height: ctx.height,
                          bitsPerComponent: ctx.bitsPerComponent,
                          bytesPerRow: ctx.bytesPerRow,
                          space: CGColorSpaceCreateDeviceGray(),
                          bitmapInfo: UInt32(0) /* kCGImageAlphaNone */) else {return}
    
    let rect = CGRect(x: 0 , y: 0,
                          width: CGFloat(ctx.width),
                          height: CGFloat(ctx.height))
    
    let maskOutColor = UIColor.black.cgColor
    let maskInColor  = UIColor.white
    
    maskCTX.setFillColor(maskOutColor)
    maskCTX.fill(rect)
    
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
    let ringMask = maskCTX.makeImage()
    
    ctx.clip(to: rect, mask: ringMask!)
  }
  

  func drawRing(    _ color: UIColor,
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
      maskDrawing.style     = .sharp
      
      maskDrawing.drawInContext(ctx)
  }
  
  
  
  // MARK: Animation
  // Allows CoreAnimation to animate these parameters.
  override class func needsDisplay(forKey key: String) -> Bool {
    if key == "startAngle" ||
       key == "endAngle" ||
       key == "ringWidth" {
        return true
      } else {
        return false
    }
  }
  
  func makeAnimationForKey(_ key: String) -> CABasicAnimation {
    let anim = CABasicAnimation(keyPath: key)
    anim.fromValue = presentation()?.value(forKey: key)
    anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
    anim.duration = 0.0
    return anim
  }
  
}
