import UIKit

class TimerSplitViewController: UISplitViewController,
                                UISplitViewControllerDelegate {

  
  struct Constants {
    static let TimerId              = "timerViewControllerTimerId"
    static let TimerNotificationKey = "com.geekspeak.timerNotificationKey"
    static let TimerDataPath        = "TimerData.plist"
  }
  
  
  var timer = Timer()
  
  override func viewDidLoad() {
    self.delegate = self
  }
  
  override func viewDidAppear(animated: Bool) {
    setDisplayMode()
  }
  
  // Make sure the Settings View is displayed on startup
  // http://stackoverflow.com/questions/25875618/uisplitviewcontroller-in-portrait-on-iphone-shows-detail-vc-instead-of-master
  func splitViewController(splitViewController: UISplitViewController,
    collapseSecondaryViewController secondaryViewController: UIViewController!,
            ontoPrimaryViewController primaryViewController: UIViewController!)
                                                                      -> Bool {
    return true
  }

  func setDisplayMode() {
    if collapsed {
      preferredDisplayMode = .Automatic
    } else {
      preferredDisplayMode = .PrimaryOverlay
    }
  }
    
//  override func viewWillAppear(animated: Bool) {
//    for viewController in viewControllers {
//      injectTimerInViewController(viewController as! UIViewController)
//    }
//  }
//  
//  override func showDetailViewController( viewController: UIViewController!,
//                                                  sender: AnyObject!) {
//    println("showDetailViewController")
//    injectTimerInViewController(viewController)
//    super.showDetailViewController(viewController, sender: sender)
//  }
//  
//  override func showViewController( viewController: UIViewController,
//                                            sender: AnyObject!) {
//    println("showViewController")
//    injectTimerInViewController(viewController)
//    super.showViewController(viewController, sender: sender)
//  }
//  
//  func splitViewController(splitViewController: UISplitViewController,
//                         showViewController vc: UIViewController,
//                                        sender: AnyObject?) -> Bool {
//    println("showViewController")
//    return false
//  }
//  
//  
//  func splitViewController(splitViewController: UISplitViewController,
//                   showDetailViewController vc: UIViewController,
//                                        sender: AnyObject?) -> Bool {
//    println("showDetailViewController")
//    return false
//  }
//  
//  
//  func injectTimerInViewController(viewController: UIViewController) {
//    if let settingsViewController = viewController as? SettingsViewController {
//      println("SettingsViewController timer set")
//                      
//      settingsViewController.timer = timer
//    }
//    if let timerViewController = viewController as? TimerViewController {
//      println("TimerViewController timer set")
//
//                      
//      timerViewController.timer = timer
//    }
//  }
//  
  
  
    
}



extension UISplitViewController {
  func toggleMasterView() {
    let barButtonItem = self.displayModeButtonItem()
    UIApplication.sharedApplication().sendAction( barButtonItem.action,
                                              to: barButtonItem.target,
                                            from: nil,
                                        forEvent: nil)
  }
}

