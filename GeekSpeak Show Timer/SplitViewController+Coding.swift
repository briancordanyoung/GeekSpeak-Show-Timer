import UIKit

extension SplitViewController: UIStateRestoring {
  
  // MARK: -
  // MARK: State Preservation and Restoration
  
  
  // Automatic State Preservation
  override func encodeRestorableStateWithCoder(coder: NSCoder) {
    super.encodeRestorableStateWithCoder(coder)
    coder.encodeObject(timer, forKey: Constants.TimerId)
    removeTemporaryTimerData()
  }
  
  override func decodeRestorableStateWithCoder(coder: NSCoder) {
    if let decodedTimer =
                         coder.decodeObjectForKey(Constants.TimerId) as? Timer {
      timer = decodedTimer
    } else {
      timer = Timer()
    }
  }
  
  
  override func encodeWithCoder(aCoder: NSCoder) {
    super.encodeWithCoder(aCoder)
    aCoder.encodeObject(timer, forKey: Constants.TimerId)
  }
  
  
  // Explicit Coding
  func encodeTimerToDisk() {
    removeTemporaryTimerData()
    NSKeyedArchiver.archiveRootObject( timer, toFile: temporaryTimerDataPath)
  }
  
  func decodeTimerFromDisk() {
    if let decodedTimer = NSKeyedUnarchiver
                    .unarchiveObjectWithFile(temporaryTimerDataPath) as? Timer {
      timer = decodedTimer
      removeTemporaryTimerData()
    }
    
  }
  
  
  // Helpers
  private var temporaryTimerDataPath: String {
    return NSTemporaryDirectory() + Constants.TimerDataPath
  }
  
  private var temporaryTimerDateExists: Bool {
    return NSFileManager.defaultManager()
                                       .fileExistsAtPath(temporaryTimerDataPath)
  }
  
  private func removeTemporaryTimerData() {
    if temporaryTimerDateExists {
      var error: NSError?
      NSFileManager.defaultManager().removeItemAtPath( temporaryTimerDataPath,
                                                error: &error)
      if let error = error {
        NSLog("Error removing tmp Timer Data: " + error.description)
      }
    }
  }
  
}