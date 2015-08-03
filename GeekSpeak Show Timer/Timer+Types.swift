import UIKit

extension Timer {
  
  // MARK: - Enums
  enum CountingState: String, Printable {
    case Ready          = "Ready"
    case Counting       = "Counting"
    case Paused         = "Paused"
    
    var description: String {
      return self.rawValue
    }
  }

  enum ShowPhase: String, Printable {
    case PreShow  = "PreShow"
    case Section1 = "Section1"
    case Break1   = "Break1"
    case Section2 = "Section2"
    case Break2   = "Break2"
    case Section3 = "Section3"
    case PostShow = "PostShow"
    
    var description: String {
      return self.rawValue
    }
  }
  
  struct Durations {
    var preShow:           NSTimeInterval =  5.0 * oneMinute
    var section1:          NSTimeInterval = 17.0 * oneMinute
    var break1:            NSTimeInterval =  1.0 * oneMinute
    var section2:          NSTimeInterval = 17.0 * oneMinute
    var break2:            NSTimeInterval =  1.0 * oneMinute
    var section3:          NSTimeInterval = 17.0 * oneMinute
    
    var totalShowTime: NSTimeInterval {
      return section1 + section2 + section3
    }
    
  }
  
  struct TimeElapsed {
    var preShow:  NSTimeInterval = 0.0
    var section1: NSTimeInterval = 0.0
    var break1:   NSTimeInterval = 0.0
    var section2: NSTimeInterval = 0.0
    var break2:   NSTimeInterval = 0.0
    var section3: NSTimeInterval = 0.0
    var postShow: NSTimeInterval = 0.0
  }
  
  
  
  struct ShowTiming {
    
    var durations   = Durations()
    var timeElapsed = TimeElapsed()
    var phase       = ShowPhase.PreShow
    
    var totalShowTimeElapsed: NSTimeInterval {
      return timeElapsed.section1 + timeElapsed.section2 + timeElapsed.section3
    }
    var totalShowTimeRemaining: NSTimeInterval {
      return durations.totalShowTime - totalShowTimeElapsed
    }
    
    var elapsed: NSTimeInterval {
      get {
        switch phase {
        case .PreShow:
          return timeElapsed.preShow
        case .Section1:
          return timeElapsed.section1
        case .Break1:
          return timeElapsed.break1
        case .Section2:
          return timeElapsed.section2
        case .Break2:
          return timeElapsed.break2
        case .Section3:
          return timeElapsed.section3
        case .PostShow:
          return timeElapsed.postShow
        }
      }
      set(newElapsed) {
        switch phase {
        case .PreShow:
          timeElapsed.preShow  = newElapsed
        case .Section1:
          timeElapsed.section1 = newElapsed
        case .Break1:
          timeElapsed.break1   = newElapsed
        case .Section2:
          timeElapsed.section2 = newElapsed
        case .Break2:
          timeElapsed.break2   = newElapsed
        case .Section3:
          timeElapsed.section3 = newElapsed
        case .PostShow:
          timeElapsed.postShow = newElapsed
        }
      }
    }
    
    var duration: NSTimeInterval {
      get {
        switch phase {
        case .PreShow:
          return durations.preShow
        case .Section1:
          return durations.section1
        case .Break1:
          return durations.break1
        case .Section2:
          return durations.section2
        case .Break2:
          return durations.break2
        case .Section3:
          return durations.section3
        case .PostShow:
          return NSTimeInterval(0.0)
        }
      }
      set(newDuration) {
        switch phase {
        case .PreShow:
          durations.preShow  = newDuration
        case .Section1:
          durations.section1 = newDuration
        case .Break1:
          durations.break1   = newDuration
        case .Section2:
          durations.section2 = newDuration
        case .Break2:
          durations.break2   = newDuration
        case .Section3:
          durations.section3 = newDuration
        case .PostShow:
          break
        }
      }
    }
    
    var remaining: NSTimeInterval {
      return max(duration - elapsed, 0)
    }
    
    mutating func incrementPhase() -> ShowPhase {
      switch phase {
      case .PreShow:
        phase = .Section1
      case .Section1:
        phase = .Break1
      case .Break1:
        phase = .Section2
      case .Section2:
        phase = .Break2
      case .Break2:
        phase = .Section3
      case .Section3:
        phase = .PostShow
      case .PostShow:
        break
      }
      return phase
    }
    
    
  } // ShowTiming
} // Timer Extention