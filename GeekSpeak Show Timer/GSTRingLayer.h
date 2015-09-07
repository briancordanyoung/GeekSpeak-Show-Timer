#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GSTRing.h"

@interface GSTRingLayer : CALayer

@property (nonatomic)         CGFloat startAngle; /* angle in radians */
@property (nonatomic)         CGFloat endAngle;   /* angle in radians */
@property (nonatomic)         CGFloat ringWidth;  /* percentage from 0 to 1 */
@property (nullable, copy)     relativeViewSize viewSize;
@property (nonatomic)         CGFloat endRadius;  /* unused */
@property (nonnull, nonatomic, strong) UIColor *color;
@property (nonnull, nonatomic, strong) NSArray *additionalColors;

@end
