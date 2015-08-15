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
//    notifyCenter.removeObserver( self,
//                     forKeyPath: Timer.Constants.TimeChange)
//    notifyCenter.removeObserver( self,
//                     forKeyPath: Timer.Constants.DurationChanged)
    notifyCenter.removeObserver(self)

  }
  
  // MARK: Actions
  func updateElapsedTimeLabels() {
    
      let timing   = timer.timing
      
      var segment1 = timing.asString(timing.timeElapsed.section1)
      var segment2 = timing.asString(timing.timeElapsed.section2)
      var segment3 = timing.asString(timing.timeElapsed.section3)
      var postshow = timing.asString(timing.timeElapsed.postShow)
      
      switch timing.phase {
      case .PreShow,
           .Break1,
           .Break2:
        break
        
      case .Section1:
        segment1 = timing.asString(timer.secondsElapsed)
        
      case .Section2:
        segment2 = timing.asString(timer.secondsElapsed)
        
      case .Section3:
        segment3 = timing.asString(timer.secondsElapsed)
        
      case .PostShow:
        postshow = timing.asString(timer.secondsElapsed)
      }
      
      segment1Label.text = segment1
      segment2Label.text = segment2
      segment3Label.text = segment3
      postShowLabel.text = postshow
      
      // TODO: Uncomment once this is on a background thread
      //       generateBluredBackground()

  }

}