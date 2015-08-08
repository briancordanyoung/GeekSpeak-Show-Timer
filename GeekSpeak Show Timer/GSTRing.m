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
@synthesize cornerRadiusStart;
@synthesize cornerRadiusEnd;
@synthesize color;

- (id)init {
  self = [super init];
  return self;
}

- (id)initWithStart: (CGFloat) newStart
                end: (CGFloat) newEnd
              width: (CGFloat) newWidth
  cornerRadiusStart: (CGFloat) newCornerRadiusStart
    cornerRadiusEnd: (CGFloat) newCornerRadiusEnd
              color: (CGColorRef) newColor {
  self = [super init];
  
  self.start             = newStart;
  self.end               = newEnd;
  self.width             = newWidth;
  self.cornerRadiusStart = newCornerRadiusStart;
  self.cornerRadiusEnd   = newCornerRadiusEnd;
  self.color             = newColor;

  return self;
}

- (NSString *) description {
  return  [NSString stringWithFormat:@"Start: %1.3f  End: %1.3f", self.start,
                                                                  self.end];
}

@end
