import UIKit

extension SettingsViewController {

  func registerForTimerNotifications() {
    let notifyCenter = NSNotificationCenter.defaultCenter()
    
    notifyCenter.addObserver( self,
                    selector: "updateElapsedTimeLabels",
                        name: Timer.Constants.TimeChange,
                      object: timer)
    
    notifyCenter.addObserver( self,
                    selector: "updateElapsedTimeLabels",
                        name: Timer.Constants.DurationChanged,
                      object: timer)
  }

  func unregisterForTimerNotifications() {
    let notifyCenter = NSNotificationCenter.defaultCenter()
// TODO: When I explicitly remove each observer it throws an execption. why?
//    notifyCenter.removeObserver( self,
//                     forKeyPath: Timer.Constants.TimeChange)
//    notifyCenter.removeObserver( self,
//                     forKeyPath: Timer.Constants.DurationChanged)
    notifyCenter.removeObserver(self)

  }
  
  // MARK: Actions
  func updateElapsedTimeLabels() {
    if let timer = timer {
      
      let timing   = timer.timing
      
      var segment1 = timing.asShortString(timing.timeElapsed.section1)
      var segment2 = timing.asShortString(timing.timeElapsed.section2)
      var segment3 = timing.asShortString(timing.timeElapsed.section3)
      var segment4 = timing.asShortString(timing.timeElapsed.section4)
      var postshow = timing.asShortString(timing.timeElapsed.postShow)
      
      switch timing.phase {
      case .PreShow,
           .Break1,
           .Break2,
           .Break3:
        break
        
      case .Section1:
        segment1 = timing.asShortString(timer.secondsElapsed)
        
      case .Section2:
        segment2 = timing.asShortString(timer.secondsElapsed)
        
      case .Section3:
        segment3 = timing.asShortString(timer.secondsElapsed)
        
      case .Section4:
        segment4 = timing.asShortString(timer.secondsElapsed)
        
      case .PostShow:
        postshow = timing.asShortString(timer.secondsElapsed)
      }
      
      segment1Label.text = segment1
      segment2Label.text = segment2
      segment3Label.text = segment3
      segment4Label.text = segment4
      postShowLabel.text = postshow
      
      generateBlurredBackground()
    }
  }

}