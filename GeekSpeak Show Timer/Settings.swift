class Settings: UIViewController {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  var detailViewController: TimerViewController? {
    
    
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
  
  @IBAction func hideSettingButton(sender: AnyObject) {
    self.splitViewController?.toggleMasterView()
  }
  
  override func viewWillAppear(animated: Bool) {
    generateBluredBackground()
  }
  
  
  func generateBluredBackground() {
    // https://uncorkedstudios.com/blog/ios-7-background-effects-and-split-view-controllers
    
    if let detailViewController = detailViewController {
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

