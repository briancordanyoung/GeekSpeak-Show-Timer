import UIKit

class SplitViewController: UISplitViewController {
  
  
  override func viewDidLoad() {
    preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay
  }
  
  // http://stackoverflow.com/questions/26633172/sizing-class-for-ipad-portrait-and-landscape-modes/28268200#28268200
  override func overrideTraitCollectionForChildViewController(childViewController: UIViewController) -> UITraitCollection! {
    if view.bounds.width < view.bounds.height {
      return UITraitCollection(horizontalSizeClass: .Compact)
    } else {
      return UITraitCollection(horizontalSizeClass: .Regular)
    }
  }

}


extension UISplitViewController {
  func toggleMasterView() {
    let barButtonItem = self.displayModeButtonItem()
    UIApplication.sharedApplication().sendAction(barButtonItem.action, to: barButtonItem.target, from: nil, forEvent: nil)
  }
}
