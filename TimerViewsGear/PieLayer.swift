import UIKit
import AngleGear

final class PieLayer: CALayer {
  
  struct Constants {
    static let StartAngle   = "pieLayerStartAngleId"
    static let EndAngle     = "pieLayerEndAngleId"
    static let ClipToCircle = "pieLayerClipToCircleId"
    static let FillColor    = "pieLayerFillColorId"
  }
  
  enum Polarity {
    case positive
    case negative
  }
  
  @NSManaged var startAngle: CGFloat
  @NSManaged var endAngle: CGFloat
  
  var clipToCircle = true
  var fillColor = UIColor.white
  var polarity: Polarity = .positive
  
  
  
  // MARK: Internal Computed Properties
  fileprivate var center: CGPoint {
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
  
  fileprivate var radius: CGFloat {
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
  
  override init(layer: Any) {
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
    startAngle   = CGFloat(aDecoder.decodeDouble(forKey: Constants.StartAngle))
    endAngle     = CGFloat(aDecoder.decodeDouble(forKey: Constants.EndAngle))
    clipToCircle = aDecoder.decodeBool(forKey: Constants.ClipToCircle)
    // TODO: decode Color
  }
  
  
  override func encode(with aCoder: NSCoder) {
    super.encode(with: aCoder)
    aCoder.encode(Double(startAngle), forKey: Constants.StartAngle)
    aCoder.encode(Double(endAngle),   forKey: Constants.EndAngle)
    aCoder.encode(clipToCircle,         forKey: Constants.ClipToCircle)
    // TODO: encode Color
  }
  
  
  
  
  // MARK: Drawing
  override func draw(in ctx: CGContext) {
    
    let halfPi = (Double.pi / 2)
    let offset = startAngle > endAngle ? CGFloat(halfPi) : -CGFloat(halfPi)
    let start = startAngle + offset
    let end   = endAngle   + offset
    
    ctx.beginPath()
    ctx.move(to: CGPoint(x: center.x, y: center.y))
    
    let p1 = CGPoint(x: center.x + radius * cos(start),
      y: center.y + radius * sin(start))
    ctx.addLine(to: CGPoint(x: p1.x, y: p1.y))
    
    let clockwise: Bool
    
    if polarity == .positive {
      clockwise = start > end ? true : false
    } else {
      clockwise = start > end ? false : true
    }
    
    ctx.addArc(center: center,
                   radius: radius,
                   startAngle: start,
                   endAngle: end,
                   clockwise: clockwise)

    ctx.closePath();
    
    ctx.setFillColor(self.fillColor.cgColor)
    ctx.setStrokeColor(self.fillColor.cgColor)
    ctx.setLineWidth(2.0)
    
    ctx.drawPath(using: .fill)
    
  }
  
  // MARK: Animation
  // Allows CoreAnimation to animate these parameters.
  override class func needsDisplay(forKey key: String) -> Bool {
    if key == "startAngle" ||
      key == "endAngle"      {
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

