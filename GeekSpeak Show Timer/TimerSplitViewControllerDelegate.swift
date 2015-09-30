import UIKit

class TimerSplitViewControllerDelegate: NSObject, UISplitViewControllerDelegate {
  
  

  // MARK: Manage SplitViewContoller preferedDisplayMode
  // Do preferredDisplayMode to delegate methods collaps and expand methods
//  func setDisplayMode(svc: UISplitViewController) {
//    if svc.collapsed {
////      svc.preferredDisplayMode = .Automatic
//      println("collapsed: \(svc.preferredDisplayMode == .Automatic)")
//    } else {
////      svc.preferredDisplayMode = .PrimaryOverlay
//      println("not collapsed: \(svc.preferredDisplayMode == .Automatic)")
//    }
//  }
  
    func splitViewController(svc: UISplitViewController,
          willChangeToDisplayMode displayMode: UISplitViewControllerDisplayMode) {
      print("willChangeToDisplayMode")
    }
  
  // MARK: Manage SplitViewContoller preferedDisplayMode
  func targetDisplayModeForActionInSplitViewController(svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
    switch svc.displayMode  {
    case .Automatic:
      print("DisplayMode: Automatic SHOULD NOT EVER BE TRUE")
    case .PrimaryOverlay:
      print("DisplayMode: PrimaryOverlay")
    case .PrimaryHidden:
      print("DisplayMode: PrimaryHidden")
    case .AllVisible:
      print("DisplayMode: AllVisible")
    }

    return .PrimaryOverlay
  }
  
  
  
  func primaryViewControllerForCollapsingSplitViewController(
              splitViewController: UISplitViewController) -> UIViewController? {
    print("primaryViewControllerForCollapsingSplitViewController")
    splitViewController.preferredDisplayMode = .PrimaryOverlay
    return .None
  }
  
//  func primaryViewControllerForExpandingSplitViewController(splitViewController: UISplitViewController) -> UIViewController? {
//    if splitViewController.viewControllers.count >= 2 {
//      return splitViewController.viewControllers[1] as? UIViewController
//    } else {
//      return splitViewController.viewControllers[0] as? UIViewController
//    }
//  }
  
  
//  func splitViewController(splitViewController: UISplitViewController,
//    separateSecondaryViewControllerFromPrimaryViewController
//                                    primaryViewController: UIViewController!) ->
//                                                             UIViewController? {
//    
//  }
  
  
  
  
  
  
//  
//  func splitViewController(splitViewController: UISplitViewController,
//          showViewController vc: UIViewController, sender: AnyObject?) -> Bool {
//    return false
//  }
//  
//  
//  func splitViewController(splitViewController: UISplitViewController, showDetailViewController vc: UIViewController, sender: AnyObject?) -> Bool {
//    return false
//  }
  
  
  // Make sure the Settings View (Primary view) is displayed on startup
  // http://stackoverflow.com/questions/25875618/uisplitviewcontroller-in-portrait-on-iphone-shows-detail-vc-instead-of-master
  func splitViewController(splitViewController: UISplitViewController,
    collapseSecondaryViewController secondaryViewController: UIViewController,
    ontoPrimaryViewController primaryViewController: UIViewController)
    -> Bool {
      return true
  }
  
  
  func splitViewControllerSupportedInterfaceOrientations(
     splitViewController: UISplitViewController) -> UIInterfaceOrientationMask {

    return UIInterfaceOrientationMask.All
  }
  
  //  func splitViewControllerPreferredInterfaceOrientationForPresentation(
  //                                    splitViewController: UISplitViewController)
  //                                                    -> UIInterfaceOrientation {
  //
  //  }
  

  
  
  
  

}
