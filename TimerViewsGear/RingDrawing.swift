import Foundation
import UIKit
import AngleGear



open class RingDrawing: NSObject {
  
  public struct Constant {
    static let Quarter = CGFloat(M_PI / 2)
  }
  
  public struct GuideTypes {
    let lines: Bool
    let points: Bool
    let controlPoints: Bool
  }
  
  public enum Style {
    case rounded
    case roundedWithGuides(GuideTypes)
    case sharp
  }
  
  
  open let center:      RingPoint
  open let outerRadius: CGFloat
  open let ringWidth:   CGFloat
  open let startAngle:  TauAngle
  open let endAngle:    TauAngle
  open var fillColor  = UIColor.white
  open var lineColor  = UIColor.clear
  open var lineWidth  = CGFloat(0)
  open var style      = Style.sharp

  public init(     center: RingPoint,
       outerRadius: CGFloat,
         ringWidth: CGFloat,
        startAngle: TauAngle,
          endAngle: TauAngle) {
            self.center      = center
            self.outerRadius = outerRadius
            self.ringWidth   = ringWidth
            self.startAngle  = startAngle
            self.endAngle    = endAngle
  }

  public convenience init(     center: RingPoint,
       outerRadius: CGFloat,
         ringWidth: CGFloat ) {
    self.init(center: center,
         outerRadius: outerRadius,
           ringWidth: ringWidth,
          startAngle: TauAngle(degrees: 0),
            endAngle: TauAngle(degrees: 360))
  }
  
  // CGFloat calculated of Angle properties
  open var start: CGFloat {
    return CGFloat(startAngle) - Constant.Quarter
  }
  
  open var end: CGFloat {
    if abs(CGFloat(startAngle) - CGFloat(endAngle)) < CGFloat(minimumAngle) {
      return CGFloat(startAngle) +
             CGFloat(minimumAngle) +
             CGFloat(TauAngle(degrees: 0.1)) -
             Constant.Quarter
    } else {
      return CGFloat(endAngle) - Constant.Quarter
    }
  }
  
  var minimumAngle: TauAngle {
    let roundedEndWidth = innerStart.angleBetweenPoint( innerBezStart,
                                      fromMutualCenter: center)
    let roundedMinimumAngle = abs(roundedEndWidth) * 2
    
    switch style {
      case .rounded,
           .roundedWithGuides:
        return roundedMinimumAngle
      case .sharp:
        return TauAngle(degrees: 0)
    }
  }
  
  var innerOuterRingRatio: CGFloat {
    return (1.0 + (innerRadius / outerRadius)) / 2
  }
  
  var innerRadius: CGFloat {
    let radius = outerRadius - ringWidth
    return max(radius,0)
  }
  
  var midOffset: CGFloat {
    return ringWidth * 0.3
  }
  
  var capMidOffset: CGFloat {
    return ringWidth * 0.5
  }
  
  var controlPointOffset: CGFloat {
    return midOffset - (midOffset * 0.5)
  }

  var controlPointOffsetInverse: CGFloat {
    return midOffset - controlPointOffset
  }

  
  var innerMidRadius: CGFloat {
    return innerRadius + capMidOffset
  }
  
  var outerMidRadius: CGFloat {
    return outerRadius - capMidOffset
  }

  
  var innerControlPointRadius: CGFloat {
    return innerRadius + controlPointOffset
  }
  
  var outerControlPointRadius: CGFloat {
    return outerRadius - controlPointOffset
  }
  
  var innerCircle: RingCircle {
    return RingCircle( center: center ,radius: innerRadius )
  }
  
  var outerCircle: RingCircle {
    return RingCircle( center: center ,radius: outerRadius )
  }
  
  
  var innerStart: RingPoint {
    let x = center.x + innerRadius * cos(start)
    let y = center.y + innerRadius * sin(start)
    return RingPoint(x:x, y:y)
  }
  
  var innerCapStart: RingPoint {
    let x = center.x + innerMidRadius * cos(start)
    let y = center.y + innerMidRadius * sin(start)
    return RingPoint(x:x, y:y)
  }
  
  var innerCapStartControlPoint: RingPoint {
    let x = center.x + innerControlPointRadius * cos(start)
    let y = center.y + innerControlPointRadius * sin(start)
    return RingPoint(x:x, y:y)
  }
  
  var outerCapStart: RingPoint {
    let x = center.x + outerMidRadius * cos(start)
    let y = center.y + outerMidRadius * sin(start)
    return RingPoint(x:x, y:y)
  }
  
  var outerCapStartControlPoint: RingPoint {
    let x = center.x + outerControlPointRadius * cos(start)
    let y = center.y + outerControlPointRadius * sin(start)
    return RingPoint(x:x, y:y)
  }
  
  var outerStart: RingPoint {
    let x = center.x + outerRadius * cos(start)
    let y = center.y + outerRadius * sin(start)
    return RingPoint(x:x, y:y)
  }

  
  
  enum Direction {
    case clockwise
    case counterClockwise
  }
  
  func pointOnCircle(_ circle: RingCircle,
        atDistance distance: CGFloat,
            fromPoint point: RingPoint,
      inDirection direction: Direction) -> RingPoint {
    var newPoint = point

    let small  = RingCircle( center: point ,radius: distance )
    let points = circle.intersecetions(small)

    if points.count == 2 {
      let angle0 = points[0].angleBetweenPoint( point,
                              fromMutualCenter: center)
      let angle1 = points[1].angleBetweenPoint( point,
                              fromMutualCenter: center)
      
      if angle0 > angle1 {
        newPoint = points[0]
      } else {
        newPoint = points[1]
      }
      
      switch (angle0 > angle1 , direction) {
      case (true, .clockwise):
        newPoint = points[0]
      case (true, .counterClockwise):
        newPoint = points[1]
      case (false, .clockwise):
        newPoint = points[1]
      case (false, .counterClockwise):
        newPoint = points[0]
      }
      
    }
    return newPoint
  }
  
  
  
  var innerBezStart: RingPoint {
    return pointOnCircle( innerCircle,
              atDistance: midOffset * innerOuterRingRatio,
               fromPoint: innerStart,
             inDirection: .clockwise)
  }
  
  var innerBezStartControlPoint: RingPoint {
    return pointOnCircle( innerCircle,
              atDistance: controlPointOffset * innerOuterRingRatio,
               fromPoint: innerStart,
             inDirection: .clockwise)
  }
  
  var outerBezStart: RingPoint {
    return pointOnCircle( outerCircle,
              atDistance: midOffset,
               fromPoint: outerStart,
             inDirection: .clockwise)
  }
  
  
  var outerBezStartControlPoint: RingPoint {
    let outerBezStartAngle = outerBezStart.angleFromCenter(center)

    let tangent      = CGFloat(outerBezStartAngle) - Constant.Quarter
    
    let x = outerBezStart.x + controlPointOffsetInverse * cos(tangent)
    let y = outerBezStart.y + controlPointOffsetInverse * sin(tangent)

    return RingPoint(x: x, y: y)
  }
  
  var innerBezEnd: RingPoint {
    return pointOnCircle( innerCircle,
              atDistance: midOffset * innerOuterRingRatio,
               fromPoint: innerEnd,
             inDirection: .counterClockwise)
  }
  
  var innerBezEndControlPoint: RingPoint {
    return pointOnCircle( innerCircle,
              atDistance: controlPointOffset * innerOuterRingRatio,
               fromPoint: innerEnd,
             inDirection: .counterClockwise)
  }
  
  var outerBezEnd: RingPoint {
    return pointOnCircle( outerCircle,
              atDistance: midOffset,
               fromPoint: outerEnd,
             inDirection: .counterClockwise)
  }
  
  var outerBezEndControlPoint: RingPoint {
    let outerBezEndAngle = outerBezEnd.angleFromCenter(center)
    
    let tangentAngle = outerBezEndAngle + TauAngle(degrees: 90)
    let tangent      = CGFloat(tangentAngle)
    
    let x = outerBezEnd.x + controlPointOffsetInverse * cos(tangent)
    let y = outerBezEnd.y + controlPointOffsetInverse * sin(tangent)
    
    return RingPoint(x: x, y: y)
  }
  
  
  
  
  
  var innerEnd: RingPoint {
    let x = center.x + innerRadius * cos(end)
    let y = center.y + innerRadius * sin(end)
    return RingPoint(x:x, y:y)
  }
  
  var innerCapEndControlPoint: RingPoint {
    let x = center.x + innerControlPointRadius * cos(end)
    let y = center.y + innerControlPointRadius * sin(end)
    return RingPoint(x:x, y:y)
  }
  
  var innerCapEnd: RingPoint {
    let x = center.x + innerMidRadius * cos(end)
    let y = center.y + innerMidRadius * sin(end)
    return RingPoint(x:x, y:y)
  }
  
  var outerCapEnd: RingPoint {
    let x = center.x + outerMidRadius * cos(end)
    let y = center.y + outerMidRadius * sin(end)
    return RingPoint(x:x, y:y)
  }
  
  var outerCapEndControlPoint: RingPoint {
    let x = center.x + outerControlPointRadius * cos(end)
    let y = center.y + outerControlPointRadius * sin(end)
    return RingPoint(x:x, y:y)
  }
  
  var outerEnd: RingPoint {
    let x = center.x + outerRadius * cos(end)
    let y = center.y + outerRadius * sin(end)
    return RingPoint(x:x, y:y)
  }
  

  var arcDirection: Bool {
    return start > end ? true : false
  }
  
  var reverseArcDirection: Bool {
    return start > end ? false : true
  }
  
  
  var outerOffsetStart: CGFloat {
    let offset = CGFloat(outerStart.angleBetweenPoint( outerBezStart,
                                     fromMutualCenter: center))
    return start + abs(offset)
  }
  
  var outerOffsetEnd: CGFloat {
    let offset = CGFloat(outerEnd.angleBetweenPoint( outerBezEnd,
                                   fromMutualCenter: center))
    return end - abs(offset)
  }
  
  var innerOffsetStart: CGFloat {
    let offset = CGFloat(outerStart.angleBetweenPoint( innerBezStart,
                                     fromMutualCenter: center))
    return start + abs(offset)
  }
  
  var innerOffsetEnd: CGFloat {
    let offset = CGFloat(outerEnd.angleBetweenPoint( innerBezEnd,
                                   fromMutualCenter: center))
    return end - abs(offset)
  }

  
  
  // MARK:
  // MARK: Drawing
  func drawInContext(_ context: CGContext) {
    switch style {
    case .rounded:
      drawRoundedRing(context)
    case .roundedWithGuides(let guides):
      drawRoundedRing(context)
      drawGuides(guides, inContext: context)
    case .sharp:
      drawRing(context)
    }
  }

  fileprivate func drawGuides(_ guides: GuideTypes, inContext context: CGContext) {
    if guides.lines         { drawGuides(context)}
    if guides.points        { drawPoints(context)}
    if guides.controlPoints { drawControlPoints(context)}
  }
  
  fileprivate func drawRoundedRing(_ context: CGContext) {
    
    context.move(to: innerBezStart.point)
    context.addCurve(to: innerCapStart.point,
                     control1: innerBezStartControlPoint.point,
                     control2: innerCapStartControlPoint.point)
    
    context.addLine(to: outerCapStart.point)
    context.addCurve(to: outerBezStart.point,
                     control1: outerCapStartControlPoint.point,
                     control2: outerBezStartControlPoint.point)
    
    context.addArc(center: center.point,
                   radius: outerRadius,
                   startAngle: outerOffsetStart,
                   endAngle: outerOffsetEnd,
                   clockwise: arcDirection)
    
    context.addCurve(to: outerCapEnd.point,
                     control1: outerBezEndControlPoint.point,
                     control2: outerCapEndControlPoint.point)

    context.addLine(to: innerCapEnd.point)

    context.addCurve(to: innerBezEnd.point,
                     control1: innerCapEndControlPoint.point,
                     control2: innerBezEndControlPoint.point)

    context.addArc(center: center.point,
                   radius: innerRadius,
                   startAngle: innerOffsetEnd,
                   endAngle: innerOffsetStart,
                   clockwise: reverseArcDirection)
    
    context.closePath()
    
    // Color it
    context.setFillColor(fillColor.cgColor)
    context.setStrokeColor(lineColor.cgColor)
    context.setLineWidth(lineWidth)
    
    // Draw in context
    context.drawPath(using: .fillStroke)
  }
  
  fileprivate func drawRing(_ context: CGContext) {
    context.move(to: innerStart.point)
    context.addLine(to: outerStart.point)
    context.addArc(center: center.point,
                   radius: outerRadius,
                   startAngle: start,
                   endAngle: end,
                   clockwise: arcDirection)

    
    context.addLine(to: innerEnd.point)
    context.addArc(center: center.point,
                   radius: innerRadius,
                   startAngle: start,
                   endAngle: end,
                   clockwise: reverseArcDirection)
    
    context.closePath();
    
    // Color it
    context.setFillColor(fillColor.cgColor)
    context.setStrokeColor(lineColor.cgColor)
    context.setLineWidth(lineWidth)
    
    // Draw in context
    context.drawPath(using: .fillStroke);
  }
  
  

  // MARK:
  // MARK: Draw dubugging lines and points
  fileprivate func drawDotInContext(_ context: CGContext, aroundPoint point: RingPoint) {
    let rect = CGRect(x: point.x - 1,
                      y: point.y - 1,
                  width: 2,
                 height: 2)
    let path = CGMutablePath()
    path.addEllipse(in: rect)
    context.addPath(path)
    context.setLineWidth(1.0)
    context.drawPath(using: .fillStroke)
  }
  
  
  fileprivate func drawPoints(_ context: CGContext) {
    context.setStrokeColor(UIColor.red.cgColor)
    context.setFillColor(UIColor.clear.cgColor)
    drawDotInContext(context, aroundPoint: outerStart)
    drawDotInContext(context, aroundPoint: outerEnd)
    drawDotInContext(context, aroundPoint: outerCapEnd)
    drawDotInContext(context, aroundPoint: outerCapStart)
    drawDotInContext(context, aroundPoint: outerBezStart)
    drawDotInContext(context, aroundPoint: outerBezEnd)
    
    drawDotInContext(context, aroundPoint: innerStart)
    drawDotInContext(context, aroundPoint: innerEnd)
    drawDotInContext(context, aroundPoint: innerCapEnd)
    drawDotInContext(context, aroundPoint: innerCapStart)
    drawDotInContext(context, aroundPoint: innerBezStart)
    drawDotInContext(context, aroundPoint: innerBezEnd)
  
  }

  fileprivate func drawControlPoints(_ context: CGContext) {
    context.setStrokeColor(UIColor.blue.cgColor)
    context.setFillColor(UIColor.clear.cgColor)
    drawDotInContext(context, aroundPoint: outerBezStartControlPoint)
    drawDotInContext(context, aroundPoint: outerCapEndControlPoint)
    drawDotInContext(context, aroundPoint: outerCapStartControlPoint)
    drawDotInContext(context, aroundPoint: outerBezEndControlPoint)
    
    drawDotInContext(context, aroundPoint: innerBezStartControlPoint)
    drawDotInContext(context, aroundPoint: innerCapEndControlPoint)
    drawDotInContext(context, aroundPoint: innerCapStartControlPoint)
    drawDotInContext(context, aroundPoint: innerBezEndControlPoint)
    
  }
  

  
  
  fileprivate func drawGuides(_ context: CGContext) {
    context.setStrokeColor(UIColor.red.cgColor)
    context.setLineWidth(0.5)

    context.move(to: center.point)
    context.addLine(to: outerBezStart.point)
    context.drawPath(using: .fillStroke);

    context.move(to: center.point)
    context.addLine(to: outerBezEnd.point)
    context.drawPath(using: .fillStroke);

    context.move(to: center.point)
    context.addLine(to: innerBezStart.point)
    context.drawPath(using: .fillStroke);
    
    context.move(to: center.point)
    context.addLine(to: innerBezEnd.point)
  }
  
  
  


}
