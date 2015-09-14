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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GSTRing.h"

@interface GSTRingLayer : CALayer

@property (nonatomic)         CGFloat startAngle; /* angle in radians */
@property (nonatomic)         CGFloat endAngle;   /* angle in radians */
@property (nonatomic)         CGFloat ringWidth;  /* percentage from 0 to 1 */
@property (nullable, copy)     relativeViewSize viewSize;
@property (nonatomic)         CGFloat cornerRounding; 
@property (nonnull, nonatomic, strong) UIColor *color;
@property (nonnull, nonatomic, strong) NSArray *additionalColors;

@end
