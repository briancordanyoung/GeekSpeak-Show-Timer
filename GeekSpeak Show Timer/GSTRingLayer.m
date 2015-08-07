#import "GSTRingLayer.h"

typedef struct {
  CGFloat    start;
  CGFloat    end;
  CGFloat    width;
  CGFloat    cornerRadiusStart;
  CGFloat    cornerRadiusEnd;
  CGColorRef color;
  
} GSTRing;

GSTRing MakeGSTRing(CGFloat start,
                    CGFloat end,
                    CGFloat width,
                    CGFloat cornerRadiusStart,
                    CGFloat cornerRadiusEnd,
                    CGColorRef color) {
  GSTRing ring;
  ring.start             = start;
  ring.end               = end;
  ring.width             = width;
  ring.cornerRadiusStart = cornerRadiusStart;
  ring.cornerRadiusEnd   = cornerRadiusEnd;
  ring.color             = color;

  return ring;
}


@interface GSTRingLayer (Private)
@property (nonatomic,readonly)  CGFloat start;
@property (nonatomic,readonly)  CGFloat end;
@end


@implementation GSTRingLayer

@dynamic    startAngle;
@dynamic    endAngle;
@dynamic    ringWidth;
@dynamic    endRadius;
@synthesize color;



- (CABasicAnimation *)makeAnimationForKey:(NSString *)key {
  CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:key];
  anim.fromValue = [[self presentationLayer] valueForKey:key];
  anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
  anim.duration = 0.0;
  
  return anim;
}

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
    
    [self setNeedsDisplay];
  }
  
  return self;
}

- (id)initWithLayer:(id)layer {
  if (self = [super initWithLayer:layer]) {
    if ([layer isKindOfClass:[GSTRingLayer class]]) {
      GSTRingLayer  *other = (GSTRingLayer *)layer;
      self.startAngle   = other.startAngle;
      self.endAngle     = other.endAngle;
      self.ringWidth    = other.ringWidth;
      self.endRadius    = other.endRadius;
      self.color        = other.color;
    }
  }
  
  return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
  if ([key isEqualToString:@"startAngle"] ||
      [key isEqualToString:@"endAngle"] ||
      [key isEqualToString:@"ringWidth"] ||
      [key isEqualToString:@"endRadius"]) {
    return YES;
  }
  
  return [super needsDisplayForKey:key];
}

- (CGFloat) start {
  return self.startAngle - (M_PI / 2);
}

- (CGFloat) end {
  return self.endAngle - (M_PI / 2);
}


-(void)drawInContext:(CGContextRef)ctx {
  GSTRing ring = MakeGSTRing(self.start,
                             self.end,
                             self.ringWidth,
                             self.endRadius,
                             self.endRadius,
                             self.color.CGColor);
  
  [self drawRing: ring
       InContext: ctx];
}


-(void)drawRing: (GSTRing)ring InContext:(CGContextRef)ctx {
  
  // Create the path
  CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
  CGFloat outerRadius = MIN(center.x, center.y);
  CGFloat innerRadius = outerRadius - self.ringWidth;

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
  int clockwiseDirection = ring.start > ring.end;
  CGContextAddArc(ctx, center.x, center.y, outerRadius,
                  ring.start, ring.end, clockwiseDirection);
  
  // Inner Radius End
  CGPoint i2 = CGPointMake(center.x + innerRadius * cosf(ring.end),
                           center.y + innerRadius * sinf(ring.end));
  CGContextAddLineToPoint(ctx, i2.x, i2.y);
  
  // Back to Inner Radius Start
  int reverseDirection = !clockwiseDirection;
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


@end
