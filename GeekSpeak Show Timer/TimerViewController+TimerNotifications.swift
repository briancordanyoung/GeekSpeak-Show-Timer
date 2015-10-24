import UIKit

extension TimerViewController {

  func registerForTimerNotifications() {
    let notifyCenter = NSNotificationCenter.defaultCenter()
    
    notifyCenter.addObserver( self,
                    selector: "timerUpdatedTime",
                        name: Timer.Constants.TimeChange,
                      object: timer)
    
    notifyCenter.addObserver( self,
                    selector: "timerChangedCountingStatus",
                        name: Timer.Constants.CountingStatusChanged,
                      object: timer)

    notifyCenter.addObserver( self,
                    selector: "timerDurationChanged",
                        name: Timer.Constants.DurationChanged,
                      object: timer)
  }

  func unregisterForTimerNotifications() {
    let notifyCenter = NSNotificationCenter.defaultCenter()
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
    let section2Seconds: NSTimeInterval
    let section3Seconds: NSTimeInterval
    
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
        sectionTimeLabel.textColor = UIColor.whiteColor()
        totalTimeLabel.textColor   = UIColor.whiteColor()
        
      case .PostShow:
        timerLabelDisplay = .Elapsed
        sectionTimeLabel.textColor = Appearance.Constants.GeekSpeakBlueColor
        totalTimeLabel.textColor   = Appearance.Constants.GeekSpeakBlueColor
      }
    }
  }
  
  
  func displayAllTime() {
    if let timer = timer {
      
      
      if timer.timing.phase == .Break1 {
        let secondsElapsed = timer.timing.timeElapsed.break1
        let duration = timer.timing.durations.break1
        let secondsRemaining = duration - secondsElapsed
        let percentage = CGFloat(secondsRemaining / duration)
        timerViews?.fill.progress    = percentage
      }
      if timer.timing.phase == .Break2 {
        let secondsElapsed = timer.timing.timeElapsed.break2
        let duration = timer.timing.durations.break2
        let secondsRemaining = duration - secondsElapsed
        let percentage = CGFloat(secondsRemaining / duration)
        timerViews?.fill.progress    = percentage
      }
      
      let secondsElapsed1 = timer.timing.timeElapsed.section1
      let duration1 = timer.timing.durations.section1
      let secondsRemaining1 = duration1 - secondsElapsed1
      let percentage1 = CGFloat(1 - (secondsRemaining1 / duration1))
      timerViews?.ring1fg.progress = percentage1
      
      let secondsElapsed2 = timer.timing.timeElapsed.section2
      let duration2 = timer.timing.durations.section2
      let secondsRemaining2 = duration2 - secondsElapsed2
      let percentage2 = CGFloat(1 - (secondsRemaining2 / duration2))
      timerViews?.ring2fg.progress = percentage2

      let secondsElapsed3 = timer.timing.timeElapsed.section3
      let duration3 = timer.timing.durations.section3
      let secondsRemaining3 = duration3 - secondsElapsed3
      let percentage3 = CGFloat(1 - (secondsRemaining3 / duration3))
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
        
      segmentLabel.text =  padString( segmentLabelText,
                         totalLength: 15,
                                 pad: " ",
                         inDirection: .Right)
    }
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
      let labelText = padString( "Total: \(totalTime)",
                    totalLength: 15,
                            pad: " ",
                    inDirection: .Left)
      totalLabel.text = labelText
      
      // TODO: check if current section reaches 100% (1.0) 
      // and then animate the background ring to fade out.
      
      var segmentLabelText: String
      let phase = timer.timing.phase
      
      switch phase {
      case .PreShow:
        timerViews?.fill.progress    = timer.percentageComplete
        timerViews?.ring1fg.progress = 0.0
        timerViews?.ring2fg.progress = 0.0
        timerViews?.ring3fg.progress = 0.0
        segmentLabelText = " Pre Show"
        
      case .Section1:
        timerViews?.fill.progress    = 0.0
        timerViews?.ring1fg.progress = timer.percentageCompleteUnlimited //timer.percentageComplete(.Section1)
        timerViews?.ring2fg.progress = 0.0
        timerViews?.ring3fg.progress = 0.0
        segmentLabelText = "Section 1"
        
      case .Break1:
//        timerViews?.ring1fg.progress = timer.percentageComplete(.Section1)
        timerViews?.fill.progress    = timer.percentageComplete
        timerViews?.ring2fg.progress = 0.0
        timerViews?.ring3fg.progress = 0.0
        segmentLabelText = "    Break"
        
      case .Section2:
        timerViews?.fill.progress    = 0.0
//        timerViews?.ring1fg.progress = timer.percentageComplete(.Section1)
        timerViews?.ring2fg.progress = timer.percentageCompleteUnlimited // timer.percentageComplete(.Section2)
        timerViews?.ring3fg.progress = 0.0
        segmentLabelText = "Section 2"
        
      case .Break2:
//        timerViews?.ring1fg.progress = timer.percentageComplete(.Section1)
//        timerViews?.ring2fg.progress =  timer.percentageComplete(.Section2)
        timerViews?.fill.progress    = timer.percentageComplete
        timerViews?.ring3fg.progress = 0.0
        segmentLabelText = "    Break"
        
      case .Section3:
        timerViews?.fill.progress    = 0.0
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
        timerViews?.fill.percent = 0.0
        segmentLabelText = "Post Show"
      }
      
      segmentLabel.text =  padString( segmentLabelText,
                         totalLength: 15,
                                 pad: " ",
                         inDirection: .Right)
      
      totalTimeLabel.text     = timing.asShortString(timer.totalShowTimeElapsed)
      
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
  
  func timeInterval(time: NSTimeInterval, isBetweenA a: NSTimeInterval,
                                                andB b:NSTimeInterval) -> Bool {
    
    let small = min(a,b)
    let large = max(a,b)
    let smaller = time >= small
    let larger  = time <= large
    
    return smaller && larger
  }
  
  
}