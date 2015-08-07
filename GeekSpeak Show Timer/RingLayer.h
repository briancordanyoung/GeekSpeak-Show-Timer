#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RingLayer : CALayer

@property (nonatomic)         CGFloat startAngle;
@property (nonatomic)         CGFloat endAngle;
@property (nonatomic)         CGFloat ringWidth;
@property (nonatomic, strong) UIColor *color;

@end
