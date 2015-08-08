#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GSTRingLayer : CALayer

@property (nonatomic)         CGFloat startAngle;
@property (nonatomic)         CGFloat endAngle;
@property (nonatomic)         CGFloat ringWidth;
@property (nonatomic)         CGFloat endRadius;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSArray *additionalColors;

@end
