import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  struct Constants {
    static let CurrentTimerFileName = "Current Timer"
    static let TimerId              = "timerViewControllerTimerId"
    static let TimerNotificationKey = "com.geekspeak.timerNotificationKey"
    static let TimerDataPath        = "TimerData.plist"
  }
  
  
  var window: UIWindow?

  var timer: Timer {
    get {
      if let timer = _timer {
        return timer
      }
      
      if let timer = readCurrentTimer() {
        _timer = timer
        return timer
      } else {
        let timer = Timer()
        _timer = timer
        return timer
      }
      
    }
    set(timer) {
      _timer = timer
    }
  }
  private var _timer: Timer?
  
  // Convenience property to make intentions clear what is gonig on.
  var allowDeviceToSleepDisplay: Bool {
    get {
      return !UIApplication.sharedApplication().idleTimerDisabled
    }
    set(allowed) {
      UIApplication.sharedApplication().idleTimerDisabled = !allowed
    }
  }
  
  
  // MARK: App Delegate
  func application(application: UIApplication,
       didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
                                                                       -> Bool {
    registerUserDefaults()
    Appearance.apply()
    resetTimerIfShowTimeIsZero()
    registerForTimerNotifications()
    return true
  }



  func application(application: UIApplication,
          willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?)
                                                                       -> Bool {
    self.window?.makeKeyAndVisible()
    return true
  }
  

  
  func applicationWillEnterForeground(application: UIApplication) {
    resetTimerIfShowTimeIsZero()
//    setAllowDeviceToSleepDisplayForTimer(timer)
  }

  func applicationDidBecomeActive(application: UIApplication) {
    timerChangedCountingStatus()
  }
  
  func applicationWillResignActive(application: UIApplication) {
    writeCurrentTimer()
  }

  func applicationDidEnterBackground(application: UIApplication) {
    allowDeviceToSleepDisplay = true
  }

  func applicationDidReceiveMemoryWarning(application: UIApplication) {
    writeCurrentTimer()
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
  
  
  // MARK: -
  // MARK: Timer Persistance
  var applicationDocumentsDirectory: NSURL {
   return NSFileManager.defaultManager()
                     .URLsForDirectory( .DocumentDirectory,
                             inDomains: .UserDomainMask)
                     .last!
  }
  
  var savedTimer: NSURL {
    return applicationDocumentsDirectory
                    .URLByAppendingPathComponent(Constants.CurrentTimerFileName)
  }
  
  func writeCurrentTimer() {
    writeCurrentTimer(timer)
  }
  
  func writeCurrentTimer(timer: Timer) {
    if let name = savedTimer.lastPathComponent,
      directory = savedTimer.URLByDeletingLastPathComponent {
        
      let backupName = "\(name) Backup"
      let backupURL = directory.URLByAppendingPathComponent(backupName)

      if let path = savedTimer.path,
       backupPath = backupURL.path {
        let fileManager = NSFileManager.defaultManager()
        
        do {
          if fileManager.fileExistsAtPath(backupPath) {
            try fileManager.removeItemAtPath(backupPath)
          }
          if fileManager.fileExistsAtPath(path) {
            try fileManager.moveItemAtPath(path, toPath: backupPath)
          }
          if !NSKeyedArchiver.archiveRootObject(timer, toFile: path) {
            print("Warning: Timer could not be archived to the disk.")
          }
        } catch let error as NSError {
          print("Timer not writen: \(error.localizedDescription)")
        }
      }
    }
  }

  func readCurrentTimer() -> Timer? {
    var timer: Timer? = .None
    
    let fileManager = NSFileManager.defaultManager()
    
    if let path = savedTimer.path {
      if fileManager.fileExistsAtPath(path) {
        let readTimer = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
        if let readTimer = readTimer as? Timer {
          timer = readTimer
        }
      }
    }
    return timer
  }
  
  func restoreAnySavedTimer() {
    if let restoredTimer = readCurrentTimer() {
      timer = restoredTimer
    }
  }

}

// MARK: Additional

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
    setAllowDeviceToSleepDisplayForTimer(timer)
  }
  
  func setAllowDeviceToSleepDisplayForTimer(timer: Timer) {
    writeCurrentTimer()

    switch timer.state {
    
    case .Ready,
         .Paused,
         .PausedAfterComplete:
      allowDeviceToSleepDisplay = true
      
    case .Counting,
         .CountingAfterComplete:
      allowDeviceToSleepDisplay = false
    }

  }

  func resetTimerIfShowTimeIsZero() {
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


