import UIKit

class SplitViewController: UISplitViewController,
                           UISplitViewControllerDelegate {

  
  struct Constants {
    static let TimerId              = "timerViewControllerTimerId"
    static let TimerNotificationKey = "com.geekspeak.timerNotificationKey"
    static let TimerDataPath        = "TimerData.plist"
  }
  
  
  var timer = Timer()
  
  override func viewDidLoad() {
    
    // When on and iPad, we don't want the master view (settings) to force
    // the detail views over.  We want the master to sit on top of the detail.
    // This can only happen on iPads.  So, on iPads, set the displayMode to
    // primaryOverlay.
    // TODO: Test on iPad air 2 with multi tasking (multi apps in view
    // TODO: iPhone 6 plus behavious is not worked out.
    switch Device() {
      case .iPad2,
           .iPad3,
           .iPad4,
           .iPadAir,
           .iPadAir2,
           .iPadMini,
           .iPadMini2,
           .iPadMini3:
          preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay
      default:
      break
    }
    self.delegate = self
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

