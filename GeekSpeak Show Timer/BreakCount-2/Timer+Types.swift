import UIKit

// TODO: Refactor and abstract out the following hard coded time.
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
    
    var formatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.minimumIntegerDigits  = 2
      formatter.maximumIntegerDigits  = 2
      formatter.minimumFractionDigits = 0
      formatter.maximumFractionDigits = 0
      formatter.negativePrefix = ""
      return formatter
      }()
    
    var totalShowTimeElapsed: TimeInterval {
      return timeElapsed.totalShowTime
    }
    var totalShowTimeRemaining: TimeInterval {
      return durations.totalShowTime - timeElapsed.totalShowTime
    }
    
    var elapsed: TimeInterval {
      get {
        switch phase {
        case .PreShow:  return timeElapsed.preShow
        case .Section1: return timeElapsed.section1
        case .Break1:   return timeElapsed.break1
        case .Section2: return timeElapsed.section2
        case .PostShow: return timeElapsed.postShow
        }
      }
      set(newElapsed) {
        switch phase {
        case .PreShow:  timeElapsed.preShow  = newElapsed
        case .Section1: timeElapsed.section1 = newElapsed
        case .Break1:   timeElapsed.break1   = newElapsed
        case .Section2: timeElapsed.section2 = newElapsed
        case .PostShow: timeElapsed.postShow = newElapsed
        }
      }
    }
    
    var duration: TimeInterval {
      get {
        switch phase {
        case .PreShow:  return durations.preShow
        case .Section1: return durations.section1
        case .Break1:   return durations.break1
        case .Section2: return durations.section2
        case .PostShow: return TimeInterval(0.0)
        }
      }
      set(newDuration) {
        switch phase {
        case .PreShow:  durations.preShow  = newDuration
        case .Section1: durations.section1 = newDuration
        case .Break1:   durations.break1   = newDuration
        case .Section2: durations.section2 = newDuration
        case .PostShow: break
        }
      }
    }
    
    var remaining: TimeInterval {
      return max(duration - elapsed, 0)
    }
    
    @discardableResult mutating func incrementPhase() -> ShowPhase {
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
        phase = .PostShow
      case .PostShow:
        break
      }
      return phase
    }
    
    func asString(_ interval: TimeInterval) -> String {
      let roundedInterval = Int(interval)
      let seconds         = roundedInterval % 60
      let minutes         = (roundedInterval / 60) % 60
      let intervalNumber  = NSNumber(value: interval * TimeInterval(100))
      let subSeconds = formatter.string(from: intervalNumber)!
      return String(format: "%02d:%02d:\(subSeconds)",  minutes, seconds)
    }
    
    func asShortString(_ interval: TimeInterval) -> String {
      let roundedInterval = Int(interval)
      let seconds = roundedInterval % 60
      let minutes = (roundedInterval / 60) % 60
      return String(format: "%02d:%02d",  minutes, seconds)
    }
    
    
  }
  
  

  // Durations
  struct Durations {
    var preShow:           TimeInterval = 0
    var section1:          TimeInterval = 0
    var break1:            TimeInterval = 0
    var section2:          TimeInterval = 0

    /**
     Setup struct with timer durations
     
     - returns: Timer Duractions Struct
     
     -note: Until a real preferences mechenism is built for the
     
     Lyle: The Pledge Drive Durations are currently active.
           Remember to switch them back to the standard "useGeekSpeakDurations()"
     
     */
    init() {
      useKBCZDurations()
    }
    
    var totalShowTime: TimeInterval {
      return section1 + section2
    }
    
    func advancePhaseOnCompletion(_ phase: ShowPhase) -> Bool {
      switch phase {
      case .PreShow,
           .Section2,
           .Break1:
        return true
      case .Section1,
           .PostShow:
        return false
      }
    }

    
    mutating func useDemoDurations() {
      preShow  =  2.0
      section1 = 30.0
      break1   =  2.0
      section2 = 30.0
    }

    /**
     The current timings used for GeekSpeak after KUSP changed format (57 minutes)
     */
    mutating func useKBCZDurations() {
      preShow  =  1.0 * oneMinute
      section1 = 29.5 * oneMinute
      break1   =  1.0 * oneMinute
      section2 = 29.5 * oneMinute
    }

  }
  
  
  // TimeElapsed
  struct TimeElapsed {
    var preShow:  TimeInterval = 0.0
    var section1: TimeInterval = 0.0
    var break1:   TimeInterval = 0.0
    var section2: TimeInterval = 0.0
    var postShow: TimeInterval = 0.0

    var totalShowTime: TimeInterval {
      return section1 + section2
    }
  }
  
  
} // Timer Extention
