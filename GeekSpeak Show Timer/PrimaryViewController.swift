import UIKit

class PrimaryViewController: REFrostedViewController,
                             REFrostedViewControllerDelegate {
  
  
  
  override func awakeFromNib() {
    guard let storyboard = storyboard else {
      assertionFailure("Storyboard is nil. Could not Instantiate ViewControllers")
      return
    }
    
    let timerViewController = storyboard
                .instantiateViewControllerWithIdentifier("timerViewController")
    let settingsViewController = storyboard
              .instantiateViewControllerWithIdentifier("settingsViewController")
    
    
    if let timerViewController = timerViewController as? TimerViewController,
    settingsViewController = settingsViewController as? SettingsViewController {
      settingsViewController.timerViewController = timerViewController
    }
    
    contentViewController = timerViewController
    menuViewController = settingsViewController
    
  
    panGestureEnabled         = true
    direction                 = .Left
    liveBlurBackgroundStyle   = .Dark
    liveBlur                  = false
    limitMenuViewSize         = true
    backgroundFadeAmount      = CGFloat(0)
    menuViewSize              = CGSize(width: 320, height: 0)
    delegate                  = self
    blurRadius                = 0
    blurSaturationDeltaFactor = 0
    blurTintColor             = UIColor.clearColor()
    
    
  }
  
  
  
  
  func frostedViewController(frostedViewController: REFrostedViewController!,
              didHideMenuViewController menuViewController: UIViewController!) {
    
  }
  
  func frostedViewController(frostedViewController: REFrostedViewController!,
              didShowMenuViewController menuViewController: UIViewController!) {
    
  }
  
  func frostedViewController(frostedViewController: REFrostedViewController!,
             willHideMenuViewController menuViewController: UIViewController!) {
    
  }
  
  func frostedViewController(frostedViewController: REFrostedViewController!,
             willShowMenuViewController menuViewController: UIViewController!) {
    
  }
  
  func frostedViewController(frostedViewController: REFrostedViewController!,
      willAnimateRotationToInterfaceOrientation toInterfaceOrientation: UIInterfaceOrientation,
                                          duration: NSTimeInterval) {
    
  }
  
  func frostedViewController(frostedViewController: REFrostedViewController!,
                   didRecognizePanGesture recognizer: UIPanGestureRecognizer!) {

  }
  
}
