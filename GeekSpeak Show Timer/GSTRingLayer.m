#import "GSTRingLayer.h"
#import "GSTRing.h"


@implementation GSTRingLayer

@dynamic    startAngle;
@dynamic    endAngle;
@dynamic    ringWidth;
@dynamic    endRadius;
@synthesize color;
@synthesize additionalColors = _additionalColors;



// MARK: -
// MARK: Initialization
- (id)init {
  self = [super init];
  if (self) {
    self.color      = [UIColor redColor];
    self.ringWidth  = MIN(self.bounds.size.width/2,
                          self.bounds.size.height/2)
                          * 0.25;
    self.startAngle = 0.0;
    self.endAngle   = M_PI * 2;
    self.endRadius  = 0;
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
      self.endRadius        = other.endRadius;
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
                               cornerRadiusStart: self.endRadius
                                 cornerRadiusEnd: self.endRadius
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
                               cornerRadiusStart: 0.0
                                 cornerRadiusEnd: precedingRing.cornerRadiusEnd
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


      precedingRing.end             = startAngle;
      precedingRing.cornerRadiusEnd = 0.0;
      precedingRing = sectionRing;
    }
  }
  
  for (GSTRing* eachRing in ringList) {
    [self drawRing: eachRing inContext: ctx];
  }
}


-(void)drawRing: (GSTRing*) ring
      inContext: (CGContextRef) ctx {
  
  // Create the path
  CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
  CGFloat outerRadius = MIN(center.x, center.y);
  
  // Setup view size with bounds, just incase the viewSize block resolves to nil
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
  
  // Begin Path
  CGContextBeginPath(ctx);
  
  // Inner Radius Start
  CGPoint i1 = CGPointMake(center.x + innerRadius * cosf(ring.start),
                           center.y + innerRadius * sinf(ring.start));
  CGContextMoveToPoint(ctx, i1.x, i1.y);
  
  // Outer Radius Start
  CGPoint o1 = CGPointMake(center.x + outerRadius * cosf(ring.start),
                           center.y + outerRadius * sinf(ring.start));
  CGContextAddLineToPoint(ctx, o1.x, o1.y);
  
  // Outer Radius End
  int direction = ring.start > ring.end ? 1 : 0;
  CGContextAddArc(ctx, center.x, center.y, outerRadius,
                  ring.start, ring.end, direction);
  
  // Inner Radius End
  CGPoint i2 = CGPointMake(center.x + innerRadius * cosf(ring.end),
                           center.y + innerRadius * sinf(ring.end));
  CGContextAddLineToPoint(ctx, i2.x, i2.y);
  
  // Back to Inner Radius Start
  int reverseDirection = ring.start > ring.end ? 0 : 1;
  CGContextAddArc(ctx, center.x, center.y, innerRadius,
                  ring.end, ring.start, reverseDirection);
  
  // End path Path
  CGContextClosePath(ctx);
  
  // Color it
  CGContextSetFillColorWithColor(ctx,   ring.color);
  CGContextSetStrokeColorWithColor(ctx, UIColor.clearColor.CGColor);
  CGContextSetLineWidth(ctx, 0.0f);
  
  // Draw in context
  CGContextDrawPath(ctx, kCGPathFillStroke);
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
