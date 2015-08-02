import UIKit

class PartialRingView: PieShapeView {
  let ringMask = RingView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupRingMask()
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupRingMask()
  }
  
  func setupRingMask() {
    maskView = ringMask
    ringMask.opaque = false
  }
  
  func updateMaskFrame() {
    updateMaskSize(frame.size)
  }

  func updateMaskSize(maskSize: CGSize) {
    var maskFrame = CGRect()
    maskFrame.size = maskSize
    ringMask.frame = maskFrame
  }
  
}
