import UIKit



extension Timer {
  
  // MARK: -
  // MARK: State Preservation and Restoration
  func decodeWithCoder(coder aDecoder: NSCoder) {
    
    let countingState = aDecoder.decodeIntForKey(Constants.StateId)
    switch countingState {
    case 1:
      _state = .Ready
    case 2:
      _state = .Counting
    case 3:
      _state = .Paused
    default:
      _state = .Ready
    }
    
//    let demoTimings = aDecoder.decodeBoolForKey(Constants.UseDemoDurations)

    
    let countingStartTimeDecoded =
    aDecoder.decodeDoubleForKey(Constants.CountingStartTimeId)
    if countingStartTimeDecoded == DBL_MAX {
      countingStartTime = .None
    } else {
      countingStartTime = countingStartTimeDecoded
    }
    
    timing = ShowTiming()
    switch aDecoder.decodeIntForKey(Constants.PhaseId) {
    case 1:
      timing.phase = .PreShow
    case 2:
      timing.phase = .Section1
    case 3:
      timing.phase = .Break2
    case 4:
      timing.phase = .Section2
    case 5:
      timing.phase = .Break2
    case 6:
      timing.phase = .Section3
    case 7:
      timing.phase = .PostShow
    default:
      timing.phase = .PreShow
    }
    
    timing.durations.preShow  =
                      aDecoder.decodeDoubleForKey(Constants.Durations.PreShowId)
    timing.durations.section1 =
                     aDecoder.decodeDoubleForKey(Constants.Durations.Section1Id)
    timing.durations.section2 =
                     aDecoder.decodeDoubleForKey(Constants.Durations.Section2Id)
    timing.durations.section3 =
                     aDecoder.decodeDoubleForKey(Constants.Durations.Section3Id)
    timing.durations.break1   =
                       aDecoder.decodeDoubleForKey(Constants.Durations.Break1Id)
    timing.durations.break2   =
                       aDecoder.decodeDoubleForKey(Constants.Durations.Break2Id)
    
    timing.timeElapsed.preShow  =
                    aDecoder.decodeDoubleForKey(Constants.ElapsedTime.PreShowId)
    timing.timeElapsed.section1 =
                   aDecoder.decodeDoubleForKey(Constants.ElapsedTime.Section1Id)
    timing.timeElapsed.section2 =
                   aDecoder.decodeDoubleForKey(Constants.ElapsedTime.Section2Id)
    timing.timeElapsed.section3 =
                   aDecoder.decodeDoubleForKey(Constants.ElapsedTime.Section3Id)
    timing.timeElapsed.break1   =
                     aDecoder.decodeDoubleForKey(Constants.ElapsedTime.Break1Id)
    timing.timeElapsed.break2   =
                     aDecoder.decodeDoubleForKey(Constants.ElapsedTime.Break2Id)
    timing.timeElapsed.postShow =
                   aDecoder.decodeDoubleForKey(Constants.ElapsedTime.PostShowId)
    
    notify()
    incrementTimer()
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    
    switch _state {
    case .Ready:
      aCoder.encodeInt(1, forKey: Constants.StateId)
    case .Counting:
      aCoder.encodeInt(2, forKey: Constants.StateId)
    case .Paused:
      aCoder.encodeInt(3, forKey: Constants.StateId)
    case .PausedAfterComplete:
      aCoder.encodeInt(4, forKey: Constants.StateId)
    case .CountingAfterComplete:
      aCoder.encodeInt(5, forKey: Constants.StateId)
    }
    
    if let countingStartTime = countingStartTime {
      aCoder.encodeDouble( countingStartTime,
                   forKey: Constants.CountingStartTimeId)
    } else {
      aCoder.encodeDouble( DBL_MAX,
                   forKey: Constants.CountingStartTimeId)
    }
    
    aCoder.encodeBool(demoTimings, forKey: Constants.UseDemoDurations)
    
    switch timing.phase {
    case .PreShow:
      aCoder.encodeInt(1, forKey: Constants.PhaseId)
    case .Section1:
      aCoder.encodeInt(2, forKey: Constants.PhaseId)
    case .Break1:
      aCoder.encodeInt(3, forKey: Constants.PhaseId)
    case .Section2:
      aCoder.encodeInt(4, forKey: Constants.PhaseId)
    case .Break2:
      aCoder.encodeInt(5, forKey: Constants.PhaseId)
    case .Section3:
      aCoder.encodeInt(6, forKey: Constants.PhaseId)
    case .PostShow:
      aCoder.encodeInt(7, forKey: Constants.PhaseId)
    }
    
    let d = timing.durations
    aCoder.encodeDouble(d.preShow,  forKey: Constants.Durations.PreShowId)
    aCoder.encodeDouble(d.section1, forKey: Constants.Durations.Section1Id)
    aCoder.encodeDouble(d.break1,   forKey: Constants.Durations.Break1Id)
    aCoder.encodeDouble(d.section2, forKey: Constants.Durations.Section2Id)
    aCoder.encodeDouble(d.break2,   forKey: Constants.Durations.Break2Id)
    aCoder.encodeDouble(d.section3, forKey: Constants.Durations.Section3Id)
    
    let t = timing.timeElapsed
    aCoder.encodeDouble(t.preShow,  forKey: Constants.ElapsedTime.PreShowId)
    aCoder.encodeDouble(t.section1, forKey: Constants.ElapsedTime.Section1Id)
    aCoder.encodeDouble(t.break1,   forKey: Constants.ElapsedTime.Break1Id)
    aCoder.encodeDouble(t.section2, forKey: Constants.ElapsedTime.Section2Id)
    aCoder.encodeDouble(t.break2,   forKey: Constants.ElapsedTime.Break2Id)
    aCoder.encodeDouble(t.section3, forKey: Constants.ElapsedTime.Section3Id)
    aCoder.encodeDouble(t.postShow, forKey: Constants.ElapsedTime.PostShowId)
  }
  
  
}
