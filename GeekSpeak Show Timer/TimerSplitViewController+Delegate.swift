import UIKit

extension TimerSplitViewController: UISplitViewControllerDelegate {
  
  func splitViewController(svc: UISplitViewController,
        willChangeToDisplayMode displayMode: UISplitViewControllerDisplayMode) {
    // Maybe a good place to inject the timer class?
    println("splitViewController(_:willChangeToDisplayMode: \(displayMode)0")
  }
  
//  func targetDisplayModeForActionInSplitViewController(svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
//    
//  }
  
//  func splitViewControllerPreferredInterfaceOrientationForPresentation(
//                                    splitViewController: UISplitViewController)
//                                                    -> UIInterfaceOrientation {
//  
//  }
  
  func splitViewControllerSupportedInterfaceOrientations( splitViewController: UISplitViewController) -> Int {
    return Int(UIInterfaceOrientationMask.All.rawValue)
  }
  
  
//  func primaryViewControllerForCollapsingSplitViewController(splitViewController: UISplitViewController) -> UIViewController? {
//    
//  }
  
//  func primaryViewControllerForExpandingSplitViewController(splitViewController: UISplitViewController) -> UIViewController? {
//    
//  }
  
  
//  func splitViewController(splitViewController: UISplitViewController,
//    separateSecondaryViewControllerFromPrimaryViewController
//                                    primaryViewController: UIViewController!) ->
//                                                             UIViewController? {
//    
//  }
  
  func splitViewController(splitViewController: UISplitViewController,
          showViewController vc: UIViewController, sender: AnyObject?) -> Bool {
    return false
  }
  
  
  func splitViewController(splitViewController: UISplitViewController, showDetailViewController vc: UIViewController, sender: AnyObject?) -> Bool {
    return false
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
