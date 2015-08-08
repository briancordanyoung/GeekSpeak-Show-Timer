#import "GSTPieLayer.h"


@implementation GSTPieLayer

@dynamic    startAngle;
@dynamic    endAngle;
@synthesize clipToCircle;
@synthesize fillColor;



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
    self.clipToCircle  = NO;
    self.fillColor     = [UIColor redColor];
    
    [self setNeedsDisplay];
  }
  
  return self;
}

- (id)initWithLayer:(id)layer {
  if (self = [super initWithLayer:layer]) {
    if ([layer isKindOfClass:[GSTPieLayer class]]) {
      GSTPieLayer  *other = (GSTPieLayer *)layer;
      self.clipToCircle     = other.clipToCircle;
      self.startAngle       = other.startAngle;
      self.endAngle         = other.endAngle;
      self.fillColor        = other.fillColor;
      
    }
  }
  
  return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
  if ([key isEqualToString:@"startAngle"] ||
      [key isEqualToString:@"endAngle"] ||
      [key isEqualToString:@"percentFromStart"]) {
    return YES;
  }
  
  return [super needsDisplayForKey:key];
}


-(void)drawInContext:(CGContextRef)ctx {
  CGImageRef mask = [self maskImage];
  CGContextClipToMask(ctx, self.bounds, mask);
  CGImageRelease(mask);

  CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
  CGContextFillRect(ctx, self.bounds);
}


-(void)drawMaskInContext:(CGContextRef)ctx {
  
  CGFloat halfPI = (M_PI / 2);
  CGFloat start  = self.startAngle - halfPI;
  CGFloat end    = self.endAngle   - halfPI;
  
  // Create the path
  CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
  CGFloat radius;
  if (clipToCircle) {
    radius = MIN(center.x, center.y);
  } else {
    radius = MAX(self.bounds.size.width, self.bounds.size.height);
  }
  
  CGContextBeginPath(ctx);
  CGContextMoveToPoint(ctx, center.x, center.y);
  
  CGPoint p1 = CGPointMake(center.x + radius * cosf(start),
                           center.y + radius * sinf(start));
  CGContextAddLineToPoint(ctx, p1.x, p1.y);
  
  int clockwise = start > end;
  CGContextAddArc(ctx, center.x, center.y, radius,
                  start, end, clockwise);
  
  CGContextClosePath(ctx);
  
  // Color it
  CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
  CGContextSetStrokeColorWithColor(ctx, UIColor.clearColor.CGColor);
  CGContextSetLineWidth(ctx, 0.0f);
  
  CGContextDrawPath(ctx, kCGPathFillStroke);
}




-(CGImageRef)maskImage {
  CGFloat width  = self.bounds.size.width;
  CGFloat height = self.bounds.size.height;
  
  // Create a bitmap graphics context of the given size
  //
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(NULL, width,
                                               height,
                                               8, 0, colorSpace,
                                               kCGImageAlphaPremultipliedLast);
  
  [self drawMaskInContext: context];
  
  // Get your image
  //
  CGImageRef cgImage = CGBitmapContextCreateImage(context);
  
  CGColorSpaceRelease(colorSpace);
  CGContextRelease(context);
  
  return cgImage;
  
}

@end
