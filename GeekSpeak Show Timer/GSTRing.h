//
//  GSTRing.h
//  GeekSpeak Show Timer
//
//  Created by Brian Cordan Young on 8/7/15.
//  Copyright (c) 2015 Brian Young. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef  NSNumber * __nullable   (^relativeViewSize)(void);

@interface GSTRing : NSObject

  @property (nonatomic) CGFloat     start;  /* angle in radians */
  @property (nonatomic) CGFloat     end;    /* angle in radians */
  @property (nonatomic) CGFloat     width;  /* percentage from 0 to 1 */
  @property (nonatomic) CGFloat     cornerRadiusStart; /* unused */
  @property (nonatomic) CGFloat     cornerRadiusEnd;   /* unused */
  @property (nonnull, nonatomic) CGColorRef  color;
  @property (nullable, copy) relativeViewSize viewSize;

- (nullable id)initWithStart: (CGFloat) newStart
                end: (CGFloat) newEnd
              width: (CGFloat) newWidth
           viewSize: (nullable relativeViewSize) newViewSize
  cornerRadiusStart: (CGFloat) newCornerRadiusStart
    cornerRadiusEnd: (CGFloat) newCornerRadiusEnd
              color: (nonnull CGColorRef) newColor;

@end
