import UIKit

class PrimaryViewController: REFrostedViewController,
                             REFrostedViewControllerDelegate {
  
// TODO: sharedApplication().setStatusBarStyle is depricated. The following does
//       not do the same thing, but I thought it should.  Research and impliment
//
//  override func preferredStatusBarStyle() -> UIStatusBarStyle {
//    print("PrimaryViewController preferredStatusBarStyle")
//    return .LightContent
//  }
//
//  override func viewDidAppear(animated: Bool) {
//    setNeedsStatusBarAppearanceUpdate()
//  }
  
  override func awakeFromNib() {
    guard let storyboard = storyboard else {
      assertionFailure("Storyboard is nil. Could not Instantiate ViewControllers")
      return
    }
    

    let timerViewController = storyboard
                 .instantiateViewController(withIdentifier: "timerViewController")
    
    let settingsViewController = storyboard
              .instantiateViewController(withIdentifier: "settingsViewController")
    
    contentViewController = timerViewController
    menuViewController    = settingsViewController
    
    panGestureEnabled         = true
    direction                 = .left
    liveBlurBackgroundStyle   = .dark
    liveBlur                  = false
    limitMenuViewSize         = true
    backgroundFadeAmount      = CGFloat(1)
    menuViewSize              = CGSize(width: 320, height: 0)
    delegate                  = self
    blurRadius                = 0
    blurSaturationDeltaFactor = 0
    blurTintColor             = UIColor.clear
  }
  
  override func viewWillAppear(_ animated: Bool) {
    injectTimerIntoContainedViewControllers()
  }
  
  
  func frostedViewController(_ frostedViewController: REFrostedViewController!,
              didHideMenuViewController menuViewController: UIViewController!) {
    
  }
  
  func frostedViewController(_ frostedViewController: REFrostedViewController!,
              didShowMenuViewController menuViewController: UIViewController!) {
    
  }
  
  func frostedViewController(_ frostedViewController: REFrostedViewController!,
             willHideMenuViewController menuViewController: UIViewController!) {
    
  }
  
  func frostedViewController(_ frostedViewController: REFrostedViewController!,
             willShowMenuViewController menuViewController: UIViewController!) {
    
  }
  
  func frostedViewController(_ frostedViewController: REFrostedViewController!,
      willAnimateRotationTo toInterfaceOrientation: UIInterfaceOrientation,
                                          duration: TimeInterval) {
                                            
      UIView.animate(withDuration: duration,
        animations: {},
        completion: { finished in
          self.updateSettingViewControllerBlurredBackground()
      })
  }
  
  func updateSettingViewControllerBlurredBackground() {
    if let settingsViewController = menuViewController as? SettingsViewController {
      settingsViewController.generateBlurredBackground()
    }
  }
  
  func frostedViewController(_ frostedViewController: REFrostedViewController!,
                   didRecognizePanGesture recognizer: UIPanGestureRecognizer!) {
  }
  

  func injectTimerIntoContainedViewControllers() {
    if let timerViewController = contentViewController as? TimerViewController,
        let settingsViewController = menuViewController as? SettingsViewController {
        
        settingsViewController.timerViewController = timerViewController
        
        if let appDelegate = UIApplication.shared.delegate
                                                              as? AppDelegate  {
            let timer = appDelegate.timer
            timerViewController.timer    = timer
            settingsViewController.timer = timer
        }
    }
  }
  
}
