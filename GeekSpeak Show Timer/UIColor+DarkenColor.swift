import UIKit


extension UIColor {
  
  func darkenColorWithMultiplier(_ mult: CGFloat) -> UIColor {
    let rgba = cgColor.components
    
    let r = (rgba?[0])! * mult
    let g = (rgba?[1])! * mult
    let b = (rgba?[2])! * mult
    let a = rgba?[3]
    
    return UIColor(red: r, green: g, blue: b, alpha: a!)
  }
}
