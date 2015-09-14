// Ring Classes:  Refactor!!!
//                The classes for drawing and layingout the ring are completely
//                messing confussing, uses similar but different propery  names
//                mix obj-c and swift cause type conversions that are confusing
//                and general a mess.  Clean this mess up!!!
//                Draw cleanly and be nice.  ;)
//
//                  GSTRing.h
//                  GSTRing.m
//                  GSTRingLayer.h
//                  RingCircle.swift
//                  RingFillView.swift
//                  RingPoint.swift
//                  RingView+Progress.swift
//                  RingView.swift

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
