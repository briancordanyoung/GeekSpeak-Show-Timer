import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  struct Constants {
    static let TimerId              = "timerViewControllerTimerId"
    static let TimerNotificationKey = "com.geekspeak.timerNotificationKey"
    static let TimerDataPath        = "TimerData.plist"
  }
  
  

  var timer = Timer()
  var splitViewControllerDelegate = TimerSplitViewControllerDelegate()
  var window: UIWindow?
  
  var splitViewController: UISplitViewController? {
    if let splitViewController = self.window?.rootViewController
      as? UISplitViewController {
      return splitViewController
    } else {
      return .None
    }
  }


  func application(application: UIApplication,
       didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
                                                                       -> Bool {
    registerUserDefaults()
    Appearance.apply()
    setupSplitViewController()
    resetTimerIfShowTimeElapsed()
    return true
  }
  

  func application(application: UIApplication,
          willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?)
                                                                       -> Bool {
    self.window?.makeKeyAndVisible()
    UIApplication.sharedApplication()
                 .setStatusBarStyle( UIStatusBarStyle.Default,
                           animated: false)
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
  }

  func applicationDidEnterBackground(application: UIApplication) {
  }

  func applicationWillEnterForeground(application: UIApplication) {
    resetTimerIfShowTimeElapsed()
  }

  func applicationDidBecomeActive(application: UIApplication) {
    resetTimerIfShowTimeElapsed()
  }

  func applicationWillTerminate(application: UIApplication) {
  }
  
  func application(application: UIApplication, shouldSaveApplicationState
                         coder: NSCoder) -> Bool {
    return true
  }

  func application(application: UIApplication, shouldRestoreApplicationState
                         coder: NSCoder) -> Bool {
    return true
  }

}


extension AppDelegate {

  func resetTimerIfShowTimeElapsed() {
    // reset the timer if it hasn't started, so that it uses the UserDefaults
    // to set which timing to use (demo or show)
    let useDemoDurations = NSUserDefaults
                                  .standardUserDefaults()
                                  .boolForKey(Timer.Constants.UseDemoDurations)
    if timer.totalShowTimeElapsed == 0 {
      if useDemoDurations {
        timer.reset(usingDemoTiming: true)
      } else {
        timer.reset(usingDemoTiming: false)
      }
    }
  }
  
  func setupSplitViewController() {
    if let splitViewController = splitViewController {
      // setup nav bar buttons
//        let index = splitViewController.viewControllers.count - 1
//        let navigationController = splitViewController
//                              .viewControllers[index] as! UINavigationController
//        let navItem = navigationController.topViewController.navigationItem
//        navItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
//        navItem.leftItemsSupplementBackButton = true

      splitViewController.delegate = splitViewControllerDelegate
      
      // This is a hack.  Once I find the correct place to tell the splitViewController
      // to use .PrimaryOverlay when in horizontal regular, I can remove this.
      switch Device() {
      case  .iPhone4,
            .iPhone4s,
            .iPhone5,
            .iPhone5c,
            .iPhone5s,
            .iPodTouch5,
            .iPhone6:
        break
      case .iPhone6Plus:
        break
      case .Simulator:
        break
      default:
        splitViewController.preferredDisplayMode = .PrimaryOverlay
      }
    }
  }

  func pressButtonBarItem() {
    func setupSplitViewController() {
      if let splitViewController = splitViewController {
          let barButtonItem = splitViewController.displayModeButtonItem()
            UIApplication.sharedApplication().sendAction( barButtonItem.action,
                                                      to: barButtonItem.target,
                                                    from: nil,
                                                forEvent: nil)
          }
      }
  }
  
  // Setup the default defaults in app memory
  func registerUserDefaults() {
    let defaults: [String:AnyObject] = [
      Timer.Constants.UseDemoDurations: false
    ]
    
    NSUserDefaults.standardUserDefaults().registerDefaults(defaults)
  }
  
}


