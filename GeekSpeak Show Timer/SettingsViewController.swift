class SettingsViewController: UIViewController {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var leftNavButton: UIBarButtonItem!
  
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
  var timerViewController: TimerViewController? {
    var timerViewController: TimerViewController? = .None
    if let splitViewController = splitViewController {
      if let navController: AnyObject? =
                                      splitViewController.viewControllers.last {
        if let navController = navController as? UINavigationController {
          if let tmpTimerViewController =
                       navController.topViewController as? TimerViewController {
            timerViewController = tmpTimerViewController
          }
        }
      }
    }
    return timerViewController
  }
  
  // MARK: VIewController
  override func viewWillAppear(animated: Bool) {
    generateBluredBackground()
    self.navigationController?.navigationBar
             .setBackgroundImage( UIImage.imageWithColor( UIColor.blackColor()),
                                           forBarMetrics: UIBarMetrics.Default)
    self.navigationController?.view.backgroundColor = UIColor.blackColor()
    self.navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
    self.navigationController?.navigationBar.translucent = false
  }
  
  
  override func viewDidAppear(animated: Bool) {
    manageButtonBarButtons()
    updateTimerLabels()
    NSNotificationCenter.defaultCenter()
              .addObserver( self,
                  selector: "updateTimerLabels",
                      name: TimerViewController.Constants.TimerNotificationKey,
                    object: nil)
  }
  
  override func viewWillDisappear(animated: Bool) {
    NSNotificationCenter.defaultCenter().removeObserver(self)
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
    timerViewController?.resetTimer()
    generateBluredBackground()
  }
  
  func updateTimerLabels() {
    if let timer = timerViewController?.timer {
      
      let timing   = timer.timing
      
      var segment1 = timing.asString(timing.timeElapsed.section1)
      var segment2 = timing.asString(timing.timeElapsed.section2)
      var segment3 = timing.asString(timing.timeElapsed.section3)
      var postshow = timing.asString(timing.timeElapsed.postShow)
      
      switch timing.phase {
      case .PreShow,
           .Break1,
           .Break2:
        break
        
      case .Section1:
        segment1 = timing.asString(timer.secondsElapsed)
        
      case .Section2:
        segment2 = timing.asString(timer.secondsElapsed)
        
      case .Section3:
        segment3 = timing.asString(timer.secondsElapsed)
        
      case .PostShow:
        postshow = timing.asString(timer.secondsElapsed)
      }
      
      segment1Label.text = segment1
      segment2Label.text = segment2
      segment3Label.text = segment3
      postShowLabel.text = postshow
      
      // TODO: Uncomment once this is on a background thread
      //       generateBluredBackground()

    }
  }

  @IBAction func showTimerNavButtonPressed(sender: UIBarButtonItem) {
    if let splitViewController = splitViewController {
      // collapsed = true  is iPhone
      // collapsed = false is iPad & Plus
      if splitViewController.collapsed == true {
        self.performSegueWithIdentifier("showTimer", sender: self)
      } else {
        self.splitViewController?.toggleMasterView()
      }
    }
  }
  
  func manageButtonBarButtons() {
    if let splitViewController = splitViewController  {
      // collapsed = true  is iPhone
      // collapsed = false is iPad & Plus
      if splitViewController.collapsed == true {
        leftNavButton.title = "Show Timer"
      } else {
        leftNavButton.title = "Hide"
      }
    }
  }
  
  
  // TODO: Do this on a background thread
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
    } else {
      backgroundImageView.image = UIImage.imageWithColor(UIColor.blackColor())
    }
    
    
    
  } // generateBluredBackground
  
  
}

