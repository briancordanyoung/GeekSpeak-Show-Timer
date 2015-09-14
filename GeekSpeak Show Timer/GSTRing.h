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
  @property (nonatomic) CGFloat     cornerRoundingPercentage; /* percentage from 0 to 1 */
  @property (nonnull, nonatomic) CGColorRef  color;
  @property (nullable, copy) relativeViewSize viewSize;

- (nullable id)initWithStart: (CGFloat) newStart
                         end: (CGFloat) newEnd
                       width: (CGFloat) newWidth
                    viewSize: (nullable relativeViewSize) newViewSize
    cornerRoundingPercentage: (CGFloat) cornerRounding
                       color: (nonnull CGColorRef) newColor;

@end
