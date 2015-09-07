#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GSTRing.h"

@interface GSTRingLayer : CALayer

@property (nonatomic)         CGFloat startAngle;
@property (nonatomic)         CGFloat endAngle;
@property (nonatomic)         CGFloat ringWidth;
@property (nullable, copy)     relativeViewSize viewSize;
@property (nonatomic)         CGFloat endRadius;
@property (nonnull, nonatomic, strong) UIColor *color;
@property (nonnull, nonatomic, strong) NSArray *additionalColors;

@end
