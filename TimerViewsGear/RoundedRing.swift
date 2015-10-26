import UIKit
import AngleGear

public struct RoundedRing {
    public let center:           RingPoint
    public let innerRadius:      CGFloat
    public let outerRadius:      CGFloat
    public let outerOffsetStart: CGFloat
    public let outerOffsetEnd:   CGFloat
    public let innerOffsetEnd:   CGFloat
    public let innerOffsetStart: CGFloat
    public let innerBezStart:             RingRadialPoint
    public let innerBezStartControlPoint: RingRadialPoint
    public let innerCapStartControlPoint: RingRadialPoint
    public let innerCapStart:             RingRadialPoint
    public let outerCapStart:             RingRadialPoint
    public let outerCapStartControlPoint: RingRadialPoint
    public let outerBezStartControlPoint: RingRadialPoint
    public let outerBezStart:             RingRadialPoint
    public let outerBezEndControlPoint:   RingRadialPoint
    public let outerCapEndControlPoint:   RingRadialPoint
    public let outerCapEnd:               RingRadialPoint
    public let innerCapEnd:               RingRadialPoint
    public let innerCapEndControlPoint:   RingRadialPoint
    public let innerBezEndControlPoint:   RingRadialPoint
    public let innerBezEnd:               RingRadialPoint
  
  public init( center:    RingPoint,
        innerRadius:      CGFloat,
        outerRadius:      CGFloat,
        outerOffsetStart: CGFloat,
        outerOffsetEnd:   CGFloat,
        innerOffsetEnd:   CGFloat,
        innerOffsetStart: CGFloat,
        innerBezStart:             RingRadialPoint,
        innerBezStartControlPoint: RingRadialPoint,
        innerCapStartControlPoint: RingRadialPoint,
        innerCapStart:             RingRadialPoint,
        outerCapStart:             RingRadialPoint,
        outerCapStartControlPoint: RingRadialPoint,
        outerBezStartControlPoint: RingRadialPoint,
        outerBezStart:             RingRadialPoint,
        outerBezEndControlPoint:   RingRadialPoint,
        outerCapEndControlPoint:   RingRadialPoint,
        outerCapEnd:               RingRadialPoint,
        innerCapEnd:               RingRadialPoint,
        innerCapEndControlPoint:   RingRadialPoint,
        innerBezEndControlPoint:   RingRadialPoint,
        innerBezEnd:               RingRadialPoint ) {
          self.center                     = center
          self.innerRadius                = innerRadius
          self.outerRadius                = outerRadius
          self.outerOffsetStart           = outerOffsetStart
          self.outerOffsetEnd             = outerOffsetEnd
          self.innerOffsetEnd             = innerOffsetEnd
          self.innerOffsetStart           = innerOffsetStart
          self.innerBezStart              = innerBezStart
          self.innerBezStartControlPoint  = innerBezStartControlPoint
          self.innerCapStartControlPoint  = innerCapStartControlPoint
          self.innerCapStart              = innerCapStart
          self.outerCapStart              = outerCapStart
          self.outerCapStartControlPoint  = outerCapStartControlPoint
          self.outerBezStartControlPoint  = outerBezStartControlPoint
          self.outerBezStart              = outerBezStart
          self.outerBezEndControlPoint    = outerBezEndControlPoint
          self.outerCapEndControlPoint    = outerCapEndControlPoint
          self.outerCapEnd                = outerCapEnd
          self.innerCapEnd                = innerCapEnd
          self.innerCapEndControlPoint    = innerCapEndControlPoint
          self.innerBezEndControlPoint    = innerBezEndControlPoint
          self.innerBezEnd                = innerBezEnd
  }
  
  public init( center:    RingPoint,
        innerRadius:      CGFloat,
        outerRadius:      CGFloat,
        outerOffsetStart: CGFloat,
        outerOffsetEnd:   CGFloat,
        innerOffsetEnd:   CGFloat,
        innerOffsetStart: CGFloat,
        innerBezStart:             RingPoint,
        innerBezStartControlPoint: RingPoint,
        innerCapStartControlPoint: RingPoint,
        innerCapStart:             RingPoint,
        outerCapStart:             RingPoint,
        outerCapStartControlPoint: RingPoint,
        outerBezStartControlPoint: RingPoint,
        outerBezStart:             RingPoint,
        outerBezEndControlPoint:   RingPoint,
        outerCapEndControlPoint:   RingPoint,
        outerCapEnd:               RingPoint,
        innerCapEnd:               RingPoint,
        innerCapEndControlPoint:   RingPoint,
        innerBezEndControlPoint:   RingPoint,
        innerBezEnd:               RingPoint ) {
          self.center           = center
          self.innerRadius      = innerRadius
          self.outerRadius      = outerRadius
          self.outerOffsetStart = outerOffsetStart
          self.outerOffsetEnd   = outerOffsetEnd
          self.innerOffsetEnd   = innerOffsetEnd
          self.innerOffsetStart = innerOffsetStart
          self.innerBezStart             = innerBezStart
                                           .ringRadialPointUsingCenter(center)
          self.innerBezStartControlPoint = innerBezStartControlPoint
                                           .ringRadialPointUsingCenter(center)
          self.innerCapStartControlPoint = innerCapStartControlPoint
                                            .ringRadialPointUsingCenter(center)
          self.innerCapStart             = innerCapStart
                                           .ringRadialPointUsingCenter(center)
          self.outerCapStart             = outerCapStart
                                           .ringRadialPointUsingCenter(center)
          self.outerCapStartControlPoint = outerCapStartControlPoint
                                           .ringRadialPointUsingCenter(center)
          self.outerBezStartControlPoint = outerBezStartControlPoint
                                           .ringRadialPointUsingCenter(center)
          self.outerBezStart             = outerBezStart
                                           .ringRadialPointUsingCenter(center)
          self.outerBezEndControlPoint   = outerBezEndControlPoint
                                           .ringRadialPointUsingCenter(center)
          self.outerCapEndControlPoint   = outerCapEndControlPoint
                                           .ringRadialPointUsingCenter(center)
          self.outerCapEnd               = outerCapEnd
                                           .ringRadialPointUsingCenter(center)
          self.innerCapEnd               = innerCapEnd
                                           .ringRadialPointUsingCenter(center)
          self.innerCapEndControlPoint   = innerCapEndControlPoint
                                           .ringRadialPointUsingCenter(center)
          self.innerBezEndControlPoint   = innerBezEndControlPoint
                                           .ringRadialPointUsingCenter(center)
          self.innerBezEnd               = innerBezEnd
                                           .ringRadialPointUsingCenter(center)
  }
  
  
  public func roundedRingWithStart(      start: TauAngle,
                                    andEnd end: TauAngle) -> RoundedRing {
                                      
    let adjustedEnd   = end - TauAngle(degrees: 360)
 
    let center = self.center
    let innerRadius = self.innerRadius
    let outerRadius = self.outerRadius
    let outerOffsetStart = self.outerOffsetStart + CGFloat(start)
    let outerOffsetEnd   = self.outerOffsetEnd   + CGFloat(adjustedEnd)
    let innerOffsetEnd   = self.innerOffsetEnd   + CGFloat(adjustedEnd)
    let innerOffsetStart = self.innerOffsetStart + CGFloat(start)
    let innerBezStart             = self.innerBezStart
                                        .ringRadialPointRotatedBy(start)
    let innerBezStartControlPoint = self.innerBezStartControlPoint
                                        .ringRadialPointRotatedBy(start)
    let innerCapStartControlPoint = self.innerCapStartControlPoint
                                        .ringRadialPointRotatedBy(start)
    let innerCapStart             = self.innerCapStart
                                        .ringRadialPointRotatedBy(start)
    let outerCapStart             = self.outerCapStart
                                        .ringRadialPointRotatedBy(start)
    let outerCapStartControlPoint = self.outerCapStartControlPoint
                                        .ringRadialPointRotatedBy(start)
    let outerBezStartControlPoint = self.outerBezStartControlPoint
                                        .ringRadialPointRotatedBy(start)
    let outerBezStart             = self.outerBezStart
                                        .ringRadialPointRotatedBy(start)
    let outerBezEndControlPoint   = self.outerBezEndControlPoint
                                        .ringRadialPointRotatedBy(adjustedEnd)
    let outerCapEndControlPoint   = self.outerCapEndControlPoint
                                        .ringRadialPointRotatedBy(adjustedEnd)
    let outerCapEnd               = self.outerCapEnd
                                        .ringRadialPointRotatedBy(adjustedEnd)
    let innerCapEnd               = self.innerCapEnd
                                        .ringRadialPointRotatedBy(adjustedEnd)
    let innerCapEndControlPoint   = self.innerCapEndControlPoint
                                        .ringRadialPointRotatedBy(adjustedEnd)
    let innerBezEndControlPoint   = self.innerBezEndControlPoint
                                        .ringRadialPointRotatedBy(adjustedEnd)
    let innerBezEnd               = self.innerBezEnd
                                        .ringRadialPointRotatedBy(adjustedEnd)

    return              RoundedRing( center: center,
                                innerRadius: innerRadius,
                                outerRadius: outerRadius,
                           outerOffsetStart: outerOffsetStart,
                             outerOffsetEnd: outerOffsetEnd,
                             innerOffsetEnd: innerOffsetEnd,
                           innerOffsetStart: innerOffsetStart,
                              innerBezStart: innerBezStart,
                  innerBezStartControlPoint: innerBezStartControlPoint,
                  innerCapStartControlPoint: innerCapStartControlPoint,
                              innerCapStart: innerCapStart,
                              outerCapStart: outerCapStart,
                  outerCapStartControlPoint: outerCapStartControlPoint,
                  outerBezStartControlPoint: outerBezStartControlPoint,
                              outerBezStart: outerBezStart,
                    outerBezEndControlPoint: outerBezEndControlPoint,
                    outerCapEndControlPoint: outerCapEndControlPoint,
                                outerCapEnd: outerCapEnd,
                                innerCapEnd: innerCapEnd,
                    innerCapEndControlPoint: innerCapEndControlPoint,
                    innerBezEndControlPoint: innerBezEndControlPoint,
                                innerBezEnd: innerBezEnd )

  }
  
  
  var innerBezStartX: CGFloat {
    get {
      return innerBezStart.ringPoint.x
    }
  }
  
  
  
}