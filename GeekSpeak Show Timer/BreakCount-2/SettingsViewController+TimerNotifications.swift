import UIKit

extension SettingsViewController {

  func registerForTimerNotifications() {
    let notifyCenter = NotificationCenter.default
    
    notifyCenter.addObserver( self,
                    selector: #selector(SettingsViewController.updateElapsedTimeLabels),
                        name: NSNotification.Name(rawValue: Timer.Constants.TimeChange),
                      object: timer)
    
    notifyCenter.addObserver( self,
                    selector: #selector(SettingsViewController.updateElapsedTimeLabels),
                        name: NSNotification.Name(rawValue: Timer.Constants.DurationChanged),
                      object: timer)
  }

  func unregisterForTimerNotifications() {
    let notifyCenter = NotificationCenter.default
// TODO: When I explicitly remove each observer it throws an execption. why?
//    notifyCenter.removeObserver( self,
//                     forKeyPath: Timer.Constants.TimeChange)
//    notifyCenter.removeObserver( self,
//                     forKeyPath: Timer.Constants.DurationChanged)
    notifyCenter.removeObserver(self)

  }
  
  // MARK: Actions
  @objc func updateElapsedTimeLabels() {
    if let timer = timer {
      
      let timing   = timer.timing
      
      var segment1 = timing.asShortString(timing.timeElapsed.section1)
      var segment2 = timing.asShortString(timing.timeElapsed.section2)
      var postshow = timing.asShortString(timing.timeElapsed.postShow)
      
      switch timing.phase {
      case .PreShow,
           .Break1:
        break
        
      case .Section1:
        segment1 = timing.asShortString(timer.secondsElapsed)
        
      case .Section2:
        segment2 = timing.asShortString(timer.secondsElapsed)
        
      case .PostShow:
        postshow = timing.asShortString(timer.secondsElapsed)
      }
      
      segment1Label.text = segment1
      segment2Label.text = segment2
      postShowLabel.text = postshow
      
      generateBlurredBackground()
    }
  }

}
