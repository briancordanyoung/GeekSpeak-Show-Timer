//
//  GSTRing.m
//  GeekSpeak Show Timer
//
//  Created by Brian Cordan Young on 8/7/15.
//  Copyright (c) 2015 Brian Young. All rights reserved.
//

#import "GSTRing.h"

@implementation GSTRing

@synthesize start;
@synthesize end;
@synthesize width;
@synthesize cornerRoundingPercentage;
@synthesize color;
@synthesize viewSize;

- (id)init {
  self = [super init];
  return self;
}

- (id)       initWithStart: (CGFloat) newStart
                       end: (CGFloat) newEnd
                     width: (CGFloat) newWidth
                  viewSize: (relativeViewSize) newViewSize
  cornerRoundingPercentage: (CGFloat) cornerRounding
                     color: (CGColorRef) newColor {
  self = [super init];
  
  self.start                    = newStart;
  self.end                      = newEnd;
  self.width                    = newWidth;
  self.viewSize                 = newViewSize;
  self.cornerRoundingPercentage = cornerRounding;
  self.color                    = newColor;

  return self;
}

- (NSString *) description {
  return  [NSString stringWithFormat:@"Start: %1.3f  End: %1.3f", self.start,
                                                                  self.end];
}

@end
