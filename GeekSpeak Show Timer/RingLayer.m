//
//  PieLayer.m
//  PieChart
//
//  Created by Pavan Podila on 2/20/12.
//  Copyright (c) 2012 Pixel-in-Gene. All rights reserved.
//

#import "RingLayer.h"


@implementation RingLayer

@synthesize strokeColor,
            strokeWidth;



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
    self.strokeWidth   = 15.0;
    self.strokeColor   = [UIColor redColor];
    
    [self setNeedsDisplay];
  }
  
  return self;
}

- (id)initWithLayer:(id)layer {
  if (self = [super initWithLayer:layer]) {
    if ([layer isKindOfClass:[RingLayer class]]) {
      RingLayer  *other    = (RingLayer *)layer;
      self.strokeColor     = other.strokeColor;
      self.strokeWidth     = other.strokeWidth;
    }
  }
  
  return self;
}

// Needed for animating any properties that are added
//+ (BOOL)needsDisplayForKey:(NSString *)key {
//  if ([key isEqualToString:@"somePropertyToAnimate"]) {
//    return YES;
//  }
//  
//  return [super needsDisplayForKey:key];
//}


//-(void)drawInContext:(CGContextRef)ctx {  
//  CGFloat startingEdgeSum = ceil(self.strokeWidth / 2.0) + 1;
//  CGFloat endingEdgeSum   = ceil(self.strokeWidth      ) + 2;
//  
//  CGRect ovalRect = CGRectMake(startingEdgeSum,
//                               startingEdgeSum,
//                               self.bounds.size.width  - endingEdgeSum,
//                               self.bounds.size.height - endingEdgeSum);
//  
//  CGPathRef ovalPath = CGPathCreateWithEllipseInRect(ovalRect, NULL);
//  CGContextAddPath(ctx, ovalPath);
//  CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
//  CGContextSetLineWidth(ctx, self.strokeWidth);
//  CGContextStrokePath(ctx);
//}

-(void)drawInContext:(CGContextRef)ctx {
  CGImageRef mask = [self createMaskImage];
  CGContextClipToMask(ctx, self.bounds, mask);
  CGContextSetFillColorWithColor(ctx, self.strokeColor.CGColor);
  CGContextFillRect(ctx, self.bounds);
}

-(CGImageRef)createMaskImage {

  CGFloat width = self.bounds.size.width;
  CGFloat height = self.bounds.size.height;
  
  // Create a bitmap graphics context of the given size
  //
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(NULL, width,
                                                    height,
                                               8, 0, colorSpace,
                                 (CGBitmapInfo) kCGImageAlphaPremultipliedLast);

  [self drawMaskInContext: context];
  
  // Get your image
  //
  CGImageRef cgImage = CGBitmapContextCreateImage(context);
  
  CGColorSpaceRelease(colorSpace);
  CGContextRelease(context);
  
  return cgImage;

}

-(void)drawMaskInContext:(CGContextRef)ctx {
  CGFloat startingEdgeSum = ceil(self.strokeWidth / 2.0) + 1;
  CGFloat endingEdgeSum   = ceil(self.strokeWidth      ) + 2;
  
  CGRect ovalRect = CGRectMake(startingEdgeSum,
                               startingEdgeSum,
                               self.bounds.size.width  - endingEdgeSum,
                               self.bounds.size.height - endingEdgeSum);
  
  CGPathRef ovalPath = CGPathCreateWithEllipseInRect(ovalRect, NULL);
  CGContextAddPath(ctx, ovalPath);
  CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
  CGContextSetLineWidth(ctx, self.strokeWidth);
  CGContextStrokePath(ctx);
}

@end
