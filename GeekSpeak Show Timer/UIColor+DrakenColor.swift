import UIKit


extension UIColor {
  
  func darkenColorWithMultiplier(mult: CGFloat) -> UIColor {
    let rgba = CGColorGetComponents(CGColor)
    
    let r = rgba[0] * mult
    let g = rgba[1] * mult
    let b = rgba[2] * mult
    let a = rgba[3]
    
    return UIColor(red: r, green: b, blue: b, alpha: a)
  }
}