import UIKit

class SettingsViewController: UIViewController {

  var timer: Timer?
  var backgroundBlurringInProgress = false
  
  // Required properties
  @IBOutlet weak var contentView: UIView!
  
  // The backupImageView is only a gross fix to hide that the backgroundImageView
  // is disappearing when the REFrostedViewController animates is out of view
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  @IBOutlet weak var add1SecondButton: UIButton!
  @IBOutlet weak var add5SecondsButton: UIButton!
  @IBOutlet weak var add10SecondsButton: UIButton!
  @IBOutlet weak var remove1SecondButton: UIButton!
  @IBOutlet weak var resetButton: UIButton!
  
  @IBOutlet weak var segment1Label: UILabel!
  @IBOutlet weak var segment2Label: UILabel!
  @IBOutlet weak var segment3Label: UILabel!
  @IBOutlet weak var postShowLabel: UILabel!
  
  
  
  // MARK: Convience Properties
  var timerViewController: TimerViewController?
  var blurredImageLeftsideContraint: NSLayoutConstraint?
  
  var useDemoDurations = false
  func updateUseDemoDurations() {
    useDemoDurations = UserDefaults.standard
                                   .bool(forKey: Timer.Constants.UseDemoDurations)
  }
  
  // MARK: ViewController
  override func viewDidLoad() {
    addContraintsForContentView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    generateBlurredBackground()
    updateElapsedTimeLabels()
    registerForTimerNotifications()
    addContraintForBlurredImage()
  }
  
  override func viewDidAppear(_ animated: Bool) {
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    unregisterForTimerNotifications()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    removeContraintForBlurredImage()
  }
  
  // MARK: Actions
  @IBAction func add1SecondButtonPressed(_ sender: UIButton) {
    timer?.duration += 1.0
    generateBlurredBackground()
  }
  
  @IBAction func add5SecondsButtonPressed(_ sender: UIButton) {
    timer?.duration += 5.0
    generateBlurredBackground()
  }
  
  @IBAction func add10SecondsButtonPressed(_ sender: UIButton) {
    timer?.duration += 10.0
    generateBlurredBackground()
  }
  
  @IBAction func remove1SecondButtonPressed(_ sender: UIButton) {
    timer?.duration -= 1.0
    generateBlurredBackground()
  }
  
  @IBAction func resetButtonPressed(_ sender: UIButton) {
    resetTimer()
    generateBlurredBackground()
  }
  
  
  // MARK: -
  // MARK: Timer management
  func resetTimer() {
    updateUseDemoDurations()
    timer?.reset(usingDemoTiming: useDemoDurations)
    
    // Delay the generateBlurredBackground until the TimerViews are drawn
    // by waiting until the next run loop.
    self.perform(#selector(SettingsViewController.generateBlurredBackground), with: .none,
                                                      afterDelay: 0.0)
  }
  
  

  @objc func generateBlurredBackground() {

    if backgroundBlurringInProgress { return }
    
    backgroundBlurringInProgress = true
    
    if let underneathViewController = timerViewController {
      // set up the graphics context to render the screen snapshot.
      // Note the scale value... Values greater than 1 make a context smaller
      // than the detail view controller. Smaller context means faster rendering
      // of the final blurred background image
      let scaleValue = CGFloat(16)
      let underneathViewControllerSize = underneathViewController.view.frame.size
      let contextSize =
                    CGSize(width: underneathViewControllerSize.width  / scaleValue,
                               height: underneathViewControllerSize.height / scaleValue)
      UIGraphicsBeginImageContextWithOptions(contextSize, true, 1)
      let drawingRect = CGRect(x: 0, y: 0, width: contextSize.width, height: contextSize.height)

      // Now grab the snapshot of the detail view controllers content
      underneathViewController.view.drawHierarchy( in: drawingRect,
                                         afterScreenUpdates: false)
      let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      // Now get a sub-image of our snapshot. Just grab the portion of the
      // shapshot that would be covered by the master view controller when
      // it becomes visible.
      // Pulling out the sub-image means we can supply an appropriately sized
      // background image for the master controller, and makes application of
      // the blur effect run faster since we are only only blurring image data 
      // that will actually be visible.    
      let subRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width / scaleValue,
                                     height: self.view.frame.size.height / scaleValue)
      if let subImage = snapshotImage?.cgImage?.cropping(to: subRect) {
      
        let backgroundImage = UIImage(cgImage: subImage)
          // CGImageRelease(subImage)
          
          // Now actually apply the blur to the snapshot and set the background
          // behind our master view controller
        DispatchQueue.global(qos: .userInteractive).async() {

          let blurredBackgroundImage = backgroundImage.applyBlur(withRadius: 2,
                                                  tintColor: UIColor(red: 0.0,
                                                                   green: 0.0,
                                                                    blue: 0.0,
                                                                   alpha: 0.5),
                                      saturationDeltaFactor: 1.8,
                                                  maskImage: nil)
            DispatchQueue.main.sync() {
                self.backgroundImageView.image = blurredBackgroundImage
                self.backgroundBlurringInProgress = false
          }
        }
      } else {
      backgroundImageView.image = UIImage.imageWithColor(UIColor.black)
    }
  }
}  //generateBlurredBackground
  
  
  func addContraintsForContentView() {
    
    let leftConstraint = NSLayoutConstraint(item: contentView,
                                       attribute: .left,
                                       relatedBy: .equal,
                                          toItem: view,
                                       attribute: .left,
                                      multiplier: 1.0,
                                        constant: 0.0)
    view.addConstraint(leftConstraint)
    
    let rightConstraint = NSLayoutConstraint(item: contentView,
                                        attribute: .right,
                                        relatedBy: .equal,
                                           toItem: view,
                                        attribute: .right,
                                       multiplier: 1.0,
                                         constant: 0.0)
    view.addConstraint(rightConstraint)
    
  }
  
  func addContraintForBlurredImage() {
    guard let parent = parent else {return}
    
    if blurredImageLeftsideContraint.hasNoValue {
      let leftConstraint = NSLayoutConstraint(item: backgroundImageView,
                                         attribute: .left,
                                         relatedBy: .equal,
                                            toItem: parent.view,
                                         attribute: .left,
                                        multiplier: 1.0,
                                          constant: 0.0)
      blurredImageLeftsideContraint = leftConstraint
      parent.view.addConstraint(leftConstraint)
    }
  }
  
  
  func removeContraintForBlurredImage() {
    guard let parent = parent else {
      blurredImageLeftsideContraint = .none
      return
    }

    if let contraint = blurredImageLeftsideContraint {
      parent.view.removeConstraint(contraint)
      blurredImageLeftsideContraint = .none
    }
    
  }

  
}

