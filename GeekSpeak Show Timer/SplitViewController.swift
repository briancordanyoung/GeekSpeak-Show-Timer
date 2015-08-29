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

