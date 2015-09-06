import UIKit

typealias SizableBezierPathFunc = (CGSize) -> UIBezierPath


class SizableBezierPath {
  var size = CGSize(width: 100, height: 100)
  
  var path: UIBezierPath {
    return pathForSize(size)
  }
  
  var pathForSize: (CGSize) -> UIBezierPath = {size in
    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    return UIBezierPath(rect: rect)
  }
}