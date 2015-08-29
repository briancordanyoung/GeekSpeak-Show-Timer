import UIKit

class Appearance {
  class func apply() {
    UIApplication.sharedApplication().setStatusBarStyle( .LightContent,
                                               animated: false)
    
    UINavigationBar.appearance().backgroundColor = UIColor.blackColor()
    UINavigationBar.appearance().translucent     = false
    UINavigationBar
      .appearance()
      .setBackgroundImage( UIImage.imageWithColor( UIColor.blackColor()),
            forBarMetrics: UIBarMetrics.Default)
    
    UINavigationBar.appearance().barStyle = .Black
  }
  
  class func appearanceForNavigationController(
                                navigationController: UINavigationController) {
    self.appearanceForNavigationController( navigationController,
                               transparent: false)
  }
  
  class func appearanceForNavigationController(
                                navigationController: UINavigationController,
                                transparent: Bool) {
    navigationController.navigationBar.backgroundColor = UIColor.clearColor()
    navigationController.navigationBar.setBackgroundImage( UIImage(),
                                            forBarMetrics: UIBarMetrics.Default)
  }
}
