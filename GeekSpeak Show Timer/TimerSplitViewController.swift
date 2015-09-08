import UIKit

class TimerSplitViewController: UISplitViewController {

  
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
  
  func setDisplayMode() {
    if collapsed {
      preferredDisplayMode = .Automatic
    } else {
      preferredDisplayMode = .PrimaryOverlay
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    println("Segue: \(segue.identifier)")
    if segue.identifier == "showDetail" {
      if let navController = segue.destinationViewController as? UINavigationController {
        if let timerViewController = navController.topViewController as? TimerViewController {
          println("Segue: \(segue.identifier)  found: TimerViewController")
        }
      }
    }
    if segue.identifier == "showMaster" {
      if let navController = segue.destinationViewController as? UINavigationController {
        if let timerViewController = navController.topViewController as? SettingsViewController {
          println("Segue \(segue.identifier)  found: SettingsViewController")
        }
      }
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

