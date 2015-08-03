import UIKit

class SplitViewController: UISplitViewController {
  
  
  override func viewDidLoad() {
    preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay
  }
  
  
}


extension UISplitViewController {
  func toggleMasterView() {
    let barButtonItem = self.displayModeButtonItem()
    UIApplication.sharedApplication().sendAction(barButtonItem.action, to: barButtonItem.target, from: nil, forEvent: nil)
  }
}
