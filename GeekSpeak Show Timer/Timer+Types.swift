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
    var preShow:           NSTimeInterval =  1.0 * oneMinute
    var section1:          NSTimeInterval = 14.0 * oneMinute
    var break1:            NSTimeInterval =  1.0 * oneMinute
    var section2:          NSTimeInterval = 18.0 * oneMinute
    var break2:            NSTimeInterval =  1.0 * oneMinute
    var section3:          NSTimeInterval = 19.0 * oneMinute

//    var preShow:           NSTimeInterval = 20.0
//    var section1:          NSTimeInterval = 10.0
//    var break1:            NSTimeInterval =  5.0
//    var section2:          NSTimeInterval = 10.0
//    var break2:            NSTimeInterval =  5.0
//    var section3:          NSTimeInterval = 10.0
    
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

    var totalShowTime: NSTimeInterval {
      return section1 + section2 + section3
    }
}
  
  
  
  struct ShowTiming {
    
    var durations   = Durations()
    var timeElapsed = TimeElapsed()
    var phase       = ShowPhase.PreShow

    var formatter: NSNumberFormatter = {
      let formatter = NSNumberFormatter()
      formatter.minimumIntegerDigits  = 2
      formatter.maximumIntegerDigits  = 2
      formatter.minimumFractionDigits = 0
      formatter.maximumFractionDigits = 0
      formatter.negativePrefix = ""
      return formatter
    }()

    var totalShowTimeElapsed: NSTimeInterval {
      return timeElapsed.totalShowTime
    }
    var totalShowTimeRemaining: NSTimeInterval {
      return durations.totalShowTime - timeElapsed.totalShowTime
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
        // Before moving to the next phase of the show,
        // get the difference between the planned duration and the elapsed time
        // and add that to the next show section.
        let difference = duration - elapsed
        durations.section1 -= difference
        durations.section2 += difference
        phase = .Break1
      case .Break1:
        phase = .Section2
      case .Section2:
        // Before moving to the next phase of the show,
        // get the difference between the planned duration and the elapsed time
        // and add that to the next show section.
        let difference = duration - elapsed
        durations.section2 -= difference
        durations.section3 += difference
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
    
    func asString(interval: NSTimeInterval) -> String {
      let roundedInterval = Int(interval)
      let seconds = roundedInterval % 60
      let minutes = (roundedInterval / 60) % 60
      let hours   = (roundedInterval / 3600)
      let subSeconds = formatter.stringFromNumber(interval * 100)!
      return String(format: "%02d:%02d:\(subSeconds)",  minutes, seconds)
    }

    
    
  } // ShowTiming
} // Timer Extention