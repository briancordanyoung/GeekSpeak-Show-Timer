//
//  ViewController.swift
//  GeekSpeak Show Timer
//
//  Created by Brian Cordan Young on 8/1/15.
//  Copyright (c) 2015 Brian Young. All rights reserved.
//

import UIKit


enum TimerLabelDisplay: String, Printable {
  case Remaining = "Remaining"
  case Elapsed   = "Elapsed"
  
  var description: String {
    return self.rawValue
  }
}

final class TimerViewController: UIViewController {

  var timerViews: TimerViews?
  let timer = Timer()
  let formatter = NSNumberFormatter()
  var timerLabelDisplay: TimerLabelDisplay = .Remaining {
    didSet {
      updateTimerLabels(timer)
    }
  }

  let ring1Color = UIColor(red: 0.5,  green: 0.5,  blue: 1.0,  alpha: 1.0)
  let ring2Color = UIColor(red: 1.0,  green: 0.5,  blue: 0.5,  alpha: 1.0)
  let ring3Color = UIColor(red: 0.5,  green: 1.0,  blue: 0.5,  alpha: 1.0)
  
  @IBOutlet weak var timerCirclesView: UIView!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var sectionTimeLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var segmentLabel: UILabel!
  @IBOutlet weak var startPauseButton: UIButton!
  @IBOutlet weak var nextSegmentButton: UIButton!
  @IBOutlet weak var remainingToggleButton: UIButton!
  
  var lineWidth: CGFloat {
    return self.dynamicType.lineWidthForSize(timerCirclesView.frame.size)
  }
  
  
  class func lineWidthForSize(size: CGSize) -> CGFloat {
    let testWidth   = CGFloat(90)
    let testSize    = CGFloat(736)
    let currentSize = (size.width + size.height  ) / 2
    return (currentSize / testSize) * testWidth
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    timer.countingStateChangedHandler = timerChangedCountingStatus
    timer.timerUpdatedHandler         = timerUpdatedTime

    setupNumberFormatter()
    setupContraints()
    setupTimeLabelContraints(totalTimeLabel)
    setupTimeLabelContraints(sectionTimeLabel)
    setupDescriptionLabelContraints(totalLabel)
    setupDescriptionLabelContraints(segmentLabel)
    setupRemainingToggleButtonContraints()
    styleButtons()
    
    let fillView  = PieShapeView()
    fillView.opaque     = false
    fillView.startAngle = Rotation(degrees: 0)
    fillView.endAngle   = Rotation(degrees: 0)
    fillView.color      = UIColor(red: 0.75, green: 0.0, blue: 0.0, alpha: 1.0)
    fillView.pieLayer.clipToCircle = true
    timerCirclesView.addSubview(fillView)
    
    let ring1bg   = configureBGRing(RingView(), withColor: ring1Color)
    let ring1fg   = configureFGRing(PartialRingView(), withColor: ring1Color)

    let ring2bg   = configureBGRing(RingView(), withColor: ring2Color)
    let ring2fg   = configureFGRing(PartialRingView(), withColor: ring2Color)
    
    let ring3bg   = configureBGRing(RingView(), withColor: ring3Color)
    let ring3fg   = configureFGRing(PartialRingView(), withColor: ring3Color)


    ring3bg.percentageOfSuperviewSize = 0.95
    ring3fg.percentageOfSuperviewSize = 0.95
    ring2bg.percentageOfSuperviewSize = 0.64
    ring2fg.percentageOfSuperviewSize = 0.64
    ring1bg.percentageOfSuperviewSize = 0.33
    ring1fg.percentageOfSuperviewSize = 0.33
    
    timerViews = TimerViews(  ring1bg: ring1bg,
                              ring1fg: ring1fg,
                              ring2bg: ring2bg,
                              ring2fg: ring2fg,
                              ring3bg: ring3bg,
                              ring3fg: ring3fg,
                                 fill: fillView)
    
    timerCirclesView.bringSubviewToFront(remainingToggleButton)
    timer.reset()
  }
  
  
  // MARK: -
  // MARK: ViewController
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    timerViews?.layoutSubviewsWithLineWidth(lineWidth)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }


  
  // MARK: -
  // MARK: Timer callback funtions
  func timerChangedCountingStatus(state: Timer.CountingState) {
    var buttonText: String
    switch state {
    case .Ready:
      buttonText = "Start"
    case .Counting:
      buttonText = "Pause"
    case .Paused:
      buttonText = "Continue"
    }
    startPauseButton.setTitle(buttonText, forState: UIControlState.Normal)
  }
  
  
  
  func timerUpdatedTime(timer: Timer?) {
    if let timer = timer {
      updateTimerLabels(timer)
      
      switch timer.timing.phase {
      case .PreShow,
           .Break1,
           .Break2,
           .Section3:
        if timer.percentageComplete == 1.0 {
          timer.next()
          timerLabelDisplay = .Elapsed
        }
      case .Section1,
           .Section2,
           .PostShow:
        break
      }
      

      
      switch timer.timing.phase {
      case .PreShow:
        timerViews?.fill.percent    = timer.percentageComplete
        timerViews?.ring1fg.percent = 0.0
        timerViews?.ring2fg.percent = 0.0
        timerViews?.ring3fg.percent = 0.0
        break

      case .Section1:
        timerViews?.fill.percent    = 0.0
        timerViews?.ring1fg.percent = timer.percentageComplete
        timerViews?.ring2fg.percent = 0.0
        timerViews?.ring3fg.percent = 0.0
        break

      case .Break1:
        timerViews?.ring1fg.percent = 1.0
        timerViews?.fill.percent    = timer.percentageComplete
        timerViews?.ring2fg.percent = 0.0
        timerViews?.ring3fg.percent = 0.0
        break

      case .Section2:
        timerViews?.fill.percent    = 0.0
        timerViews?.ring1fg.percent = 1.0
        timerViews?.ring2fg.percent = timer.percentageComplete
        timerViews?.ring3fg.percent = 0.0
        break

      case .Break2:
        timerViews?.ring1fg.percent = 1.0
        timerViews?.ring2fg.percent = 1.0
        timerViews?.fill.percent    = timer.percentageComplete
        timerViews?.ring3fg.percent = 0.0
        break

      case .Section3:
        timerViews?.fill.percent    = 0.0
        timerViews?.ring1fg.percent = 1.0
        timerViews?.ring2fg.percent = 1.0
        timerViews?.ring3fg.percent = timer.percentageComplete
        break

      case .PostShow:
        timerViews?.ring1fg.percent = 1.0
        timerViews?.ring2fg.percent = 1.0
        timerViews?.ring3fg.percent = 1.0
        timerViews?.fill.percent = 0.0
        break

      }
    }
  }

  func stringFromTimeInterval(interval: NSTimeInterval) -> String {
    let roundedInterval = Int(interval)
    let seconds = roundedInterval % 60
    let minutes = (roundedInterval / 60) % 60
    let hours   = (roundedInterval / 3600)
    let subSeconds = formatter.stringFromNumber(interval * 100)!
    return String(format: "%02d:%02d:\(subSeconds)",  minutes, seconds)
  }
  
  func updateTimerLabels(timer: Timer) {
    switch timerLabelDisplay {
    case .Remaining:
      totalTimeLabel.text =
        stringFromTimeInterval(timer.totalShowTimeRemaining)
      sectionTimeLabel.text = stringFromTimeInterval(timer.secondsRemaining)
    case .Elapsed:
      totalTimeLabel.text =
        stringFromTimeInterval(timer.totalShowTimeElapsed)
      sectionTimeLabel.text = stringFromTimeInterval(timer.secondsElapsed)
    }
  }
  
  
  // MARK: -
  // MARK: Actions
  
  @IBAction func startPauseButtonPressed(sender: UIButton) {
    switch timer.state {
    case .Ready,
         .Paused:
      timer.start()
    case .Counting:
      timer.pause()
    }
  }

  @IBAction func nextSegmentButtonPressed(sender: UIButton) {
    timer.next()
    if timer.state == .Paused {
      
    }
  }
  
  @IBAction func remainingTimeToggled(sender: UIButton) {
    switch timerLabelDisplay {
      case .Remaining:
      timerLabelDisplay = .Elapsed
    case .Elapsed:
      timerLabelDisplay = .Remaining
    }
  }
  
  // MARK: -
  // MARK: Setup
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

  private func styleButtons() {
    styleButton(startPauseButton)
    styleButton(nextSegmentButton)
  }
  
  private func styleButton(button: UIButton)  {
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 15
    button.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).CGColor
    button.titleLabel?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

  }
  
  private func setupNumberFormatter() {
    formatter.minimumIntegerDigits  = 2
    formatter.maximumIntegerDigits  = 2
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 0
    formatter.negativePrefix = ""
  }
  
  private func setupContraints() {
    // Contrain the timerCirclesView so that it is
    // lessThat the smaller of ViewController view height and width AND
    // at least as wide and high as the smaller of ViewController view 
    // height and width
    let height = NSLayoutConstraint(item: timerCirclesView,
                               attribute: .Height,
                               relatedBy: .LessThanOrEqual,
                                  toItem: view,
                               attribute: .Height,
                              multiplier: 1.0,
                                constant: -32)
    height.priority = 1000
    view.addConstraint(height)

    let width =  NSLayoutConstraint(item: timerCirclesView,
                               attribute: .Width,
                               relatedBy: .LessThanOrEqual,
                                  toItem: view,
                               attribute: .Width,
                              multiplier: 1.0,
                                constant: -32)
    width.priority = 1000
    view.addConstraint(width)
  
    let minHeight = NSLayoutConstraint(item: timerCirclesView,
                               attribute: .Height,
                               relatedBy: .GreaterThanOrEqual,
                                  toItem: view,
                               attribute: .Height,
                              multiplier: 1.0,
                                constant: -32)
    minHeight.priority = 250
    view.addConstraint(minHeight)

    let minWidth =  NSLayoutConstraint(item: timerCirclesView,
                               attribute: .Width,
                               relatedBy: .GreaterThanOrEqual,
                                  toItem: view,
                               attribute: .Width,
                              multiplier: 1.0,
                                constant: -32)
    minWidth.priority = 250
    view.addConstraint(minWidth)
  }

  func setupTimeLabelContraints(label: UILabel) {
    
    let width =  NSLayoutConstraint(item: label,
                               attribute: .Width,
                               relatedBy: .Equal,
                                  toItem: label.superview,
                               attribute: .Width,
                              multiplier: 199 / 736,
                                constant: 0.0)
    width.priority = 1000
    label.superview?.addConstraint(width)
    
  }
  
  func setupDescriptionLabelContraints(label: UILabel) {
    
    let height =  NSLayoutConstraint(item: label,
                               attribute: .Height,
                               relatedBy: .Equal,
                                  toItem: label.superview,
                               attribute: .Height,
                              multiplier: 24 / 736,
                                constant: 0.0)
    height.priority = 1000
    label.superview?.addConstraint(height)
    
  }
  
  func setupRemainingToggleButtonContraints() {
    
    let height =  NSLayoutConstraint(item: remainingToggleButton,
                               attribute: .Height,
                               relatedBy: .Equal,
                                  toItem: remainingToggleButton.superview,
                               attribute: .Height,
                              multiplier: 93 / 736,
                                constant: 0.0)
    height.priority = 1000
    remainingToggleButton.superview?.addConstraint(height)
    
  }
}

