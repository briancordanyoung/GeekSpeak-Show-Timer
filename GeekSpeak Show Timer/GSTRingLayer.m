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

@import UIKit;
#import "GSTRingLayer.h"
#import "GSTRing.h"
#import <GeekSpeak_Show_Timer-Swift.h>

@interface GSTRingLayer ()

@property (nonatomic) CGImageRef roundedMask;
-(void)createMaskInContext:(CGContextRef) ctx;

@end


@implementation GSTRingLayer

@dynamic    startAngle;
@dynamic    endAngle;
@dynamic    ringWidth;
@dynamic    cornerRounding;
@synthesize color;
@synthesize additionalColors = _additionalColors;
@synthesize roundedMask;


// MARK: -
// MARK: Initialization
- (id)init {
  self = [super init];
  if (self) {
    self.color      = [UIColor redColor];
    self.ringWidth  = MIN(self.bounds.size.width/2,
                          self.bounds.size.height/2)
                          * 0.25;
    self.startAngle      = 0.0;
    self.endAngle        = M_PI * 2;
    self.cornerRounding  = 0;
    self.aditionalColors = @[];

    __weak GSTRingLayer *weakSelf = self;
    self.viewSize         = ^NSNumber*(void) {
                        if (weakSelf == nil) {
                          return nil;
                        } else {
                          CGFloat size = MIN(weakSelf.bounds.size.width,
                                             weakSelf.bounds.size.height);
                          NSNumber * viewSize = [NSNumber numberWithFloat:size];
                          return viewSize;
                        }
                      };

    self.additionalColors = @[];
    [self setNeedsDisplay];
  }
  
  return self;
}

- (id)initWithLayer:(id)layer {
  if (self = [super initWithLayer:layer]) {
    if ([layer isKindOfClass:[GSTRingLayer class]]) {
      GSTRingLayer  *other  = (GSTRingLayer *)layer;
      self.startAngle       = other.startAngle;
      self.endAngle         = other.endAngle;
      self.ringWidth        = other.ringWidth;
      self.viewSize         = other.viewSize;
      self.cornerRounding   = other.cornerRounding;
      self.color            = other.color;
      self.additionalColors = other.additionalColors;
    }
  }
  
  return self;
}


// MARK: Internal Computed Properties
// Internally offset the angles so that they start drawing at the top
- (CGFloat) start {
  return self.startAngle - (M_PI / 2);
}

- (CGFloat) end {
  return self.endAngle - (M_PI / 2);
}

- (CGFloat) distance {
  return self.endAngle - self.startAngle;
}

- (CGFloat) progressPercentage {
  CGFloat threeSixtyDegrees = (M_PI * 2);
  CGFloat raw = self.endAngle / threeSixtyDegrees;
  return MIN(raw, threeSixtyDegrees);
}

// MARK: Ring Creation

- (GSTRing*) primaryRing {
  
  GSTRing *ring = [[GSTRing alloc] initWithStart: self.start
                                             end: self.end
                                           width: self.ringWidth
                                        viewSize: self.viewSize
                        cornerRoundingPercentage: self.cornerRounding
                                           color: self.color.CGColor ];
  return ring;
}

- (GSTRing*) sectionRingWithPrecedingRing: (GSTRing *) precedingRing
                               startAngle: (CGFloat) startAngle
                                 andColor: (CGColorRef) sectionColor {
  
  GSTRing *ring = [[GSTRing alloc] initWithStart: startAngle
                                             end: precedingRing.end
                                           width: self.ringWidth
                                        viewSize: self.viewSize
                        cornerRoundingPercentage: 0.0
                                           color: sectionColor ];
  return ring;
}


// MARK: Additional Colors validation and retrieval
- (NSArray *) aditionalColors {
  return _additionalColors;
}


- (void) setAditionalColors:(NSArray *)colors {
  NSArray* validSectionColors;
  
  for ( NSDictionary *section in colors) {
    if ([self sectionIsValid: section]) {
      validSectionColors = [validSectionColors arrayByAddingObject: section];
    }
  }
  
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: @"percentage"
                                                         ascending: NO];
  _additionalColors = [validSectionColors sortedArrayUsingDescriptors:@[sort]];
  
}


- (BOOL) sectionIsValid: (NSDictionary *) section {
  UIColor  *aColor      = section[@"color"];
  NSNumber *aPercentage = section[@"percentage"];
  
  if ((aColor != nil)       &&
      (aPercentage != nil)  &&
      ([aColor      isKindOfClass: [UIColor class]])  &&
      ([aPercentage isKindOfClass: [NSNumber class]])   ){
    return YES;
  } else {
    return NO;
  }
}

- (CGColorRef) colorFromSectionDirection: (NSDictionary *) section {
  UIColor                *c = section[@"color"];
  CGColorRef   sectionColor = [c CGColor];
  return sectionColor;
}

- (CGFloat) percentageFromSectionDirection: (NSDictionary *) section {
  NSNumber        *p = section[@"percentage"];
  CGFloat percentage = [p floatValue];
  return percentage;
}


- (CGFloat) sectionStartAngleFromPercentage: (CGFloat) percentage {
  CGFloat circle = M_PI * 2;
  CGFloat percentageOfCircle = circle * percentage;
  CGFloat adjustmentToBeginAtNorth = (M_PI / 2);
  return percentageOfCircle - adjustmentToBeginAtNorth + self.startAngle;
}


// MARK: -
// MARK: Drawing
-(void)drawInContext: (CGContextRef) ctx {

  [self createMaskInContext: ctx];
  
  GSTRing* ring = self.primaryRing;
  
  NSMutableArray*  ringList = [[NSMutableArray alloc] init];
  [ringList addObject:ring];
  
  GSTRing* precedingRing = ring;
  for ( NSDictionary *section in self.additionalColors) {
    CGColorRef sectionColor = [self colorFromSectionDirection: section];
    CGFloat    percentage   = [self percentageFromSectionDirection: section];
    
    if (self.progressPercentage > percentage) {
      
      CGFloat startAngle = [self sectionStartAngleFromPercentage: percentage];
      
      GSTRing *sectionRing = [self sectionRingWithPrecedingRing: precedingRing
                                                     startAngle: startAngle
                                                       andColor: sectionColor];
      
      [ringList addObject:sectionRing];


      precedingRing.end                      = startAngle;
      precedingRing.cornerRoundingPercentage = 0.0;
      precedingRing                          = sectionRing;
    }
  }
  
  for (GSTRing* eachRing in ringList) {
    eachRing.cornerRoundingPercentage = 0.0;
    [self drawRing: eachRing inContext: ctx];
  }
}

-(void)createMaskInContext:(CGContextRef) ctx {
  if (self.start > -(M_PI / 2)) {
    CGImageRelease(self.roundedMask);
    self.roundedMask = nil;
  }
  
  if (self.roundedMask != nil) {
    CGFloat maskHeight =  CGImageGetHeight(self.roundedMask);
    CGFloat ctxHeight  =  CGBitmapContextGetHeight(ctx);
    CGFloat maskWidth =  CGImageGetWidth(self.roundedMask);
    CGFloat ctxWidth  =  CGBitmapContextGetWidth(ctx);
    
    if ((maskHeight != ctxHeight) || (maskWidth != ctxWidth)) {
      CGImageRelease(self.roundedMask);
      self.roundedMask = nil;
    }
  }
  
  
  if (self.cornerRounding > 0) {
    CGRect rect = CGRectMake(0 , 0,  CGBitmapContextGetWidth(ctx),
                             CGBitmapContextGetHeight(ctx));
    
    if (self.roundedMask == nil)  {
      
      CGColorSpaceRef greySpace = CGColorSpaceCreateDeviceGray();
      
      CGContextRef maskCTX =  CGBitmapContextCreate( NULL,
                                        CGBitmapContextGetWidth(ctx),
                                        CGBitmapContextGetHeight(ctx),
                                        CGBitmapContextGetBitsPerComponent(ctx),
                                        CGBitmapContextGetBytesPerRow(ctx),
                                        greySpace,
                                        (CGBitmapInfo)kCGImageAlphaNone);
      
      CGColorSpaceRelease(greySpace);
      
      CGColorRef maskOutColor = [[UIColor blackColor] CGColor];
      CGColorRef maskInColor  = [[UIColor whiteColor] CGColor];
      
      CGContextSetFillColorWithColor(maskCTX, maskOutColor);
      CGContextFillRect(maskCTX, rect);
      
      GSTRing* maskRing = self.primaryRing;
      
      maskRing.start = self.start;
      maskRing.end   = maskRing.start + (M_PI * 2);
      
      
      // TODO: Between 180° and 270° the ring mask does not draw correctly.
      if (maskRing.end > (M_PI * 2)) {
        maskRing.start = maskRing.start - (M_PI * 2);
        maskRing.end   = maskRing.end   - (M_PI * 2);
      }
      
      
      // NSLog(@"start: %f           end: %f",maskRing.start,maskRing.end);
      
      maskRing.color = maskInColor;
      maskRing.cornerRoundingPercentage = self.cornerRounding;
      [self drawRing: maskRing inContext: maskCTX];
      
      self.roundedMask = CGBitmapContextCreateImage(maskCTX);
      CGContextRelease(maskCTX);
      
    }
    CGContextClipToMask(ctx, rect, self.roundedMask);
  }

}

-(void)drawRing: (GSTRing*) ring
      inContext: (CGContextRef) ctx {
  
  CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
  
  CGFloat outerRadius = MIN(center.x, center.y);
  CGFloat viewSize = MIN(self.bounds.size.width,
                         self.bounds.size.height);
  if (ring.viewSize != nil) {
    NSNumber * viewSizeNumber = ring.viewSize();
    if (viewSizeNumber != nil) {
      // This is the view size we really want!
      viewSize = viewSizeNumber.floatValue;
    }
  }
  
  CGFloat innerRadius = outerRadius - (viewSize * ring.width);
  
  RingPoint *centerP = [[RingPoint alloc] initWithX: center.x y: center.y];
  
  RingDrawing *ringDrawing = [[RingDrawing alloc] initWithCenter: centerP
                                                     outerRadius: outerRadius
                                                     innerRadius: innerRadius
                                                      startAngle: ring.start
                                                        endAngle: ring.end
                                        cornerRoundingPercentage: ring.cornerRoundingPercentage];
  
  UIColor *fillColor = [[UIColor alloc] initWithCGColor:ring.color];
  ringDrawing.fillColor = fillColor;
  ringDrawing.lineWidth = ring.width;
  
  [ringDrawing drawInContext: ctx];
}

// MARK: Animation
// Allows CoreAnimation to animate these parameters.
+ (BOOL)needsDisplayForKey:(NSString *)key {
  if ([key isEqualToString:@"startAngle"] ||
      [key isEqualToString:@"endAngle"] ||
      [key isEqualToString:@"ringWidth"] ||
      [key isEqualToString:@"endRadius"]  ) {
    return YES;
  }
  
  return [super needsDisplayForKey:key];
}

- (CABasicAnimation *)makeAnimationForKey:(NSString *)key {
  CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:key];
  anim.fromValue = [[self presentationLayer] valueForKey:key];
  anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
  anim.duration = 0.0;
  
  return anim;
}

@end
