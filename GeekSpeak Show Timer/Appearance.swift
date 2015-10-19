import UIKit

class Appearance {
  class func apply() {
    UIApplication.sharedApplication().setStatusBarStyle( .LightContent,
                                                                animated: false)
    
    UIButton.appearance().tintColor = TimerViewController.Constants
                                                             .GeekSpeakBlueColor
  }
}
