import UIKit
import TimerViewsGear

extension TimerViewController {

  func registerForTimerNotifications() {
    let notifyCenter = NotificationCenter.default
    
    notifyCenter.addObserver( self,
                    selector: #selector(TimerViewController.timerUpdatedTime),
                        name: NSNotification.Name(rawValue: Timer.Constants.TimeChange),
                      object: timer)
    
    notifyCenter.addObserver( self,
                    selector: #selector(TimerViewController.timerChangedCountingStatus),
                        name: NSNotification.Name(rawValue: Timer.Constants.CountingStatusChanged),
                      object: timer)

    notifyCenter.addObserver( self,
                    selector: #selector(TimerViewController.timerDurationChanged),
                        name: NSNotification.Name(rawValue: Timer.Constants.DurationChanged),
                      object: timer)
  }

  func unregisterForTimerNotifications() {
    let notifyCenter = NotificationCenter.default
// TODO: When I explicitly remove each observer it throws an execption. why?
//    notifyCenter.removeObserver( self,
//                     forKeyPath: Timer.Constants.TimeChange)
//    notifyCenter.removeObserver( self,
//                     forKeyPath: Timer.Constants.CountingStatusChanged)
//    notifyCenter.removeObserver( self,
//                     forKeyPath: Timer.Constants.DurationChanged)
    notifyCenter.removeObserver(self)

  }

  
  // MARK: -
  // MARK: Timer callback funtions
  
  
  func timerChangedCountingStatus() {
    if let timer = timer {
      updateButtonLayout(timer)
    }
  }
  
  func timerDurationChanged() {
    // TODO: Remove this logic and replace it when the ShowTiming struct
    //       is abstracted out to some sort of generalized definition
    
// TODO: Move to new TimerView
    let section2Seconds: TimeInterval
    let section3Seconds: TimeInterval
    
    if let timer = timer {
      if timer.demoTimings {
        section2Seconds = 2
        section3Seconds = 1
      } else {
        section2Seconds = 120
        section3Seconds = 30
      }
    
      switch timer.timing.phase {
      case .Section3:
        let timing1 = CGFloat(timer.timing.duration - section2Seconds - section3Seconds)
        let color1 = RingColor( portion: timing1,
                                  color: Appearance.Constants.GeekSpeakBlueColor)
        let color2 = RingColor( portion: CGFloat(section2Seconds),
                                  color: Appearance.Constants.WarningColor)
        let color3 = RingColor( portion: CGFloat(section3Seconds),
                                  color: Appearance.Constants.AlarmColor)
        timerViews?.ring3fg.colors = [color1,color2,color3]
      default:
        break
      }
    
      // end todo move
      
      
      switch timer.timing.phase {
      case .PreShow,
           .Break1,
           .Break2,
           .Section3,
           .Section1,
           .Section2:
        timerLabelDisplay = .Remaining
        sectionTimeLabel.textColor = UIColor.white
        totalTimeLabel.textColor   = UIColor.white
        
      case .PostShow:
        timerLabelDisplay = .Elapsed
        sectionTimeLabel.textColor = Appearance.Constants.GeekSpeakBlueColor
        totalTimeLabel.textColor   = Appearance.Constants.GeekSpeakBlueColor
      }
    }
  }
  
  
  
  // Reset all TimerViews using the current state of the timer
  // TODO: Timer Class Refactor
  // This is a hack.  Most of this needs to be refactored in to
  // the NEW timer class when it is abstracted and generalized
  // to use abitrary timings
  func displayAllTime() {
    guard let timer = timer else {return}
      
    let useDemoDurations = UserDefaults.standard
                           .bool(forKey: Timer.Constants.UseDemoDurations)

    var durations = Timer.Durations()
    if useDemoDurations {
      durations.useDemoDurations()
    }
      
    if timer.timing.phase == .Break1 {
      let secondsElapsed = timer.timing.timeElapsed.break1
      let secondsRemaining = durations.break1 - secondsElapsed
      let percentage = CGFloat(secondsRemaining / durations.break1)
      timerViews?.breakView.progress    = percentage
    }
    if timer.timing.phase == .Break2 {
      let secondsElapsed = timer.timing.timeElapsed.break2
      let secondsRemaining = durations.break2 - secondsElapsed
      let percentage = CGFloat(secondsRemaining / durations.break2)
      timerViews?.breakView.progress    = percentage
    }
    
    
    let planedDuration1 = durations.section1
    let secondsElapsed1 = timer.timing.timeElapsed.section1
    let difference1 = planedDuration1 - secondsElapsed1
    let secondsRemaining1 = planedDuration1 - secondsElapsed1
    let percentage1 = CGFloat(1 - (secondsRemaining1 / planedDuration1))
    timerViews?.ring1fg.progress = percentage1
    
    durations.section1 -= difference1
    durations.section2 += difference1
    
    let planedDuration2 = durations.section2
    let secondsElapsed2 = timer.timing.timeElapsed.section2
    let difference2 = planedDuration2 - secondsElapsed2
    let secondsRemaining2 = planedDuration2 - secondsElapsed2
    let percentage2 = CGFloat(1 - (secondsRemaining2 / planedDuration2))
    timerViews?.ring2fg.progress = percentage2

    durations.section2 -= difference2
    durations.section3 += difference2
    
    let secondsElapsed3 = timer.timing.timeElapsed.section3
    let secondsRemaining3 = durations.section3 - secondsElapsed3
    let percentage3 = CGFloat(1 - (secondsRemaining3 / durations.section3))
    timerViews?.ring3fg.progress = percentage3

    var segmentLabelText: String
    switch timer.timing.phase {
    case .PreShow:  segmentLabelText = " Pre Show"
    case .Section1: segmentLabelText = "Section 1"
    case .Break1:   segmentLabelText = "    Break"
    case .Section2: segmentLabelText = "Section 2"
    case .Break2:   segmentLabelText = "    Break"
    case .Section3: segmentLabelText = "Section 3"
    case .PostShow: segmentLabelText = "Post Show"
    }
      
    segmentLabel.text = segmentLabelText.pad(" ", totalLength: 15, side: .right)
  }
  
  
  
  
  
  
  
  // TODO: This fuction is being called at about 60fps,
  //       everytime the timer updates.  It is setting values for many views
  //       that are not changing most of the time.   I'm not sure if I should
  //       be concerned with doing too much. look in to CPU usage and determine
  //       if it is worth doing something 'more clever'.
  
  func timerUpdatedTime() {
    if let timer = timer {
      let timing    = timer.timing
      let totalTime = timing.asShortString(timing.durations.totalShowTime)
      let labelText = "Total: \(totalTime)"
                                        .pad(" ", totalLength: 15, side: .left)
      totalLabel.text = labelText
      
      // TODO: check if current section reaches 100% (1.0) 
      // and then animate the background ring to fade out.
      
      var segmentLabelText: String
      let phase = timer.timing.phase
      
      switch phase {
      case .PreShow:
        timerViews?.breakView.progress    = timer.percentageComplete
        timerViews?.ring1fg.progress = 0.0
        timerViews?.ring2fg.progress = 0.0
        timerViews?.ring3fg.progress = 0.0
        segmentLabelText = " Pre Show"
        
      case .Section1:
        timerViews?.breakView.progress    = 0.0
        timerViews?.ring1fg.progress = timer.percentageCompleteUnlimited //timer.percentageComplete(.Section1)
        timerViews?.ring2fg.progress = 0.0
        timerViews?.ring3fg.progress = 0.0
        segmentLabelText = "Section 1"
        
      case .Break1:
//        timerViews?.ring1fg.progress = timer.percentageComplete(.Section1)
        timerViews?.breakView.progress    = timer.percentageComplete
        timerViews?.ring2fg.progress = 0.0
        timerViews?.ring3fg.progress = 0.0
        segmentLabelText = "    Break"
        
      case .Section2:
        timerViews?.breakView.progress    = 0.0
//        timerViews?.ring1fg.progress = timer.percentageComplete(.Section1)
        timerViews?.ring2fg.progress = timer.percentageCompleteUnlimited // timer.percentageComplete(.Section2)
        timerViews?.ring3fg.progress = 0.0
        segmentLabelText = "Section 2"
        
      case .Break2:
//        timerViews?.ring1fg.progress = timer.percentageComplete(.Section1)
//        timerViews?.ring2fg.progress =  timer.percentageComplete(.Section2)
        timerViews?.breakView.progress    = timer.percentageComplete
        timerViews?.ring3fg.progress = 0.0
        segmentLabelText = "    Break"
        
      case .Section3:
        timerViews?.breakView.progress    = 0.0
//        timerViews?.ring1fg.progress = timer.percentageComplete(.Section1)
//        timerViews?.ring2fg.progress = timer.percentageComplete(.Section2)
        timerViews?.ring3fg.progress = timer.percentageComplete // timer.percentageComplete(.Section3)
        segmentLabelText = "Section 3"
        
        // TODO:  Move this in to the ShowTiming struct
        if timer.demoTimings {
          if timeInterval(timer.secondsRemaining, isBetweenA: 2, andB: 1.5) {
            animateWarning()
          }
          if timeInterval(timer.secondsRemaining, isBetweenA: 1, andB: 0.5) {
            animateWarning()
          }
          
        } else {
          if timeInterval(timer.secondsRemaining, isBetweenA: 120, andB: 117) {
            animateWarning()
          }
          
          if timeInterval(timer.secondsRemaining, isBetweenA: 30, andB: 27) {
            animateWarning()
          }
        }
        
        // end todo move

        
        
      case .PostShow:
//        timerViews?.ring1fg.progress = timer.percentageComplete(.Section1)
//        timerViews?.ring2fg.progress = timer.percentageComplete(.Section2)
//        timerViews?.ring3fg.progress = timer.percentageComplete(.Section3)
        timerViews?.breakView.progress = 0.0
        segmentLabelText = "Post Show"
      }
      
      segmentLabel.text   = segmentLabelText.pad(" ", totalLength: 15,
                                                             side: .right)
      totalTimeLabel.text = timing.asShortString(timer.totalShowTimeElapsed)
      
      updateTimerLabels()
      activityView.activity = CGFloat(timer.secondsElapsed)
      }
    }
  
    func updateTimerLabels() {
      if let timer = timer {
        let timing = timer.timing
        switch timerLabelDisplay {
        case .Remaining:
          sectionTimeLabel.text = timing.asShortString(timer.secondsRemaining)
        case .Elapsed:
          sectionTimeLabel.text = timing.asShortString(timer.secondsElapsed)
      }
    }
  }
  
  func timeInterval(_ time: TimeInterval, isBetweenA a: TimeInterval,
                                                andB b:TimeInterval) -> Bool {
    
    let small = min(a,b)
    let large = max(a,b)
    let smaller = time >= small
    let larger  = time <= large
    
    return smaller && larger
  }
  
  
}
