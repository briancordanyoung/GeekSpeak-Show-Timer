import UIKit

struct TimerViews {
  let ring1bg: RingView
  let ring1fg: PartialRingView
  let ring2bg: RingView
  let ring2fg: PartialRingView
  let ring3bg: RingView
  let ring3fg: PartialRingView
  let fill:    PieShapeView
  
  
  func layoutSubviewsWithLineWidth(lineWidth: CGFloat) {
    ring1fg.updateMaskFrame()
    ring2fg.updateMaskFrame()
    ring3fg.updateMaskFrame()
    ring1fg.ringMask.lineWidth = lineWidth
    ring2fg.ringMask.lineWidth = lineWidth
    ring3fg.ringMask.lineWidth = lineWidth
    ring1bg.lineWidth = lineWidth
    ring2bg.lineWidth = lineWidth
    ring3bg.lineWidth = lineWidth
    ring1bg.lineWidth = lineWidth
    ring2bg.lineWidth = lineWidth
    ring3bg.lineWidth = lineWidth
  }
  
  func layoutSubviewsWithLineWidth(lineWidth: CGFloat, andSize size: CGSize) {
    let lineWidth = TimerViewController.lineWidthForSize(size)
    ring1fg.updateMaskSize(size)
    ring2fg.updateMaskSize(size)
    ring3fg.updateMaskSize(size)
    ring1fg.ringMask.lineWidth = lineWidth
    ring2fg.ringMask.lineWidth = lineWidth
    ring3fg.ringMask.lineWidth = lineWidth
    ring1bg.lineWidth = lineWidth
    ring2bg.lineWidth = lineWidth
    ring3bg.lineWidth = lineWidth
    ring1bg.lineWidth = lineWidth
    ring2bg.lineWidth = lineWidth
    ring3bg.lineWidth = lineWidth
  }
  
}

