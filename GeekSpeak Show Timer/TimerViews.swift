import UIKit

struct TimerViews {
  let ring1bg: RingView
  let ring1fg: RingView
  let ring2bg: RingView
  let ring2fg: RingView
  let ring3bg: RingView
  let ring3fg: RingView
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

