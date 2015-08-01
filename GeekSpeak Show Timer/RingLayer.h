#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RingLayer : CALayer

@property (nonatomic) CGFloat strokeWidth;
@property (nonatomic, strong) UIColor *strokeColor;

@end
