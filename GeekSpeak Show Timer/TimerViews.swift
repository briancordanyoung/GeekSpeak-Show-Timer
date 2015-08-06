import UIKit

struct TimerViews {
  let ring1bg: PartialRingView
  let ring1fg: PartialRingView
  let ring2bg: PartialRingView
  let ring2fg: PartialRingView
  let ring3bg: PartialRingView
  let ring3fg: PartialRingView
  let fill:    PieShapeView
  
  
  func layoutSubviewsWithLineWidth(lineWidth: CGFloat) {
    ring1fg.ringWidth = lineWidth
    ring2fg.ringWidth = lineWidth
    ring3fg.ringWidth = lineWidth
    ring1bg.ringWidth = lineWidth
    ring2bg.ringWidth = lineWidth
    ring3bg.ringWidth = lineWidth
  }
  
  func layoutSubviewsWithLineWidth(lineWidth: CGFloat, andSize size: CGSize) {
    let lineWidth = TimerViewController.lineWidthForSize(size)
    layoutSubviewsWithLineWidth(lineWidth)
  }
  
}

