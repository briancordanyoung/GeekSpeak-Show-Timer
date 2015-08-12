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
  
  struct Constants {
    static let GeekSpeakBlueColor = UIColor(red: 14/255,
                                          green: 115/255,
                                           blue: 192/255,
                                          alpha: 1.0)
    
    static let WarningColor       = UIColor(red: 13/255,
                                          green: 255/255,
                                           blue: 179/255,
                                          alpha: 1.0)
    
    static let AlarmColor         = UIColor(red: 255/255,
                                          green: 255/255,
                                           blue: 150/255,
                                          alpha: 1.0)
  }

  var timerViews: TimerViews?
  var timer: Timer {
    if let splitViewController = splitViewController as? SplitViewController {
      return splitViewController.timer
    } else {
      return Timer()
    }
  }
  
  var timerLabelDisplay: TimerLabelDisplay = .Remaining {
    didSet {
      updateTimerLabels(timer)
    }
  }

  
  @IBOutlet weak var timerCirclesView: UIView!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var sectionTimeLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var segmentLabel: UILabel!
  @IBOutlet weak var startPauseButton: UIButton!
  @IBOutlet weak var nextSegmentButton: UIButton!
  
  var lineWidth: CGFloat {
    return self.dynamicType.lineWidthForSize(timerCirclesView.frame.size)
  }
  
  
  class func lineWidthForSize(size: CGSize) -> CGFloat {
    let developmentLineWidth    = CGFloat(90)
    let developmentViewWidth    = CGFloat(736)
    let currentViewWidth = (size.width + size.height) / 2
    return (currentViewWidth / developmentViewWidth) * developmentLineWidth
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    
    setupContraints()
    setupTimeLabelContraints(totalTimeLabel)
    setupTimeLabelContraints(sectionTimeLabel)
    setupDescriptionLabelContraints(totalLabel)
    setupDescriptionLabelContraints(segmentLabel)
    setAppearenceOfNavigationBar()
    styleButtons()
    
    let fillView  = PieShapeView()
    fillView.opaque     = false
    fillView.startAngle = Rotation(degrees: 0)
    fillView.endAngle   = Rotation(degrees: 0)
    fillView.color      = UIColor(red: 0.75, green: 0.0, blue: 0.0, alpha: 1.0)
    fillView.pieLayer.clipToCircle = true
    timerCirclesView.addSubview(fillView)
    
    let ring1bg   = configureBGRing( RingView(),
      withColor: Constants.GeekSpeakBlueColor)
    let ring1fg   = configureFGRing( RingView(),
      withColor: Constants.GeekSpeakBlueColor)
    
    let ring2bg   = configureBGRing( RingView(),
      withColor: Constants.GeekSpeakBlueColor)
    let ring2fg   = configureFGRing( RingView(),
      withColor: Constants.GeekSpeakBlueColor)
    
    let ring3bg   = configureBGRing( RingView(),
      withColor: Constants.GeekSpeakBlueColor)
    let ring3fg   = configureFGRing( RingView(),
      withColor: Constants.GeekSpeakBlueColor)
    
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
    

  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    encodeTimerToDisk()
  }
  
  func setAppearenceOfNavigationBar() {
    self.navigationController?.navigationBar.setBackgroundImage( UIImage(),
      forBarMetrics: UIBarMetrics.Default)
    self.navigationController?.view.backgroundColor = UIColor.clearColor()
    self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
    self.navigationController?.navigationBar.translucent = true

  }
  
  // MARK: -
  // MARK: ViewController
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    timerViews?.layoutSubviewsWithLineWidth(lineWidth)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    encodeTimerToDisk()
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
    
  
  // TODO: This fuction is being called at about 60fps,
  //       everytime the timer updates.  It is setting values for many views
  //       that are not changing most of the time.   I'm not sure if I should
  //       be concerned with doing too much. look in to CPU usage and determine
  //       if it is worth doing something 'more clever'.

  func timerUpdatedTime(timer: Timer?) {
    if let timer = timer {
      updateTimerLabels(timer)
      let timing    = timer.timing
      let totalTime = timing.asShortString(timing.durations.totalShowTime)
      let labelText = padString( "Total: \(totalTime)",
                    totalLength: 15,
                            pad: " ",
                    inDirection: .Left)
      totalLabel.text = labelText
      
      switch timer.timing.phase {
      case .PreShow,
           .Break1,    // When a break, or the last segment is complete,
           .Break2,    // advance to the next segment
           .Section3:
        
        if timer.percentageComplete == 1.0 { timer.next() }
        timerLabelDisplay = .Remaining
        sectionTimeLabel.textColor = UIColor.whiteColor()
        totalTimeLabel.textColor   = UIColor.whiteColor()

      case .Section1,  // When a segment is complete, don't advance.
           .Section2:  // The user gets to do that
        
        timerLabelDisplay = .Remaining
        sectionTimeLabel.textColor = UIColor.whiteColor()
        totalTimeLabel.textColor   = UIColor.whiteColor()
        
      case .PostShow:
        timerLabelDisplay = .Elapsed
        sectionTimeLabel.textColor = Constants.GeekSpeakBlueColor
        totalTimeLabel.textColor   = Constants.GeekSpeakBlueColor
      }
      

      var segmentLabelText: String
      
      switch timer.timing.phase {
      case .PreShow:
        timerViews?.fill.percent    = timer.percentageComplete
        timerViews?.ring1fg.percent = 0.0
        timerViews?.ring2fg.percent = 0.0
        timerViews?.ring3fg.percent = 0.0
        segmentLabelText = " Pre Show"

      case .Section1:
        timerViews?.fill.percent    = 0.0
        timerViews?.ring1fg.progress = timer.percentageCompleteUnlimited
        timerViews?.ring2fg.percent = 0.0
        timerViews?.ring3fg.percent = 0.0
        segmentLabelText = "Segment 1"

      case .Break1:
        timerViews?.ring1fg.percent = 1.0
        timerViews?.fill.percent    = timer.percentageComplete
        timerViews?.ring2fg.percent = 0.0
        timerViews?.ring3fg.percent = 0.0
        segmentLabelText = "    Break"

      case .Section2:
        timerViews?.fill.percent    = 0.0
        timerViews?.ring1fg.percent = 1.0
        timerViews?.ring2fg.progress = timer.percentageCompleteUnlimited
        timerViews?.ring3fg.percent = 0.0
        segmentLabelText = "Segment 2"

      case .Break2:
        timerViews?.ring1fg.percent = 1.0
        timerViews?.ring2fg.percent = 1.0
        timerViews?.fill.percent    = timer.percentageComplete
        timerViews?.ring3fg.percent = 0.0
        segmentLabelText = "    Break"

      case .Section3:
        timerViews?.fill.percent    = 0.0
        timerViews?.ring1fg.percent = 1.0
        timerViews?.ring2fg.percent = 1.0
        timerViews?.ring3fg.percent = timer.percentageComplete
        segmentLabelText = "Segment 3"

      case .PostShow:
        timerViews?.ring1fg.percent = 1.0
        timerViews?.ring2fg.percent = 1.0
        timerViews?.ring3fg.percent = 1.0
        timerViews?.fill.percent = 0.0
        segmentLabelText = "Post Show"
      }
      
      segmentLabel.text =  padString( segmentLabelText,
                         totalLength: 15,
                                 pad: " ",
                         inDirection: .Right)
      }
  }

  func updateTimerLabels(timer: Timer) {
    let timing = timer.timing
    totalTimeLabel.text     = timing.asString(timer.totalShowTimeElapsed)

    switch timerLabelDisplay {
    case .Remaining:
      sectionTimeLabel.text = timing.asString(timer.secondsRemaining)
    case .Elapsed:
      sectionTimeLabel.text = timing.asString(timer.secondsElapsed)
    }
  }
  
  
  // MARK: -
  // MARK: Actions
  @IBAction func showSettingsButtonPressed(sender: UIBarButtonItem) {
    self.splitViewController?.toggleMasterView()
  }
  
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
  }
  
  @IBAction func remainingTimeToggled(sender: UIButton) {
    // This button is currently disabled in the storyboard to
    // remove user control over toggling between remaining and
    // completed time display.
    switch timerLabelDisplay {
    case .Remaining:
      timerLabelDisplay = .Elapsed
    case .Elapsed:
      timerLabelDisplay = .Remaining
    }
  }
  
  
  // MARK: -
  // MARK: Setup
  func configureFGRing(ringView: RingView, withColor color: UIColor)
                                                            -> RingView {
      ringView.color      = color
      ringView.startAngle = Rotation(degrees: 0)
      ringView.endAngle   = Rotation(degrees: 10)
      ringView.ringWidth  = lineWidth
      configureRing(ringView)
      return ringView
  }
  
  func configureBGRing(ringView: RingView, withColor color: UIColor)
                                                            -> RingView {
      ringView.color     = color.darkenColorWithMultiplier(0.2)
      ringView.ringWidth = lineWidth
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
    if let labelSuperView = label.superview {
      let width =  NSLayoutConstraint(item: label,
                                 attribute: .Width,
                                 relatedBy: .Equal,
                                    toItem: labelSuperView,
                                 attribute: .Width,
                                multiplier: 199 / 736,
                                  constant: 0.0)
      width.priority = 1000
      labelSuperView.addConstraint(width)
    }
  }
  
  func setupDescriptionLabelContraints(label: UILabel) {
    if let labelSuperView = label.superview {
          let height =  NSLayoutConstraint(item: label,
                                      attribute: .Height,
                                      relatedBy: .Equal,
                                         toItem: labelSuperView,
                                      attribute: .Height,
                                     multiplier: 20 / 736,
                                       constant: 0.0)
      height.priority = 1000
      labelSuperView.addConstraint(height)
    }
  }
  
  enum Direction {
    case Left
    case Right
  }
  
  func padString(var string: String,
                totalLength: Int,
                        pad: Character,
      inDirection direction: Direction) -> String {
        
    var i = 0
    for character in string {
      i++
    }
    
    let amountToPad = totalLength - i
    if amountToPad < 1 {
      return string
    }
    let padString = String(pad)
    for _ in 1...amountToPad {
      switch direction {
        case .Left:
          string = string + padString
        case .Right:
          string = padString + string
      }
    }
    return string
  }



}

