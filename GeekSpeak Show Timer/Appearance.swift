import UIKit

class Appearance {
  
  struct Constants {
    static let GeekSpeakBlueColor = UIColor(red: 14/255,
                                          green: 115/255,
                                           blue: 192/255,
                                          alpha: 1.0)
    
    static let GeekSpeakBlueInactiveColor = UIColor(red: 14/255,
                                                  green: 115/255,
                                                   blue: 115/255,
                                                  alpha: 0.2)
    
    static let BreakColor         = UIColor(red: 0.75,
                                          green: 0.0,
                                           blue: 0.0,
                                          alpha: 1.0)
    
    static let WarningColor       = UIColor(red: 23/255,
                                          green: 157/255,
                                           blue: 172/255,
                                          alpha: 1.0)
    
    static let AlarmColor         = UIColor(red: 30/255,
                                          green: 226/255,
                                           blue: 166/255,
                                          alpha: 1.0)
    
    static let RingWidth              = CGFloat(0.257)
    static let RingDarkeningFactor    = CGFloat(1.0)
  }

  
  class func apply() {
    UIButton.appearance().tintColor = Constants.GeekSpeakBlueColor
  }
}
