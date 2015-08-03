import Foundation
import CoreGraphics

let kAppTimerDurationInSecondsKey = "defaultDurationInSeconds"
let oneMinute                     = NSTimeInterval(60)
let timerUpdateInterval           = NSTimeInterval(0.01)

// MARK: -
// MARK: Timer class
final class Timer: NSObject {
  
  
  // MARK: Properties
  var countingStartTime: NSTimeInterval?
  var timing = ShowTiming()

  // Callback Handler Properties (block based API)
  // These should be used as call backs alerting a view controller
  // that one of these events occurred.
  var countingStateChangedHandler: (CountingState) -> ()
  var timerUpdatedHandler:         (Timer?) -> ()
  
  
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
    }
  }
  
  var secondsElapsed: NSTimeInterval {
    var _secondsElapsed: NSTimeInterval
    if let countingStartTime = countingStartTime {
      let now = NSDate.timeIntervalSinceReferenceDate()
      _secondsElapsed = now - countingStartTime + secondsElapsedAtPause
    } else {
      _secondsElapsed = secondsElapsedAtPause
    }
    return _secondsElapsed
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
  
  // MARK: Internal Properties
  var _state: CountingState = .Ready {
    didSet {
      onNextRunloopNotifyCountingStateUpdated()
    }
  }
  
  
  // MARK: -
  // MARK: Init methods
  convenience override init() {
    // I couldn't figure out how to initilize a UIViewController
    // with the nessesary functions as the time the Timer
    // intance is created.  So, I made this convenience init which
    // creates these stand-in println() functions.  These should be
    // replaced in the timer class instance by the callbacks that
    // update any controls like a UIButton or UILabel in the UIViewController.
    
    func printStatus(state: CountingState) {
      #if DEBUG
        println("Change Timer Control Text to: \(printStatus)")
      #endif
    }
    
    func printSecondsRemaining(timer: Timer?) {
      #if DEBUG
        if let timer = timer {
        println("Seconds left: \(timer.secondsRemaining)")
        }
      #endif
    }
    
    self.init(WithStatusChangedHandler: printStatus,
      AndTimerUpdatedHandler: printSecondsRemaining)
  }
  
  init( WithStatusChangedHandler countingStateChangedHandlerFunc: (CountingState) -> (),
        AndTimerUpdatedHandler   timerUpdatedHandlerFunc:  (Timer?) -> ()    ) {
      countingStateChangedHandler = countingStateChangedHandlerFunc
      timerUpdatedHandler         = timerUpdatedHandlerFunc
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
    _state            = .Ready
    countingStartTime = .None
    timing            = ShowTiming()
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
    if _state == .Counting {
      start()
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
  
  private func notifyTimerUpdated() {
    weak var weakSelf = self
    timerUpdatedHandler(weakSelf)
  }
  
  
  // The countingStateChangedHandler() is intended for acting on a change of state
  // only, and not intended as a callback to check property values of the
  // Timer class. (hense, only the TimerStatus emun is passed as the sole argument.)
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
  
  func notifyCountingStateUpdated() {
    countingStateChangedHandler(state)
  }
  
}


