import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
  
  
  override func viewDidLoad() {
    preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay
    self.delegate = self
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
