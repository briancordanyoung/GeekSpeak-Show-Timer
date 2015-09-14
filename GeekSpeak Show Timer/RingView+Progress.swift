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



import UIKit

extension RingView {
  
  // Unlike the percent property which accounts for the startAngle and adds
  // the "percentage complete" to the startAngle to get the endAngle....
  // This progress progress property assumes the startAngle is at 0 degrees.
  // But, if the endAngle is greater than 360 degrees then the startAngle is
  // 0 + 5 + the degrees past 360 that the endAngle is at.
  // This makes a 5 degree gap in the circle the indicates the progress
  // past 100%
  var progress: CGFloat {
    get {
      let minAngle = min(startAngle,endAngle)
      let maxAngle = max(startAngle,endAngle)
      let diff     = maxAngle - minAngle
      let percent  = CGFloat(Rotation(degrees: 360)) / CGFloat(diff)
      
      return percent
    }
    set(newPercentage) {
      endAngle = Rotation(degrees: 360 * newPercentage)
      if endAngle > Rotation(degrees: 360) {
        startAngle = endAngle - Rotation(degrees: 360)
      } else {
        startAngle = Rotation(degrees: 0)
      }
    }
  }
  
  
}