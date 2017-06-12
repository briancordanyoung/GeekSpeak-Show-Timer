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
  fileprivate var _timer: Timer?
  
  // Convenience property to make intentions clear what is gonig on.
  var allowDeviceToSleepDisplay: Bool {
    get {
      return !UIApplication.shared.isIdleTimerDisabled
    }
    set(allowed) {
      UIApplication.shared.isIdleTimerDisabled = !allowed
    }
  }
  
  
  // MARK: App Delegate
  func application(_ application: UIApplication,
       didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
                                                                       -> Bool {
    registerUserDefaults()
    Appearance.apply()
    resetTimerIfShowTimeIsZero()
    registerForTimerNotifications()
    return true
  }



  func application(_ application: UIApplication,
          willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
                                                                       -> Bool {
    self.window?.makeKeyAndVisible()
    return true
  }
  

  
  func applicationWillEnterForeground(_ application: UIApplication) {
    resetTimerIfShowTimeIsZero()
//    setAllowDeviceToSleepDisplayForTimer(timer)
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    timerChangedCountingStatus()
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    writeCurrentTimer()
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    allowDeviceToSleepDisplay = true
  }

  func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    writeCurrentTimer()
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
  }
  
  func application(_ application: UIApplication, shouldSaveApplicationState
                         coder: NSCoder) -> Bool {
    unregisterForTimerNotifications()
    return true
  }

  func application(_ application: UIApplication, shouldRestoreApplicationState
                         coder: NSCoder) -> Bool {
    registerForTimerNotifications()
    return true
  }
  
  
  // MARK: -
  // MARK: Timer Persistance
  var applicationDocumentsDirectory: URL {
   return FileManager.default
                     .urls( for: .documentDirectory,
                             in: .userDomainMask)
                     .last!
  }
  
  var savedTimer: URL {
    return applicationDocumentsDirectory
                    .appendingPathComponent(Constants.CurrentTimerFileName)
  }
  
  func writeCurrentTimer() {
    writeCurrentTimer(timer)
  }
  
  func writeCurrentTimer(_ timer: Timer) {
    let name = savedTimer.lastPathComponent
    let directory = savedTimer.deletingLastPathComponent()
      
    let backupName = "\(name) Backup"
    let backupURL = directory.appendingPathComponent(backupName)

    let path = savedTimer.path
    let backupPath = backupURL.path
    let fileManager = FileManager.default

    do {
      if fileManager.fileExists(atPath: backupPath) {
        try fileManager.removeItem(atPath: backupPath)
      }
      if fileManager.fileExists(atPath: path) {
        try fileManager.moveItem(atPath: path, toPath: backupPath)
      }
      if !NSKeyedArchiver.archiveRootObject(timer, toFile: path) {
        print("Warning: Timer could not be archived to the disk.")
      }
    } catch let error as NSError {
      print("Timer not writen: \(error.localizedDescription)")
    }
  }

  func readCurrentTimer() -> Timer? {
    var timer: Timer? = .none
    
    let fileManager = FileManager.default
    
    let path = savedTimer.path
    if fileManager.fileExists(atPath: path) {
      let readTimer = NSKeyedUnarchiver.unarchiveObject(withFile: path)
      if let readTimer = readTimer as? Timer {
        timer = readTimer
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
    let notifyCenter = NotificationCenter.default
    notifyCenter.addObserver( self,
                    selector: #selector(AppDelegate.timerChangedCountingStatus),
                        name: NSNotification.Name(rawValue: Timer.Constants.CountingStatusChanged),
                      object: timer)

  }
  
  func unregisterForTimerNotifications() {
    let notifyCenter = NotificationCenter.default
    // TODO: When I explicitly remove each observer it throws an execption. why?
    //    notifyCenter.removeObserver( self,
    //                     forKeyPath: Timer.Constants.CountingStatusChanged)
    notifyCenter.removeObserver(self)
  }

  func timerChangedCountingStatus() {
    setAllowDeviceToSleepDisplayForTimer(timer)
  }
  
  func setAllowDeviceToSleepDisplayForTimer(_ timer: Timer) {
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
    let useDemoDurations = UserDefaults.standard
                                   .bool(forKey: Timer.Constants.UseDemoDurations)
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
      Timer.Constants.UseDemoDurations: useDebugTimings as AnyObject
    ]
    
    UserDefaults.standard.register(defaults: defaults)
  }

  
}


