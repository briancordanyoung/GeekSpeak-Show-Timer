import UIKit

class SettingsViewController: UIViewController {

  var timer: Timer?
  var backgroundBlurringInProgress = false
  
  // Required properties
  @IBOutlet weak var contentView: UIView!
  
  // The backupImageView is only a gross fix to hide that the backgroundImageView
  // is disappearing when the REFrostedViewController animates is out of view
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var backupImageView: UIImageView!
  
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
    useDemoDurations = NSUserDefaults
                                   .standardUserDefaults()
                                   .boolForKey(Timer.Constants.UseDemoDurations)
  }
  
  // MARK: ViewController
  override func viewDidLoad() {
    addContraintsForContentView()
  }
  
  override func viewWillAppear(animated: Bool) {
    generateBlurredBackground()
    updateElapsedTimeLabels()
    registerForTimerNotifications()
    addContraintForBlurredImage()
  }
  
  override func viewDidAppear(animated: Bool) {
  }
  
  override func viewWillDisappear(animated: Bool) {
    unregisterForTimerNotifications()
  }
  
  override func viewDidDisappear(animated: Bool) {
    removeContraintForBlurredImage()
  }
  
  
  // MARK: Actions
  @IBAction func add1SecondButtonPressed(sender: UIButton) {
    timer?.duration += 1.0
    generateBlurredBackground()
  }
  
  @IBAction func add5SecondsButtonPressed(sender: UIButton) {
    timer?.duration += 5.0
    generateBlurredBackground()
  }
  
  @IBAction func add10SecondsButtonPressed(sender: UIButton) {
    timer?.duration += 10.0
    generateBlurredBackground()
  }
  
  @IBAction func remove1SecondButtonPressed(sender: UIButton) {
    timer?.duration -= 1.0
    generateBlurredBackground()
  }
  
  @IBAction func resetButtonPressed(sender: UIButton) {
    resetTimer()
    generateBlurredBackground()
  }
  
  
  // MARK: -
  // MARK: Timer management
  func resetTimer() {
    updateUseDemoDurations()
    if useDemoDurations {
      timer?.reset(usingDemoTiming: true)
    } else {
      timer?.reset(usingDemoTiming: false)
    }
  }
  
  

  func generateBlurredBackground() {

    if backgroundBlurringInProgress { return }
    
    backgroundBlurringInProgress = true
    
    if let underneathViewController = timerViewController {
      // set up the graphics context to render the screen snapshot.
      // Note the scale value... Values greater than 1 make a context smaller
      // than the detail view controller. Smaller context means faster rendering
      // of the final blurred background image
      let scaleValue = CGFloat(32)
      let underneathViewControllerSize = underneathViewController.view.frame.size
      let contextSize =
                    CGSizeMake(underneathViewControllerSize.width  / scaleValue,
                               underneathViewControllerSize.height / scaleValue)
      UIGraphicsBeginImageContextWithOptions(contextSize, true, 1)
      let drawingRect = CGRectMake(0, 0, contextSize.width, contextSize.height)

      // Now grab the snapshot of the detail view controllers content
      underneathViewController.view.drawViewHierarchyInRect( drawingRect,
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
      let subRect = CGRectMake(0, 0, self.view.frame.size.width / scaleValue,
                                     self.view.frame.size.height / scaleValue)
      if let subImage = CGImageCreateWithImageInRect(snapshotImage.CGImage, subRect) {
      
        let backgroundImage = UIImage(CGImage: subImage)
          // CGImageRelease(subImage)
          
          // Now actually apply the blur to the snapshot and set the background
          // behind our master view controller
          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {

          let blurredBackgroundImage = backgroundImage.applyBlurWithRadius(2,
                                                  tintColor: UIColor(red: 0.0,
                                                                   green: 0.0,
                                                                    blue: 0.0,
                                                                   alpha: 0.5),
                                      saturationDeltaFactor: 1.8,
                                                  maskImage: nil)
              dispatch_sync(dispatch_get_main_queue(), {
                  self.backgroundImageView.image = blurredBackgroundImage
                  self.backupImageView.image = blurredBackgroundImage
                  self.backgroundBlurringInProgress = false
              })
            })
        }
    } else {
      backgroundImageView.image = UIImage.imageWithColor(UIColor.blackColor())
      backupImageView.image     = backgroundImageView.image
    }
}  //generateBlurredBackground
  
  
  func addContraintsForContentView() {
    
    let leftConstraint = NSLayoutConstraint(item: contentView,
                                       attribute: .Left,
                                       relatedBy: .Equal,
                                          toItem: view,
                                       attribute: .Left,
                                      multiplier: 1.0,
                                        constant: 0.0)
    view.addConstraint(leftConstraint)
    
    let rightConstraint = NSLayoutConstraint(item: contentView,
                                        attribute: .Right,
                                        relatedBy: .Equal,
                                           toItem: view,
                                        attribute: .Right,
                                       multiplier: 1.0,
                                         constant: 0.0)
    view.addConstraint(rightConstraint)
    
  }
  
  func addContraintForBlurredImage() {
    guard let parent = parentViewController else {return}
    
    if blurredImageLeftsideContraint.hasNoValue {
      let leftConstraint = NSLayoutConstraint(item: backgroundImageView,
                                         attribute: .Left,
                                         relatedBy: .Equal,
                                            toItem: parent.view,
                                         attribute: .Left,
                                        multiplier: 1.0,
                                          constant: 0.0)
      blurredImageLeftsideContraint = leftConstraint
      parent.view.addConstraint(leftConstraint)
    }
  }
  
  
  func removeContraintForBlurredImage() {
    guard let parent = parentViewController else {
      blurredImageLeftsideContraint = .None
      return
    }

    if let contraint = blurredImageLeftsideContraint {
      parent.view.removeConstraint(contraint)
      blurredImageLeftsideContraint = .None
    }
    
  }

  
}

