import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  struct Constants {
    static let TimerId              = "timerViewControllerTimerId"
    static let TimerNotificationKey = "com.geekspeak.timerNotificationKey"
    static let TimerDataPath        = "TimerData.plist"
  }
  
  

  var timer = Timer()
  var window: UIWindow?
  
  func application(application: UIApplication,
       didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
                                                                       -> Bool {
    registerUserDefaults()
    Appearance.apply()
    resetTimerIfShowTimeElapsed()
    registerForTimerNotifications()
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
  
  func applicationWillEnterForeground(application: UIApplication) {
    resetTimerIfShowTimeElapsed()
    timerChangedCountingStatus()
  }

  func applicationDidBecomeActive(application: UIApplication) {
    timerChangedCountingStatus()
  }
  
  func applicationWillResignActive(application: UIApplication) {
  }

  func applicationDidEnterBackground(application: UIApplication) {
    UIApplication.sharedApplication().idleTimerDisabled = false
  }

  
  func applicationWillTerminate(application: UIApplication) {
  }
  
  func application(application: UIApplication, shouldSaveApplicationState
                         coder: NSCoder) -> Bool {
    unregisterForTimerNotifications()
    return true
  }

  func application(application: UIApplication, shouldRestoreApplicationState
                         coder: NSCoder) -> Bool {
    registerForTimerNotifications()
    return true
  }

}


extension AppDelegate {
  
  func registerForTimerNotifications() {
    let notifyCenter = NSNotificationCenter.defaultCenter()
    notifyCenter.addObserver( self,
                    selector: "timerChangedCountingStatus",
                        name: Timer.Constants.CountingStatusChanged,
                      object: timer)

  }
  
  func unregisterForTimerNotifications() {
    let notifyCenter = NSNotificationCenter.defaultCenter()
    // TODO: When I explicitly remove each observer it throws an execption. why?
    //    notifyCenter.removeObserver( self,
    //                     forKeyPath: Timer.Constants.CountingStatusChanged)
    notifyCenter.removeObserver(self)
    
  }

  func timerChangedCountingStatus() {
    switch timer.state {
    case .Ready,
         .Paused,
         .PausedAfterComplete:
      UIApplication.sharedApplication().idleTimerDisabled = false
      
    case .Counting,
         .CountingAfterComplete:
      UIApplication.sharedApplication().idleTimerDisabled = true
    }

  }

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
  

  
  // Setup the default defaults in app memory
  func registerUserDefaults() {
    let useDebugTimings: Bool
    #if DEBUG
      useDebugTimings = true
    #else
      useDebugTimings = false
    #endif
    
    let defaults: [String:AnyObject] = [
      Timer.Constants.UseDemoDurations: useDebugTimings
    ]
    
    NSUserDefaults.standardUserDefaults().registerDefaults(defaults)
  }

  
}


