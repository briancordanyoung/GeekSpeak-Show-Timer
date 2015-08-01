#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PieShapeLayer : CALayer


@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;
//@property (nonatomic) CGFloat percentFromStart;

@property (nonatomic) BOOL clipToCircle;
@property (nonatomic, strong) UIColor *fillColor;
@end
