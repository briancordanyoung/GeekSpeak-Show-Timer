//: Playground - noun: a place where people can play

import UIKit
import AngleGear
import TimerViewsGear
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 500, height: 500))

let ring = RingView()
ring.startAngle = TauAngle(degrees: 0)
ring.startAngle = TauAngle(degrees: 90)
ring.ringWidth  = 0.5

let center = RingPoint(x: 0.5, y: 0.5)
let ringCircle = RingCircle(center: center, radius: 0.5)






PlaygroundPage.current.liveView = ring
