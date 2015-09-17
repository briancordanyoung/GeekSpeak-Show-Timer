// Ring Classes:  Refactor!!!
//                The classes for drawing and layingout the ring are completely
//                messing confussing, uses similar but different propery  names
//                mix obj-c and swift cause type conversions that are confusing
//                and general a mess.  Clean this mess up!!!
//                Draw cleanly and be nice.  ;)
//
//                  GSTRing.h
//                  GSTRing.m
//                  GSTRingLayer.h
//                  RingCircle.swift
//                  RingFillView.swift
//                  RingPoint.swift
//                  RingView+Progress.swift
//                  RingView.swift

import Foundation
import UIKit

class RingDrawing: NSObject {
  let center: RingPoint
  let outerRadius: CGFloat
  let innerRadius: CGFloat
  let startAngle: Rotation
  let endAngle: Rotation
  let cornerRoundingPercentage: CGFloat
  var fillColor = UIColor.whiteColor()
  var lineColor = UIColor.clearColor()
  var lineWidth = CGFloat(0)

  init(             center: RingPoint,
               outerRadius: CGFloat,
               innerRadius: CGFloat,
                startAngle: CGFloat,
                  endAngle: CGFloat,
  cornerRoundingPercentage: CGFloat) {
                 self.center      = center
                 self.outerRadius = outerRadius
                 self.innerRadius = innerRadius
                 self.startAngle  = Rotation(startAngle)
                 self.endAngle    = Rotation(endAngle)
    self.cornerRoundingPercentage = cornerRoundingPercentage
  }

  convenience init(     center: RingPoint,
                   outerRadius: CGFloat,
                   innerRadius: CGFloat ) {
    self.init(             center: center,
                       outerRadius: outerRadius,
                       innerRadius: innerRadius,
                        startAngle: CGFloat(Rotation(degrees: 0)),
                          endAngle: CGFloat(Rotation(degrees: 360)),
          cornerRoundingPercentage: CGFloat(0))
  }
  
  // CGFloat calculated of Angle properties
  var start: CGFloat {
    return CGFloat(startAngle)
  }
  
  var end: CGFloat {
    return CGFloat(endAngle)
  }
  
  
  
  
  var ringWidth: CGFloat {
    return outerRadius - innerRadius
  }
  
  var midOffset: CGFloat {
    return ringWidth * cornerRoundingPercentage
  }
  
  var controlPointOffset: CGFloat {
    return midOffset - (midOffset * 0.8)
  }

  
  var innerMidRadius: CGFloat {
    return innerRadius + midOffset
  }
  
  var outerMidRadius: CGFloat {
    return outerRadius - midOffset
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

  
  var innerBezStart: RingPoint {
    var bezStart = innerStart
    
    let small  = RingCircle( center: innerStart ,radius: midOffset )
    let points = innerCircle.intersecetions(small)
    
    if points.count == 2 {
      let angle0 = points[0].angleBetweenPoint( innerStart,
                              fromMutualCenter: center)
      let angle1 = points[1].angleBetweenPoint( innerStart,
                              fromMutualCenter: center)
      
      if angle0 > angle1 {
        bezStart = points[0]
      } else {
        bezStart = points[1]
      }
    }
    return bezStart
  }
  
  var outerBezStart: RingPoint {
    var bezStart = outerStart
    
    let small  = RingCircle( center: outerStart ,radius: midOffset * 1.2 )
    let points = outerCircle.intersecetions(small)
    
    if points.count == 2 {
      let angle0 = points[0].angleBetweenPoint( outerStart,
                              fromMutualCenter: center)
      let angle1 = points[1].angleBetweenPoint( outerStart,
                              fromMutualCenter: center)
      
      if angle0 > angle1 {
        bezStart = points[0]
      } else {
        bezStart = points[1]
      }
    }
    return bezStart
  }
  
  
  var innerBezEnd: RingPoint {
    var bezStart = innerEnd
    
    let small  = RingCircle( center: innerEnd ,radius: midOffset )
    let points = innerCircle.intersecetions(small)
    
    if points.count == 2 {
      let angle0 = points[0].angleBetweenPoint( innerEnd,
                              fromMutualCenter: center)
      let angle1 = points[1].angleBetweenPoint( innerEnd,
                              fromMutualCenter: center)
      
      if angle0 < angle1 {
        bezStart = points[0]
      } else {
        bezStart = points[1]
      }
    }
    return bezStart
  }
  
  var outerBezEnd: RingPoint {
    var bezStart = outerEnd
    
    let small  = RingCircle( center: outerEnd ,radius: midOffset * 1.2 )
    let points = outerCircle.intersecetions(small)
    
    if points.count == 2 {
      let angle0 = points[0].angleBetweenPoint( outerEnd,
                              fromMutualCenter: center)
      let angle1 = points[1].angleBetweenPoint( outerEnd,
                              fromMutualCenter: center)
      
      if angle0 < angle1 {
        bezStart = points[0]
      } else {
        bezStart = points[1]
      }
    }
    return bezStart
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
    return startAngle > endAngle ? 1 : 0
  }
  
  var reverseArcDirection: Int32 {
    return startAngle > endAngle ? 0 : 1
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

  
//  sdgdfgsdfgsfdfgsdfgsdfg
  
  
  
  func drawRoundedRing(context: CGContextRef) {
    
    CGContextMoveToPoint(context, innerBezStart.x, innerBezStart.y)
//    CGContextAddLineToPoint(context, innerCapStart.x, innerCapStart.y)
    CGContextAddQuadCurveToPoint(context, innerStart.x, innerStart.y, innerCapStart.x, innerCapStart.y)
    CGContextAddLineToPoint(context, outerCapStart.x, outerCapStart.y)
//    CGContextAddLineToPoint(context, outerBezStart.x, outerBezStart.y)
    CGContextAddQuadCurveToPoint(context, outerStart.x, outerStart.y, outerBezStart.x, outerBezStart.y)
    CGContextAddArc(context, center.x, center.y, outerRadius,
                                   outerOffsetStart, outterOffsetEnd, arcDirection)
    
//    CGContextAddLineToPoint(context, outerCapEnd.x, outerCapEnd.y)
    CGContextAddQuadCurveToPoint(context, outerEnd.x, outerEnd.y, outerCapEnd.x, outerCapEnd.y)
    CGContextAddLineToPoint(context, innerCapEnd.x, innerCapEnd.y)
//    CGContextAddLineToPoint(context, innerBezEnd.x, innerBezEnd.y)
    CGContextAddQuadCurveToPoint(context, innerEnd.x, innerEnd.y, innerBezEnd.x, innerBezEnd.y)
    CGContextAddArc(context, center.x, center.y, innerRadius,
                                    innerOffsetEnd, innerOffsetStart, reverseArcDirection)
    
    CGContextClosePath(context);
    
    // Color it
    CGContextSetFillColorWithColor(context, fillColor.CGColor)
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
    CGContextSetLineWidth(context, lineWidth)
    
    // Draw in context
    CGContextDrawPath(context, CGPathDrawingMode.FillStroke);
  }
  
  func drawGuides(context: CGContextRef) {
    CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
    CGContextSetLineWidth(context, 0.5)

    CGContextMoveToPoint(context, center.x, center.y)
    CGContextAddLineToPoint(context, outerBezStart.x, outerBezStart.y)
    CGContextDrawPath(context, CGPathDrawingMode.FillStroke);

    CGContextMoveToPoint(context, center.x, center.y)
    CGContextAddLineToPoint(context, outerBezEnd.x, outerBezEnd.y)
    CGContextDrawPath(context, CGPathDrawingMode.FillStroke);

    CGContextMoveToPoint(context, center.x, center.y)
    CGContextAddLineToPoint(context, innerBezStart.x, innerBezStart.y)
    CGContextDrawPath(context, CGPathDrawingMode.FillStroke);
    
    CGContextMoveToPoint(context, center.x, center.y)
    CGContextAddLineToPoint(context, innerBezEnd.x, innerBezEnd.y)
    CGContextDrawPath(context, CGPathDrawingMode.FillStroke);
  }
  

  func drawRing(context: CGContextRef) {
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
    CGContextDrawPath(context, CGPathDrawingMode.FillStroke);
  }
  
  func drawInContext(context: CGContextRef) {
//    drawGuides(context)
    
//    let tmpColor = lineColor
//    let tmpWidth = lineWidth
//    lineWidth = 2
//    lineColor = UIColor.grayColor()
//    drawOriginal(context)
//    lineColor = tmpColor
//    lineWidth = tmpWidth
    if cornerRoundingPercentage == 0 {
      drawRing(context)
    } else {
      drawRoundedRing(context)
    }
  }

}

