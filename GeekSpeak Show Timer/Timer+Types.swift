import UIKit

// TODO: Refaction and abstract out the following hard coded time.
//       These structs and enums were a quick and dirty way to get the
//       Timer up and running.  This should be abstrated out and use
//       some sort of configuration file that allows the timer to have
//       user definded Phases, Durations, soft and hard segment times and 
//       break times.


extension Timer {
  
  
  // MARK: - Enums
  enum CountingState: String, CustomStringConvertible {
    case Ready                 = "Ready"
    case Counting              = "Counting"
    case Paused                = "Paused"
    case PausedAfterComplete   = "PausedAfterComplete"
    case CountingAfterComplete = "CountingAfterComplete"
    
    var description: String {
      return self.rawValue
    }
  }

  enum ShowPhase: String, CustomStringConvertible {
    case PreShow  = "PreShow"
    case Section1 = "Section1"
    case Break1   = "Break1"
    case Section2 = "Section2"
    case Break2   = "Break2"
    case Section3 = "Section3"
    case Break3   = "Break3"
    case Section4 = "Section4"
    case PostShow = "PostShow"
    
    var description: String {
      return self.rawValue
    }
  }
  
  
  // ShowTiming
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
        case .Break3:
          return timeElapsed.break3
        case .Section4:
          return timeElapsed.section4
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
        case .Break3:
          timeElapsed.break3   = newElapsed
        case .Section4:
          timeElapsed.section4 = newElapsed
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
        case .Break3:
          return durations.break3
        case .Section4:
          return durations.section4
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
        case .Break3:
          durations.break3   = newDuration
        case .Section4:
          durations.section4 = newDuration
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
        // Before moving to the next phase of the show,
        // get the difference between the planned duration and the elapsed time
        // and add that to the next show section.
        let difference = duration - elapsed
        durations.section3 -= difference
        durations.section4 += difference
        phase = .Break3
      case .Break3:
        phase = .Section4
      case .Section4:
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
//      let hours   = (roundedInterval / 3600)
      let subSeconds = formatter.stringFromNumber(interval * 100)!
      return String(format: "%02d:%02d:\(subSeconds)",  minutes, seconds)
    }
    
    func asShortString(interval: NSTimeInterval) -> String {
      let roundedInterval = Int(interval)
      let seconds = roundedInterval % 60
      let minutes = (roundedInterval / 60) % 60
//      let hours   = (roundedInterval / 3600)
      return String(format: "%02d:%02d",  minutes, seconds)
    }
    
    
  }
  
  

  // Durations
  struct Durations {
    var preShow:           NSTimeInterval = 0
    var section1:          NSTimeInterval = 0
    var break1:            NSTimeInterval = 0
    var section2:          NSTimeInterval = 0
    var break2:            NSTimeInterval = 0
    var section3:          NSTimeInterval = 0
    var break3:            NSTimeInterval = 0
    var section4:          NSTimeInterval = 0

    init() {
      useGeekSpeakDurations()
    }
    
    var totalShowTime: NSTimeInterval {
      return section1 + section2 + section3  + section4
    }
    
    func advancePhaseOnCompletion(phase: ShowPhase) -> Bool {
      switch phase {
      case .PreShow,
           .Break1,
           .Break2,
           .Break3,
           .Section4:
        return true
      case .Section1,
           .Section2,
           .Section3,
           .PostShow:
        return false
      }
    }

    
    mutating func useDemoDurations() {
      preShow  =  5.0
      section1 = 10.0
      break1   =  5.0
      section2 = 10.0
      break2   =  5.0
      section3 = 10.0
      break3   =  5.0
      section4 = 10.0
    }
    
    mutating func useGeekSpeakDurations() {
      preShow  =  1.0 * oneMinute
      section1 =  8.0 * oneMinute
      break1   =  1.0 * oneMinute
      section2 =  8.0 * oneMinute
      break2   =  1.0 * oneMinute
      section3 = 10.0 * oneMinute
      break3   =  1.0 * oneMinute
      section4 = 11.0 * oneMinute
    }

  }
  
  
  // TimeElapsed
  struct TimeElapsed {
    var preShow:  NSTimeInterval = 0.0
    var section1: NSTimeInterval = 0.0
    var break1:   NSTimeInterval = 0.0
    var section2: NSTimeInterval = 0.0
    var break2:   NSTimeInterval = 0.0
    var section3: NSTimeInterval = 0.0
    var break3:   NSTimeInterval = 0.0
    var section4: NSTimeInterval = 0.0
    var postShow: NSTimeInterval = 0.0

    var totalShowTime: NSTimeInterval {
      return section1 + section2 + section3 + section4
    }
  }
  
  
} // Timer Extention