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
        let twoMinuteWarning = timer.percentageFromSecondsToEnd(section2Seconds)
        let sectionColor2   = RingView.sectionColor( Constants.WarningColor,
                                       atPercentage: twoMinuteWarning)
        timerViews?.ring3fg.additionalColors.append(sectionColor2)
        
        let halfMinuteWarning = timer.percentageFromSecondsToEnd(section3Seconds)
        let sectionColor3   = RingView.sectionColor( Constants.AlarmColor,
                                       atPercentage: halfMinuteWarning)
        timerViews?.ring3fg.additionalColors.append(sectionColor3)
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
        sectionTimeLabel.textColor = Constants.GeekSpeakBlueColor
        totalTimeLabel.textColor   = Constants.GeekSpeakBlueColor
      }
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
        segmentLabelText = "Section 1"
        
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
        segmentLabelText = "Section 2"
        
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
      
      totalTimeLabel.text     = timing.asString(timer.totalShowTimeElapsed)
      
        updateTimerLabels()
      }
    }
  
    func updateTimerLabels() {
      if let timer = timer {
        let timing = timer.timing
        switch timerLabelDisplay {
        case .Remaining:
          sectionTimeLabel.text = timing.asString(timer.secondsRemaining)
        case .Elapsed:
          sectionTimeLabel.text = timing.asString(timer.secondsElapsed)
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