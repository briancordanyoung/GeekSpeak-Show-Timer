import UIKit

public struct TimerViews {
  public let ring1bg:   RingView
  public let ring1fg:   RingView
  public let ring2bg:   RingView
  public let ring2fg:   RingView
  public let ring3bg:   RingView
  public let ring3fg:   RingView
  public let breakView: BreakView
  
  public init(ring1bg: RingView,
              ring1fg: RingView,
              ring2bg: RingView,
              ring2fg: RingView,
              ring3bg: RingView,
              ring3fg: RingView,
            breakView: BreakView) {
    self.ring1bg = ring1bg
    self.ring1fg = ring1fg
    self.ring2bg = ring2bg
    self.ring2fg = ring2fg
    self.ring3bg = ring3bg
    self.ring3fg = ring3fg
    self.breakView = breakView
  }
  
}

