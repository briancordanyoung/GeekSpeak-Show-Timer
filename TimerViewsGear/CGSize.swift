import Foundation

extension CGSize {
  var maxLeg: CGFloat {
    return max(self.width,self.height)
  }
}
