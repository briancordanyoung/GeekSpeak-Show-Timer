import Foundation
import CoreGraphics


let oneMinute             = NSTimeInterval(60)
let timerUpdateInterval   = NSTimeInterval(0.01)

protocol TimerDelegate {
  func timerChangedCountingStatus(state: Timer.CountingState)
  func timerUpdatedTime(timer: Timer?)
  func timerDurationChanged(timer: Timer?)
}

// MARK: -
// MARK: Timer class
final class Timer: NSObject, NSCoding {
  
  
  // MARK: Properties
  var countingStartTime: NSTimeInterval?
  var timing = ShowTiming()
  var delegate: TimerDelegate?
  
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
  
  init(coder aDecoder: NSCoder) {
    super.init()
    decodeWithCoder(coder: aDecoder)
  }
  
  // MARK: -
  // MARK: Timer Actions
  func changeCountingState(state: CountingState) {
    switch state {
    case .Ready:
      reset()
    case .Counting:
      start()
    case .Paused:
      pause()
    }
  }
  
  
  func reset() {
    reset(usingDemoTiming: false)
  }

  func reset(usingDemoTiming demoTimings: Bool) {
    _state            = .Ready
    countingStartTime = .None
    timing            = ShowTiming()
    if demoTimings {
      timing.durations.useDemoDurations()
    }
    notifyTimerUpdated()
  }
  
  func start() {
    _state = .Counting
    countingStartTime = NSDate.timeIntervalSinceReferenceDate()
    incrementTimer()
  }
  
  func pause() {
    _state = .Paused
    storeElapsedTimeAtPause()
  }

  func next() {
    storeElapsedTimeAtPause()
    countingStartTime = .None
    timing.incrementPhase()
    notifyTimerDurationUpdated()

    switch _state {
    case .Ready:
      reset()
    case .Counting:
      start()
    case .Paused:
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
    case .Counting:
      break
    }
  }
  
  // MARK: -
  // MARK: Delegate callbacks
  private func notifyTimerUpdated() {
    if let delegate = delegate {
      weak var weakSelf = self
      delegate.timerUpdatedTime(weakSelf)
    }
  }
  
  func notifyCountingStateUpdated() {
    if let delegate = delegate {
      delegate.timerChangedCountingStatus(state)
    }
  }
  
  func notifyTimerDurationUpdated() {
    if let delegate = delegate {
      weak var weakSelf = self
      delegate.timerDurationChanged(weakSelf)
    }
  }
  
  // MARK: -
  // MARK: Timer
  func incrementTimer() {
    switch state {
    case .Ready:
      break
    case .Paused:
      storeElapsedTimeAtPause()
    case .Counting:
      notifyTimerUpdated()
      incrementTimerAgain()
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


