import UIKit

class Appearance {
  class func apply() {
    UIApplication.sharedApplication().setStatusBarStyle( .LightContent,
                                               animated: false)
  }
}
