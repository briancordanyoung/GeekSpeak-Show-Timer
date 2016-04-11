import UIKit



extension Timer: NSCoding {
  
  // MARK: -
  // MARK: State Preservation and Restoration
    convenience init?(coder aDecoder: NSCoder) {
        self.init()
        decodeWithCoder(coder: aDecoder)
    }
    
    
    
  func decodeWithCoder(coder aDecoder: NSCoder) {

    let decodedObject = aDecoder.decodeObjectForKey(Constants.UUIDId) as! NSUUID
    uuid = decodedObject
    demoTimings = aDecoder.decodeBoolForKey(Constants.DemoId)
    
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
    

    
    let countingStartTimeDecoded =
                      aDecoder.decodeDoubleForKey(Constants.CountingStartTimeId)
    if countingStartTimeDecoded == DBL_MAX {
      countingStartTime = .None
    } else {
      countingStartTime = countingStartTimeDecoded
    }
    
    timing = ShowTiming()
    let int = aDecoder.decodeIntForKey(Constants.PhaseId)
    let phase: ShowPhase
    
    switch int {
    case 1:  phase = .PreShow
    case 2:  phase = .Section1
    case 3:  phase = .Break2
    case 4:  phase = .Section2
    case 5:  phase = .Break2
    case 6:  phase = .Section3
    case 7:  phase = .PostShow
    default: phase = .PreShow
    }
    timing.phase = phase
    
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
    
    incrementTimer()
  }
  
  
  
  
  
  
  
  
  func encodeWithCoder(aCoder: NSCoder) {
    
    aCoder.encodeObject(uuid, forKey: Constants.UUIDId)
    aCoder.encodeBool(demoTimings, forKey: Constants.DemoId)
    
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
    
    let int: Int32

    switch timing.phase {
    case .PreShow:  int = 1
    case .Section1: int = 2
    case .Break1:   int = 3
    case .Section2: int = 4
    case .Break2:   int = 5
    case .Section3: int = 6
    case .PostShow: int = 7
    }

    aCoder.encodeInt(int, forKey: Constants.PhaseId)

    
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
