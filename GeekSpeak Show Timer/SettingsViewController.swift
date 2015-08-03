class SettingsViewController: UIViewController {
  
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
  
  
  
  
  var timerViewController: TimerViewController? {
    var timerViewController: TimerViewController? = .None
    if let tmpSVC = splitViewController {
      if let tmpLast: AnyObject? = tmpSVC.viewControllers.last {
        if let viewController = tmpLast as? TimerViewController {
          timerViewController = viewController
        }
      }
    }
    return timerViewController
  }

  override func viewWillAppear(animated: Bool) {
    generateBluredBackground()
  }
  
  
  @IBAction func hideSettingButton(sender: AnyObject) {
    self.splitViewController?.toggleMasterView()
  }
  
  
  
  @IBAction func add1SecondButtonPressed(sender: UIButton) {
    timerViewController?.timer.duration += 1.0
    generateBluredBackground()
  }
  
  @IBAction func add5SecondsButtonPressed(sender: UIButton) {
    timerViewController?.timer.duration += 5.0
    generateBluredBackground()
  }
  
  @IBAction func add10SecondsButtonPressed(sender: UIButton) {
    timerViewController?.timer.duration += 10.0
    generateBluredBackground()
  }
  
  @IBAction func remove1SecondButtonPressed(sender: UIButton) {
    timerViewController?.timer.duration -= 1.0
    generateBluredBackground()
  }
  
  @IBAction func resetButtonPressed(sender: UIButton) {
    timerViewController?.timer.reset()
    generateBluredBackground()
  }
  
  
  
  
  
  
  func generateBluredBackground() {
    // https://uncorkedstudios.com/blog/ios-7-background-effects-and-split-view-controllers
    
    if let detailViewController = timerViewController {
      // set up the graphics context to render the screen snapshot.
      // Note the scale value... Values greater than 1 make a context smaller
      // than the detail view controller. Smaller context means faster rendering
      // of the final blurred background image
      let scaleValue = CGFloat(8)
      let detailViewControllerSize = detailViewController.view.frame.size
      let contextSize = CGSizeMake(detailViewControllerSize.width  / scaleValue,
                                   detailViewControllerSize.height / scaleValue)
      UIGraphicsBeginImageContextWithOptions(contextSize, true, 1)
      let drawingRect = CGRectMake(0, 0, contextSize.width, contextSize.height)

      // Now grab the snapshot of the detail view controllers content
      detailViewController.view.drawViewHierarchyInRect( drawingRect,
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
      let subImage = CGImageCreateWithImageInRect(snapshotImage.CGImage, subRect)
    
      if let backgroundImage = UIImage(CGImage: subImage) {
        // CGImageRelease(subImage)
        
        // Now actually apply the blur to the snapshot and set the background
        // behind our master view controller
        backgroundImageView.image = backgroundImage.applyBlurWithRadius( 20,
                                                tintColor: UIColor.clearColor(),
                                    saturationDeltaFactor: 1.8,
                                                maskImage: nil)
      }
    }
  }
  
  
}

