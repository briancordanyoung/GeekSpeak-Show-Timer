//
//  GSTRing.h
//  GeekSpeak Show Timer
//
//  Created by Brian Cordan Young on 8/7/15.
//  Copyright (c) 2015 Brian Young. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface GSTRing : NSObject

  @property (nonatomic) CGFloat    start;
  @property (nonatomic) CGFloat    end;
  @property (nonatomic) CGFloat    width;
  @property (nonatomic) CGFloat    cornerRadiusStart;
  @property (nonatomic) CGFloat    cornerRadiusEnd;
  @property (nonatomic) CGColorRef color;

- (id)initWithStart: (CGFloat) newStart
                end: (CGFloat) newEnd
              width: (CGFloat) newWidth
  cornerRadiusStart: (CGFloat) newCornerRadiusStart
    cornerRadiusEnd: (CGFloat) newCornerRadiusEnd
              color: (CGColorRef) newColor;

@end
