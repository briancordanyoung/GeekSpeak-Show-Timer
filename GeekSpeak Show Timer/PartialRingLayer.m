#import "PartialRingLayer.h"


@implementation PartialRingLayer

@dynamic    startAngle;
@dynamic    endAngle;
@dynamic    ringWidth;
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
    
    [self setNeedsDisplay];
  }
  
  return self;
}

- (id)initWithLayer:(id)layer {
  if (self = [super initWithLayer:layer]) {
    if ([layer isKindOfClass:[PartialRingLayer class]]) {
      PartialRingLayer  *other = (PartialRingLayer *)layer;
      self.startAngle   = other.startAngle;
      self.endAngle     = other.endAngle;
      self.ringWidth    = other.ringWidth;
      self.color        = other.color;
      
    }
  }
  
  return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
  if ([key isEqualToString:@"startAngle"] ||
      [key isEqualToString:@"endAngle"] ||
      [key isEqualToString:@"ringWidth"]) {
    return YES;
  }
  
  return [super needsDisplayForKey:key];
}


-(void)drawInContext:(CGContextRef)ctx {
  [self drawRingInContext: ctx];
}


-(void)drawRingInContext:(CGContextRef)ctx {
  
  CGFloat halfPI = (M_PI / 2);
  CGFloat start  = self.startAngle - halfPI;
  CGFloat end    = self.endAngle   - halfPI;
  
  // Create the path
  CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
  CGFloat outerRadius = MIN(center.x, center.y);
  CGFloat innerRadius = outerRadius - self.ringWidth;
  
  
  // Begin Path
  CGContextBeginPath(ctx);
  
  // Inner Radius Start
  CGPoint i1 = CGPointMake(center.x + innerRadius * cosf(start),
                           center.y + innerRadius * sinf(start));
  CGContextMoveToPoint(ctx, i1.x, i1.y);
  
  // Outer Radius Start
  CGPoint o1 = CGPointMake(center.x + outerRadius * cosf(start),
                           center.y + outerRadius * sinf(start));
  CGContextAddLineToPoint(ctx, o1.x, o1.y);
  
  // Outer Radius End
  int clockwiseDirection = start > end;
  CGContextAddArc(ctx, center.x, center.y, outerRadius,
                  start, end, clockwiseDirection);
  
  // Inner Radius End
  CGPoint i2 = CGPointMake(center.x + innerRadius * cosf(end),
                           center.y + innerRadius * sinf(end));
  CGContextAddLineToPoint(ctx, i2.x, i2.y);
  
  // Back to Inner Radius Start
  int reverseDirection = !clockwiseDirection;
  CGContextAddArc(ctx, center.x, center.y, innerRadius,
                  end, start, reverseDirection);
  
  // End path Path
  CGContextClosePath(ctx);
  
  // Color it
  CGContextSetFillColorWithColor(ctx, self.color.CGColor);
  CGContextSetStrokeColorWithColor(ctx, UIColor.clearColor.CGColor);
  CGContextSetLineWidth(ctx, 0.0f);
  
  // Draw in context
  CGContextDrawPath(ctx, kCGPathFillStroke);
}


@end
