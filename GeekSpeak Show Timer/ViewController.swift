//
//  ViewController.swift
//  GeekSpeak Show Timer
//
//  Created by Brian Cordan Young on 8/1/15.
//  Copyright (c) 2015 Brian Young. All rights reserved.
//

import UIKit

//struct TimerViews {
//  let ring3bg: RingView
//  let ring3fg: PartialRingView
//}


final class ViewController: UIViewController {

  var timerViews: TimerViews?
  
  @IBOutlet weak var timerCirclesView: UIView!
  @IBOutlet weak var testSlider: UISlider!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let strokeWidth = 60.0
    let bgColor     = UIColor(red: 0.08, green: 0.08, blue: 0.08, alpha: 1.0)
    let fgColor     = UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0)
    
    let ring3bg   = RingView()
    let ring3fg   = PartialRingView()
    
    ring3bg.opaque     = false
    ring3fg.opaque     = false

    timerCirclesView.addSubview(ring3bg)
    timerCirclesView.addSubview(ring3fg)
    
    ring3bg.lineColor           = bgColor
    ring3bg.lineWidth           = 100.0
    ring3fg.color               = fgColor
    ring3fg.startAngle          = Rotation(degrees: 0)
    ring3fg.endAngle            = Rotation(degrees: 10)
    ring3fg.ringMask.lineWidth  = 100.0
    

//    timerViews = TimerViews(  ring3bg: ring3bg,
//                              ring3fg: ring3fg)

    
    testSlider.value = Float(ring3fg.endAngle.value)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if let timerViews = timerViews {
      timerViews.ring3fg.updateMaskFrame()
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @IBAction func sliderChanged(sender: UISlider) {
    if let timerViews = timerViews {
      let value = CGFloat(sender.value)
      timerViews.ring3fg.endAngle = Rotation(degrees: value)
    }
  }
  

}

