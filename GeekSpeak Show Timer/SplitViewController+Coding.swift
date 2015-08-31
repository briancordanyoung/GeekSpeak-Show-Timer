import UIKit

extension SplitViewController: UIStateRestoring {
  
  // MARK: -
  // MARK: State Preservation and Restoration
  
  
  // Automatic State Preservation
  override func encodeRestorableStateWithCoder(coder: NSCoder) {
    super.encodeRestorableStateWithCoder(coder)
    coder.encodeObject(timer, forKey: Constants.TimerId)
    removeTemporaryTimerArchive()
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
    removeTemporaryTimerArchive()
    NSKeyedArchiver.archiveRootObject( timer, toFile: temporaryTimerArchivePath)
  }
  
  func decodeTimerFromDisk() {
    if let decodedTimer = NSKeyedUnarchiver
                 .unarchiveObjectWithFile(temporaryTimerArchivePath) as? Timer {
      timer = decodedTimer
      removeTemporaryTimerArchive()
    }
    
  }
  
  
  // Helpers
  private var temporaryTimerArchivePath: String {
    return NSTemporaryDirectory() + Constants.TimerDataPath
  }
  
  private var temporaryTimerArchiveExists: Bool {
    return NSFileManager.defaultManager()
                                    .fileExistsAtPath(temporaryTimerArchivePath)
  }
  
  private func removeTemporaryTimerArchive() {
    if temporaryTimerArchiveExists {
      var error: NSError?
      NSFileManager.defaultManager().removeItemAtPath( temporaryTimerArchivePath,
                                                error: &error)
      if let error = error {
        NSLog("Error removing tmp Timer Data: " + error.description)
      }
    }
  }
  
}