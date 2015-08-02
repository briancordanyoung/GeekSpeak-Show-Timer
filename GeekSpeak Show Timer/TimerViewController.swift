//
//  ViewController.swift
//  GeekSpeak Show Timer
//
//  Created by Brian Cordan Young on 8/1/15.
//  Copyright (c) 2015 Brian Young. All rights reserved.
//

import UIKit

struct TimerViews {
  let ring1bg: RingView
  let ring1fg: PartialRingView
  let ring2bg: RingView
  let ring2fg: PartialRingView
  let ring3bg: RingView
  let ring3fg: PartialRingView
  
  
  func layoutSubviewsWithLineWidth(lineWidth: CGFloat) {
    ring1fg.updateMaskFrame()
    ring2fg.updateMaskFrame()
    ring3fg.updateMaskFrame()
    ring1fg.ringMask.lineWidth = lineWidth
    ring2fg.ringMask.lineWidth = lineWidth
    ring3fg.ringMask.lineWidth = lineWidth
    ring1bg.lineWidth = lineWidth
    ring2bg.lineWidth = lineWidth
    ring3bg.lineWidth = lineWidth
    ring1bg.lineWidth = lineWidth
    ring2bg.lineWidth = lineWidth
    ring3bg.lineWidth = lineWidth
  }
}


final class TimerViewController: UIViewController {

  var timerViews: TimerViews?

  let ring1Color = UIColor(red: 0.5,  green: 0.5,  blue: 1.0,  alpha: 1.0)
  let ring2Color = UIColor(red: 1.0,  green: 0.5,  blue: 0.5,  alpha: 1.0)
  let ring3Color = UIColor(red: 0.5,  green: 1.0,  blue: 0.5,  alpha: 1.0)
  
  @IBOutlet weak var timerCirclesView: UIView!
  @IBOutlet weak var testSlider: UISlider!
  
  var lineWidth: CGFloat {
    let testWidth   = CGFloat(90)
    let testSize    = CGFloat(736)
    let currentSize = (timerCirclesView.frame.size.width +
      timerCirclesView.frame.size.height  ) / 2
    return (currentSize / testSize) * testWidth
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let ring1bg   = configureBGRing(RingView(), withColor: ring1Color)
    let ring1fg   = configureFGRing(PartialRingView(), withColor: ring1Color)

    let ring2bg   = configureBGRing(RingView(), withColor: ring2Color)
    let ring2fg   = configureFGRing(PartialRingView(), withColor: ring2Color)
    
    let ring3bg   = configureBGRing(RingView(), withColor: ring3Color)
    let ring3fg   = configureFGRing(PartialRingView(), withColor: ring3Color)


    ring2bg.percentageOfSuperviewSize = 0.66
    ring2fg.percentageOfSuperviewSize = 0.66
    ring1bg.percentageOfSuperviewSize = 0.33
    ring1fg.percentageOfSuperviewSize = 0.33
    
    timerViews = TimerViews(  ring1bg: ring1bg,
                              ring1fg: ring1fg,
                              ring2bg: ring2bg,
                              ring2fg: ring2fg,
                              ring3bg: ring3bg,
                              ring3fg: ring3fg)
    
    testSlider.value = Float(ring3fg.endAngle.value)
  }
  
  func configureFGRing(ringView: PartialRingView, withColor color: UIColor)
                                                            -> PartialRingView {
    ringView.color               = color
    ringView.startAngle          = Rotation(degrees: 0)
    ringView.endAngle            = Rotation(degrees: 10)
    ringView.ringMask.lineWidth  = lineWidth
    configureRing(ringView)
    return ringView
  }
  
  func configureBGRing(ringView: RingView, withColor color: UIColor)
                                                                   -> RingView {
    ringView.lineColor   = color.darkenColorWithMultiplier(0.1)
    ringView.lineWidth   = lineWidth
    configureRing(ringView)
    return ringView
  }
  
  func configureRing(ringView: UIView) {
    timerCirclesView.addSubview(ringView)
    ringView.opaque              = false
  }
  
  
  

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    timerViews?.layoutSubviewsWithLineWidth(lineWidth)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @IBAction func sliderChanged(sender: UISlider) {
    if let timerViews = timerViews {
      let value = CGFloat(sender.value)
      timerViews.ring1fg.endAngle = Rotation(degrees: value)
      timerViews.ring2fg.endAngle = Rotation(degrees: value)
      timerViews.ring3fg.endAngle = Rotation(degrees: value)
    }
  }
  

}

