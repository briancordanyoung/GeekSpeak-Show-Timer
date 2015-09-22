import Foundation
import UIKit



class RingDrawing: NSObject {
  
  struct Constant {
    static let Quarter = CGFloat(M_PI / 2)
  }
  
  struct GuideTypes {
    let lines: Bool
    let points: Bool
    let controlPoints: Bool
  }
  
  enum Style {
    case Rounded
    case RoundedWithGuides(GuideTypes)
    case Sharp
  }
  
  
  let center:      RingPoint
  let outerRadius: CGFloat
  let ringWidth:   CGFloat
  let startAngle:  TauAngle
  let endAngle:    TauAngle
  var fillColor  = UIColor.whiteColor()
  var lineColor  = UIColor.clearColor()
  var lineWidth  = CGFloat(0)
  var style      = Style.Sharp

  init(     center: RingPoint,
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

  convenience init(     center: RingPoint,
       outerRadius: CGFloat,
         ringWidth: CGFloat ) {
    self.init(center: center,
         outerRadius: outerRadius,
           ringWidth: ringWidth,
          startAngle: TauAngle(degrees: 0),
            endAngle: TauAngle(degrees: 360))
  }
  
  // CGFloat calculated of Angle properties
  var start: CGFloat {
    return CGFloat(startAngle) - Constant.Quarter
  }
  
  var end: CGFloat {
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
      case .Rounded,
           .RoundedWithGuides:
        return roundedMinimumAngle
      case .Sharp:
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
  
  func pointOnCircle(circle: RingCircle,
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
  

  var arcDirection: Int32 {
    return start > end ? 1 : 0
  }
  
  var reverseArcDirection: Int32 {
    return start > end ? 0 : 1
  }
  
  
  var outerOffsetStart: CGFloat {
    let offset = CGFloat(outerStart.angleBetweenPoint( outerBezStart,
                                     fromMutualCenter: center))
    return start + abs(offset)
  }
  
  var outterOffsetEnd: CGFloat {
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
  func drawInContext(context: CGContextRef) {
    switch style {
    case .Rounded:
      drawRoundedRing(context)
    case .RoundedWithGuides(let guides):
      drawRoundedRing(context)
      drawGuides(guides, inContext: context)
    case .Sharp:
      drawRing(context)
    }
  }

  private func drawGuides(guides: GuideTypes, inContext context: CGContextRef) {
    if guides.lines         { drawGuides(context)}
    if guides.points        { drawPoints(context)}
    if guides.controlPoints { drawControlPoints(context)}
  }
  
  private func drawRoundedRing(context: CGContextRef) {
    
    CGContextMoveToPoint(context, innerBezStart.x, innerBezStart.y)
    CGContextAddCurveToPoint(context,
                      innerBezStartControlPoint.x, innerBezStartControlPoint.y,
                      innerCapStartControlPoint.x, innerCapStartControlPoint.y,
                                  innerCapStart.x, innerCapStart.y)

    
    
    CGContextAddLineToPoint(context, outerCapStart.x, outerCapStart.y)
    CGContextAddCurveToPoint(context,
                      outerCapStartControlPoint.x,  outerCapStartControlPoint.y,
                      outerBezStartControlPoint.x,  outerBezStartControlPoint.y,
                      outerBezStart.x,              outerBezStart.y)
    
    CGContextAddArc(context, center.x, center.y, outerRadius,
                                   outerOffsetStart, outterOffsetEnd,
                                                        arcDirection)
    
    CGContextAddCurveToPoint(context,
                          outerBezEndControlPoint.x, outerBezEndControlPoint.y,
                          outerCapEndControlPoint.x, outerCapEndControlPoint.y,
                                      outerCapEnd.x, outerCapEnd.y)
    
    CGContextAddLineToPoint(context, innerCapEnd.x, innerCapEnd.y)

    CGContextAddCurveToPoint(context,
                          innerCapEndControlPoint.x, innerCapEndControlPoint.y,
                          innerBezEndControlPoint.x, innerBezEndControlPoint.y,
                                      innerBezEnd.x, innerBezEnd.y)

    
    CGContextAddArc(context, center.x, center.y, innerRadius,
                          innerOffsetEnd, innerOffsetStart, reverseArcDirection)
    
    CGContextClosePath(context)
    
    // Color it
    CGContextSetFillColorWithColor(context, fillColor.CGColor)
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
    CGContextSetLineWidth(context, lineWidth)
    
    // Draw in context
    CGContextDrawPath(context, .FillStroke)
  }
  
  private func drawRing(context: CGContextRef) {
    CGContextMoveToPoint(context, innerStart.x, innerStart.y)
    CGContextAddLineToPoint(context, outerStart.x, outerStart.y)
    CGContextAddArc(context, center.x, center.y,
      outerRadius,  start, end, arcDirection)
    
    CGContextAddLineToPoint(context, innerEnd.x, innerEnd.y)
    CGContextAddArc(context, center.x, center.y, innerRadius,
      end, start, reverseArcDirection)
    
    CGContextClosePath(context);
    
    // Color it
    CGContextSetFillColorWithColor(context, fillColor.CGColor)
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
    CGContextSetLineWidth(context, lineWidth)
    
    // Draw in context
    CGContextDrawPath(context, .FillStroke);
  }
  
  

  // MARK:
  // MARK: Draw dubugging lines and points
  private func drawDotInContext(context: CGContextRef, aroundPoint point: RingPoint) {
    let rect = CGRect(x: point.x - 1,
                      y: point.y - 1,
                  width: 2,
                 height: 2)
    let path = CGPathCreateMutable()
    CGPathAddEllipseInRect(path, nil, rect)
    CGContextAddPath(context, path)
    CGContextSetLineWidth(context, 1.0)
    CGContextDrawPath(context, .FillStroke)
  }
  
  
  private func drawPoints(context: CGContextRef) {
    CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
    CGContextSetFillColorWithColor(  context, UIColor.clearColor().CGColor)
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

  private func drawControlPoints(context: CGContextRef) {
    CGContextSetStrokeColorWithColor(context, UIColor.blueColor().CGColor)
    CGContextSetFillColorWithColor(  context, UIColor.clearColor().CGColor)
    drawDotInContext(context, aroundPoint: outerBezStartControlPoint)
    drawDotInContext(context, aroundPoint: outerCapEndControlPoint)
    drawDotInContext(context, aroundPoint: outerCapStartControlPoint)
    drawDotInContext(context, aroundPoint: outerBezEndControlPoint)
    
    drawDotInContext(context, aroundPoint: innerBezStartControlPoint)
    drawDotInContext(context, aroundPoint: innerCapEndControlPoint)
    drawDotInContext(context, aroundPoint: innerCapStartControlPoint)
    drawDotInContext(context, aroundPoint: innerBezEndControlPoint)
    
  }
  

  
  
  private func drawGuides(context: CGContextRef) {
    CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
    CGContextSetLineWidth(context, 0.5)

    CGContextMoveToPoint(context, center.x, center.y)
    CGContextAddLineToPoint(context, outerBezStart.x, outerBezStart.y)
    CGContextDrawPath(context, .FillStroke);

    CGContextMoveToPoint(context, center.x, center.y)
    CGContextAddLineToPoint(context, outerBezEnd.x, outerBezEnd.y)
    CGContextDrawPath(context, .FillStroke);

    CGContextMoveToPoint(context, center.x, center.y)
    CGContextAddLineToPoint(context, innerBezStart.x, innerBezStart.y)
    CGContextDrawPath(context, .FillStroke);
    
    CGContextMoveToPoint(context, center.x, center.y)
    CGContextAddLineToPoint(context, innerBezEnd.x, innerBezEnd.y)
  }
  
  
  


}