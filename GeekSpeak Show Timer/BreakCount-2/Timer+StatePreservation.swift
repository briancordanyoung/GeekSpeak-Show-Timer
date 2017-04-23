import UIKit



extension Timer: NSCoding {
  
  // MARK: -
  // MARK: State Preservation and Restoration
    convenience init?(coder aDecoder: NSCoder) {
        self.init()
        decodeWithCoder(coder: aDecoder)
    }
    
    
    
  func decodeWithCoder(coder aDecoder: NSCoder) {

    let decodedObject = aDecoder.decodeObject(forKey: Constants.UUIDId) as! UUID
    uuid = decodedObject
    demoTimings = aDecoder.decodeBool(forKey: Constants.DemoId)
    
    let countingState = aDecoder.decodeCInt(forKey: Constants.StateId)
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
                      aDecoder.decodeDouble(forKey: Constants.CountingStartTimeId)
    if countingStartTimeDecoded == DBL_MAX {
      countingStartTime = .none
    } else {
      countingStartTime = countingStartTimeDecoded
    }
    
    timing = ShowTiming()
    let int = aDecoder.decodeCInt(forKey: Constants.PhaseId)
    let phase: ShowPhase
    
    switch int {
    case 1:  phase = .PreShow
    case 2:  phase = .Section1
    case 3:  phase = .Break1
    case 4:  phase = .Section2
    case 5:  phase = .PostShow
    default: phase = .PreShow
    }
    timing.phase = phase
    
    timing.durations.preShow  =
                      aDecoder.decodeDouble(forKey: Constants.Durations.PreShowId)
    timing.durations.section1 =
                     aDecoder.decodeDouble(forKey: Constants.Durations.Section1Id)
    timing.durations.section2 =
                     aDecoder.decodeDouble(forKey: Constants.Durations.Section2Id)
    timing.durations.break1   =
                       aDecoder.decodeDouble(forKey: Constants.Durations.Break1Id)
    
    timing.timeElapsed.preShow  =
                    aDecoder.decodeDouble(forKey: Constants.ElapsedTime.PreShowId)
    timing.timeElapsed.section1 =
                   aDecoder.decodeDouble(forKey: Constants.ElapsedTime.Section1Id)
    timing.timeElapsed.section2 =
                   aDecoder.decodeDouble(forKey: Constants.ElapsedTime.Section2Id)
    timing.timeElapsed.break1   =
                     aDecoder.decodeDouble(forKey: Constants.ElapsedTime.Break1Id)
    timing.timeElapsed.postShow =
                   aDecoder.decodeDouble(forKey: Constants.ElapsedTime.PostShowId)
    
    incrementTimer()
  }
  
  
  
  
  
  
  
  
  func encode(with aCoder: NSCoder) {
    
    aCoder.encode(uuid, forKey: Constants.UUIDId)
    aCoder.encode(demoTimings, forKey: Constants.DemoId)
    
    switch _state {
    case .Ready:
      aCoder.encodeCInt(1, forKey: Constants.StateId)
    case .Counting:
      aCoder.encodeCInt(2, forKey: Constants.StateId)
    case .Paused:
      aCoder.encodeCInt(3, forKey: Constants.StateId)
    case .PausedAfterComplete:
      aCoder.encodeCInt(4, forKey: Constants.StateId)
    case .CountingAfterComplete:
      aCoder.encodeCInt(5, forKey: Constants.StateId)
    }
    
    if let countingStartTime = countingStartTime {
      aCoder.encode( countingStartTime,
                   forKey: Constants.CountingStartTimeId)
    } else {
      aCoder.encode( DBL_MAX,
                   forKey: Constants.CountingStartTimeId)
    }
    
    aCoder.encode(demoTimings, forKey: Constants.UseDemoDurations)
    
    let int: Int32

    switch timing.phase {
    case .PreShow:  int = 1
    case .Section1: int = 2
    case .Break1:   int = 3
    case .Section2: int = 4
    case .PostShow: int = 5
    }

    aCoder.encodeCInt(int, forKey: Constants.PhaseId)

    
    let d = timing.durations
    aCoder.encode(d.preShow,  forKey: Constants.Durations.PreShowId)
    aCoder.encode(d.section1, forKey: Constants.Durations.Section1Id)
    aCoder.encode(d.break1,   forKey: Constants.Durations.Break1Id)
    aCoder.encode(d.section2, forKey: Constants.Durations.Section2Id)
    
    let t = timing.timeElapsed
    aCoder.encode(t.preShow,  forKey: Constants.ElapsedTime.PreShowId)
    aCoder.encode(t.section1, forKey: Constants.ElapsedTime.Section1Id)
    aCoder.encode(t.break1,   forKey: Constants.ElapsedTime.Break1Id)
    aCoder.encode(t.section2, forKey: Constants.ElapsedTime.Section2Id)
    aCoder.encode(t.postShow, forKey: Constants.ElapsedTime.PostShowId)
  }
  
  
}
