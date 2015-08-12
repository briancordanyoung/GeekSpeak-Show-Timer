import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate, TimerDelegate {
  
  var timer = Timer()
  var useDemoDurations = false
  
  func updateUseDemoDurations() {
    useDemoDurations = NSUserDefaults .standardUserDefaults()
                                  .boolForKey(Timer.Constants.UseDemoDurations)
  }

  override func viewDidLoad() {
    preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay
    self.delegate = self
    timer.delegate = self
    resetTimer()
    
    if temporaryTimerDateExists {
      decodeTimerFromDisk()
    }
  }
  
  // http://stackoverflow.com/questions/26633172/sizing-class-for-ipad-portrait-and-landscape-modes/28268200#28268200
  override func overrideTraitCollectionForChildViewController(childViewController: UIViewController) -> UITraitCollection! {
    if view.bounds.width < view.bounds.height {
      return UITraitCollection(horizontalSizeClass: .Compact)
    } else {
      return UITraitCollection(horizontalSizeClass: .Regular)
    }
  }
  
  // Make sure the Settings View is displayed on startup
  // http://stackoverflow.com/questions/25875618/uisplitviewcontroller-in-portrait-on-iphone-shows-detail-vc-instead-of-master
  func splitViewController(splitViewController: UISplitViewController,
    collapseSecondaryViewController secondaryViewController: UIViewController!,
            ontoPrimaryViewController primaryViewController: UIViewController!)
                                                                      -> Bool {
    return true
  }
  
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



  struct Constants {
    static let TimerId              = "timerViewControllerTimerId"
    static let TimerNotificationKey = "com.geekspeak.timerNotificationKey"
    static let TimerDataPath        = "TimerDataArchive.plist"
  }
  
  
  var timerViewController: TimerViewController? {
    var timerViewController: TimerViewController? = .None
    if let navController: AnyObject? = viewControllers.last {
        if let navController = navController as? UINavigationController {
          if let tmpTimerViewController =
            navController.topViewController as? TimerViewController {
              timerViewController = tmpTimerViewController
          }
       }
    }
    return timerViewController
  }
  
  // MARK: Actions
  func resetTimer() {
    updateUseDemoDurations()
    if useDemoDurations {
      timer.reset(usingDemoTiming: true)
    } else {
      timer.reset()
    }
  }


  // MARK: -
  // MARK: Timer callback funtions
  //       Most passed on to TimerViewController
  func timerChangedCountingStatus(state: Timer.CountingState) {
    timerViewController?.timerChangedCountingStatus(state)
  }
  
  func timerDurationChanged(timer: Timer?) {
//    let section2Seconds: NSTimeInterval
//    let section3Seconds: NSTimeInterval
//    if useDemoDurations {
//      section2Seconds = 2
//      section3Seconds = 1
//    } else {
//      section2Seconds = 120
//      section3Seconds = 30
//    }
//    
//    
//    if let timer = timer {
//      switch timer.timing.phase {
//      case .Section3:
//        let twoMinuteWarning = timer.percentageFromSecondsToEnd(section2Seconds)
//        let sectionColor2   = RingView.sectionColor( Constants.WarningColor,
//          atPercentage: twoMinuteWarning)
//        timerViews?.ring3fg.additionalColors.append(sectionColor2)
//        
//        let halfMinuteWarning = timer.percentageFromSecondsToEnd(section3Seconds)
//        let sectionColor3   = RingView.sectionColor( Constants.AlarmColor,
//          atPercentage: halfMinuteWarning)
//        timerViews?.ring3fg.additionalColors.append(sectionColor3)
//      default:
//        break
//      }
//    }
  }
  
  func timerUpdatedTime(timer: Timer?) {
    timerViewController?.timerUpdatedTime(timer)
    NSNotificationCenter.defaultCenter()
      .postNotificationName( Constants.TimerNotificationKey,
        object: nil)
      
  }
  
  
  // MARK: -
  // MARK: State Preservation and Restoration
  enum DecodedResult {
    case Decoded
    case FailedToDecode
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    if decodeTimerViewController(coder: aDecoder) == .FailedToDecode {
    }
  }
  
  override func encodeWithCoder(aCoder: NSCoder) {
    super.encodeWithCoder(aCoder)
    aCoder.encodeObject(timer, forKey: Constants.TimerId)
  }
  
  override func encodeRestorableStateWithCoder(coder: NSCoder) {
    super.encodeRestorableStateWithCoder(coder)
    coder.encodeObject(timer, forKey: Constants.TimerId)
    removeTemporaryTimerData()
  }
  
  override func decodeRestorableStateWithCoder(coder: NSCoder) {
    decodeTimerViewController(coder: coder)
  }
  
  func decodeTimerViewController(coder aDecoer: NSCoder) -> DecodedResult {
    if let decodedTimer = aDecoer.decodeObjectForKey(Constants.TimerId) as? Timer {
      restoreDecodedTimer(decodedTimer)
      return .Decoded
    } else {
      return .FailedToDecode
    }
  }
  
  func restoreDecodedTimer(decodedTimer: Timer) {
    timer = decodedTimer
    timer.delegate = self
    timerChangedCountingStatus(timer.state)
    timer.incrementTimer()
  }
  
  func encodeTimerToDisk() {
    removeTemporaryTimerData()
    NSKeyedArchiver.archiveRootObject( timer, toFile: temporaryTimerDataPath)
  }
  
  func decodeTimerFromDisk() {
    if let decodedTimer =
      NSKeyedUnarchiver.unarchiveObjectWithFile(temporaryTimerDataPath)
        as? Timer {
          restoreDecodedTimer(decodedTimer)
          if temporaryTimerDateExists {
            removeTemporaryTimerData()
          }
    }
    
  }
  
  var temporaryTimerDataPath: String {
    return NSTemporaryDirectory() + Constants.TimerDataPath
  }
  
  var temporaryTimerDateExists: Bool {
    return NSFileManager.defaultManager()
      .fileExistsAtPath(temporaryTimerDataPath)
  }
  
  func removeTemporaryTimerData() {
    var error: NSError?
    NSFileManager.defaultManager().removeItemAtPath( temporaryTimerDataPath,
      error: &error)
    if let error = error {
      NSLog("Error removing tmp Timer Data: " + error.description)
    }
  }

