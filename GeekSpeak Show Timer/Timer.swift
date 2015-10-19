import Foundation
import CoreGraphics


let oneMinute             = NSTimeInterval(60)
let timerUpdateInterval   = NSTimeInterval(0.01)

// MARK: -
// MARK: Timer class
final class Timer: NSObject, NSCoding {
  
  struct Constants {
    static let TimeChange            = "kGPTTimeChange"
    static let CountingStatusChanged = "kGPTCountingStatusChanged"
    static let DurationChanged       = "kGPTDurationChanged"

    static let UseDemoDurations    = "useDemoDurations"

    static let StateId             = "timerCountingStateId"
    static let PhaseId             = "timerShowTimingPhaseId"
    static let CountingStartTimeId = "timerCountingStartTimeId"
    
    struct Durations {
      static let PreShowId  = "timerShowTimingDurationPreShowId"
      static let Section1Id = "timerShowTimingDurationSection1Id"
      static let Section2Id = "timerShowTimingDurationSection2Id"
      static let Section3Id = "timerShowTimingDurationSection3Id"
      static let Break1Id   = "timerShowTimingDurationBreak1Id"
      static let Break2Id   = "timerShowTimingDurationBreak2Id"
    }
    
    struct ElapsedTime {
      static let PreShowId   = "timerShowTimingElapsedPreShowId"
      static let Section1Id  = "timerShowTimingElapsedSection1Id"
      static let Section2Id  = "timerShowTimingElapsedSection2Id"
      static let Section3Id  = "timerShowTimingElapsedSection3Id"
      static let Break1Id    = "timerShowTimingElapsedBreak1Id"
      static let Break2Id    = "timerShowTimingElapsedBreak2Id"
      static let PostShowId  = "timerShowTimingElapsedPostShowId"
    }
  }
  
  // MARK: Properties
  var countingStartTime: NSTimeInterval?
  var timing = ShowTiming()
  var demoTimings = false
  
  // MARK: Computed Properties
  var state: CountingState {
    get {
      return _state
    }
    set(newState) {
      changeCountingState(newState)
    }
  }
  
  var secondsElapsedAtPause: NSTimeInterval {
    get {
      return timing.elapsed
    }
    set(newElapsed) {
      timing.elapsed = newElapsed
    }
  }
  
  var duration: NSTimeInterval {
    get {
      return timing.duration
    }
    set(newDuration) {
      timing.duration = newDuration
      notifyTimerUpdated()
      notifyTimerDurationUpdated()
    }
  }
  
  var secondsElapsed: NSTimeInterval {
    var secondsElapsed: NSTimeInterval
    if let countingStartTime = countingStartTime {
      let now = NSDate.timeIntervalSinceReferenceDate()
      secondsElapsed = now - countingStartTime + secondsElapsedAtPause
    } else {
      secondsElapsed = secondsElapsedAtPause
    }
    return secondsElapsed
  }
  
  var secondsRemaining: NSTimeInterval {
    let seconds = duration - secondsElapsed
    return max(seconds,0)
  }
  
  var totalShowTimeRemaining: NSTimeInterval {
    switch timing.phase {
    case .PreShow, .Break1, .Break2, .PostShow:
      return max(timing.totalShowTimeRemaining,0)
    case .Section1, .Section2, .Section3:
      return max(timing.totalShowTimeRemaining - secondsElapsed,0)
    }
  }
  
  var totalShowTimeElapsed: NSTimeInterval {
    switch timing.phase {
    case .PreShow, .Break1, .Break2, .PostShow:
      return max(timing.totalShowTimeElapsed,0)
    case .Section1, .Section2, .Section3:
      return max(timing.totalShowTimeElapsed + secondsElapsed,0)
    }
  }
  
  var percentageRemaining: CGFloat {
    return secondsToPercentage(secondsRemaining)
  }
  
  var percentageComplete: CGFloat {
    return 1.0 - percentageRemaining
  }
  
  
  func percentageComplete(phase: ShowPhase) -> CGFloat {
    var percentageComplete = Double(0.0)
    
    switch phase {
    case .PreShow,
         .Break1,
         .Break2:
      percentageComplete = Double(self.percentageComplete)
    case .Section1:
//      let a = timing.durations.section1
//      let b = timing.timeElapsed.section1
//      percentageComplete =  1 - ((a - b) / a)
      
      percentageComplete =  (timing.durations.section1 - timing.timeElapsed.section1) /
                                          timing.durations.section1
    case .Section2:
      percentageComplete =  (timing.durations.section2 - timing.timeElapsed.section2) /
                                          timing.durations.section2
    case .Section3:
      percentageComplete =  (timing.durations.section3 - timing.timeElapsed.section3) /
                                          timing.durations.section3
    case .PostShow:
      percentageComplete = 0.0
    }
    
    return CGFloat(percentageComplete)
  }
  
  var percentageCompleteUnlimited: CGFloat {
    // The secondsRemaining computed property is limited so that 
    // it can not be less than 0.  This property is unlimited allowing
    // percentageComplete to be greater than 1.0
    let percentageRemaining = secondsToPercentage(duration - secondsElapsed)
    let percentageComplete  = 1.0 - percentageRemaining
    return percentageComplete
  }
  
  func percentageFromSeconds(seconds: NSTimeInterval) -> Double {
    let percent = seconds / duration
    return percent
  }
  
  func percentageFromSecondsToEnd(seconds: NSTimeInterval) -> Double {
    let percent = 1 - (seconds / duration)
    return percent
  }
  
  // MARK: Internal Properties
  var _state: CountingState = .Ready {
    didSet {
      onNextRunloopNotifyCountingStateUpdated()
    }
  }
  // MARK: -
  // MARK: Initialization
  override init() {
    super.init()
  }
  
  init?(coder aDecoder: NSCoder) {
    super.init()
    decodeWithCoder(coder: aDecoder)
  }
  
  // MARK: -
  // MARK: Timer Actions
  func changeCountingState(state: CountingState) {
    switch state {
    case .Ready:
      reset()
    case .Counting,
         .CountingAfterComplete:
      start()
    case .Paused,
         .PausedAfterComplete:
      pause()
    }
  }
  
  
  func reset() {
    reset(usingDemoTiming: demoTimings)
  }

  func reset(usingDemoTiming demoTimings: Bool) {
    _state            = .Ready
    countingStartTime = .None
    timing            = ShowTiming()
    if demoTimings {
      timing.durations.useDemoDurations()
      self.demoTimings = true
    } else {
      self.demoTimings = false
    }
    notifyAll()
  }
  
  func start() {
    if percentageComplete < 1.0 {
      _state = .Counting
    } else {
      _state = .CountingAfterComplete
    }
    countingStartTime = NSDate.timeIntervalSinceReferenceDate()
    incrementTimer()
  }
  
  func pause() {
    if percentageComplete < 1.0 {
      _state = .Paused
    } else {
      _state = .PausedAfterComplete
    }
    storeElapsedTimeAtPause()
  }

  func next() {
    storeElapsedTimeAtPause()
    countingStartTime = .None
    timing.incrementPhase()
    notifyTimerDurationUpdated()

    if percentageComplete > 1.0 ||
      timing.phase == .PostShow {
        if _state == .Counting {
          _state = .CountingAfterComplete
        }
        if _state == .Paused {
          _state = .PausedAfterComplete
        }
    }

    switch _state {
    case .Ready:
      reset()
    case .Counting,
         .CountingAfterComplete:
      start()
    case .Paused,
         .PausedAfterComplete:
      notifyTimerUpdated()
      break
    }
  }
  
  
  func addTimeBySeconds(seconds: NSTimeInterval) {
    timing.duration += seconds
    
    switch state {
    case .Ready,
         .Paused:
      notifyTimerUpdated()
    case .Counting,
         .PausedAfterComplete,
         .CountingAfterComplete:
      break
    }
  }
  
  // MARK: -
  // MARK: Notify Observers
  private func notifyTimerUpdated() {
    NSNotificationCenter.defaultCenter()
                        .postNotificationName( Constants.TimeChange,
                                       object: self)
  }
  
  func notifyCountingStateUpdated() {
    NSNotificationCenter.defaultCenter()
                        .postNotificationName( Constants.CountingStatusChanged,
                                       object: self)
  }
  
  private func notifyTimerDurationUpdated() {
    NSNotificationCenter.defaultCenter()
                        .postNotificationName( Constants.DurationChanged,
                                       object: self)
  }
  
  func notifyAll() {
    notifyTimerUpdated()
    notifyCountingStateUpdated()
    notifyTimerDurationUpdated()
  }
  
  
  // MARK: -
  // MARK: Timer
  func incrementTimer() {
    switch state {
    case .Ready:
      break
    case .Paused,
         .PausedAfterComplete:
      storeElapsedTimeAtPause()
    case .Counting,
         .CountingAfterComplete:
      notifyTimerUpdated()
      checkTimingForCompletion()
      incrementTimerAgain()
    }
  }
  
  func checkTimingForCompletion() {
    if timing.durations.advancePhaseOnCompletion(timing.phase) {
      if percentageComplete >= 1.0 {
        next()
      }
    }
  }
  
  private func incrementTimerAgain() {
    NSTimer.scheduledTimerWithTimeInterval( timerUpdateInterval,
                                    target: self,
                                  selector: Selector("incrementTimer"),
                                  userInfo: nil,
                                   repeats: false)
  }
  
  private func storeElapsedTimeAtPause() {
    secondsElapsedAtPause = secondsElapsed
    countingStartTime     = .None
  }
  
  // MARK: -
  // MARK: Helpers
  
  private func secondsToPercentage(secondsRemaining: NSTimeInterval) -> CGFloat {
    return CGFloat(secondsRemaining / duration)
  }
  
  
  
  // The timerChangedCountingStatus() is intended for acting on a change of state
  // only, and not intended as a callback to check property values of the
  // Timer class. (hense, only the TimerStatus emum is passed as the sole argument.)
  // If this callback IS used to check properties, they may not represent
  // the state of the timer correctly since the state is changed first and
  // drives rest of the class.  Properties sensitive to this are:
  //     secondsElapsedAtPause
  //     countingStartTime
  //     secondsElapsed (computed)
  // To mitigate this case, the state callback is delayed until the next
  // runloop using NSTimer with a delay of 0.0.
  private func onNextRunloopNotifyCountingStateUpdated() {
    NSTimer.scheduledTimerWithTimeInterval( 0.0,
                                target: self,
                              selector: Selector("notifyCountingStateUpdated"),
                              userInfo: nil,
                               repeats: false)
  }
  
}


