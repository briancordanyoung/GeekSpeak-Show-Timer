//
//  ViewController.swift
//  RingLayerPlay
//
//  Created by Brian Cordan Young on 9/8/15.
//  Copyright (c) 2015 Brian Young. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    
    let sizedView = SizeToSuperView()
    let ringView  = RingView()
    
    view.addSubview(sizedView)
    sizedView.addSubview(ringView)
    
    ringView.color = UIColor(red: 0.1, green: 0.5, blue: 0.1, alpha: 0.8)
    ringView.startAngle = Rotation(degrees: 10)
    
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

