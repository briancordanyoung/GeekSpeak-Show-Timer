import UIKit


enum TimerLabelDisplay: String, Printable {
  case Remaining = "Remaining"
  case Elapsed   = "Elapsed"
  
  var description: String {
    return self.rawValue
  }
}

final class TimerViewController: UIViewController {
  
  struct Constants {
    static let DeemphisisedButtonScale = CGFloat(0.25)
    static let EmphisisedButtonScale   = CGFloat(1.0 )
    static let GeekSpeakBlueColor = UIColor(red: 14/255,
                                          green: 115/255,
                                           blue: 192/255,
                                          alpha: 1.0)
    
    static let BreakColor         = UIColor(red: 0.75,
                                          green: 0.0,
                                           blue: 0.0,
                                          alpha: 1.0)
    
//    static let WarningColor       = UIColor(red: 13/255,
//                                          green: 255/255,
//                                           blue: 179/255,
//                                          alpha: 1.0)
//    
//    static let AlarmColor         = UIColor(red: 255/255,
//                                          green: 255/255,
//                                           blue: 150/255,
//                                          alpha: 1.0)
    static let WarningColor       = UIColor(red: 23/255,
                                          green: 157/255,
                                           blue: 172/255,
                                          alpha: 1.0)
    
    static let AlarmColor         = UIColor(red: 30/255,
                                          green: 226/255,
                                           blue: 166/255,
                                          alpha: 1.0)
    
    static let LineWidth              = CGFloat(90) / CGFloat(736)
    static let RingDarkeningFactor    = CGFloat(0.2)
    
    static let ActiveLayoutPriority   = UILayoutPriority(751)
    static let InactiveLayoutPriority = UILayoutPriority(749)
    static let IgnoreLayoutPriority   = UILayoutPriority(1)
  }
  
  var timerViews: TimerViews?
  var timerLabelDisplay: TimerLabelDisplay = .Remaining {
    didSet {
      updateTimerLabels()
    }
  }
  
  
  private var layoutSize: CGSize {
    if let splitViewController = splitViewController {
      return splitViewController.view.frame.size
    } else {
      return view.frame.size
    }
  }
  
  private var layoutIsVertical: Bool {
    return self.layoutSize.width < self.layoutSize.height
  }
  
  private var layoutIsHorizontal: Bool {
    return self.layoutSize.width < self.layoutSize.height
  }
  
 // TODO: The Timer Property should be injected by the SplitViewController
  //       during the segue. Revisit and stop pulling from the app delegate
  var timer: Timer? {
    if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate  {
      return appDelegate.timer
    } else {
      return .None
    }
  }

  // Required on load
  @IBOutlet weak var timerCirclesView: UIView!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var sectionTimeLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var segmentLabel: UILabel!
  @IBOutlet weak var flashImageView: UIImageView!
  @IBOutlet weak var startPauseButton: PlayPauseButton!
  @IBOutlet weak var nextSegmentButton: NextSegmentButton!
  
  // Vertical Layout
  @IBOutlet weak var vCirclesCenteredX: NSLayoutConstraint!
  @IBOutlet weak var vControlsCenteredX: NSLayoutConstraint!
  @IBOutlet weak var vCirclesToContainerTop: NSLayoutConstraint!
  @IBOutlet weak var vCirclesToControls: NSLayoutConstraint!
  @IBOutlet weak var vControlsToContainerBottom: NSLayoutConstraint!
  @IBOutlet weak var vCirclesWidth: NSLayoutConstraint!
  @IBOutlet weak var vControlsWidth: NSLayoutConstraint!
  var verticalContraints: [NSLayoutConstraint] = []
  
  // Horizontal Layout
  @IBOutlet weak var hCirclesCenteredY: NSLayoutConstraint!
  @IBOutlet weak var hControlsCenteredY: NSLayoutConstraint!
  @IBOutlet weak var hCirclesToContainerLeading: NSLayoutConstraint!
  @IBOutlet weak var hCirclesToControls: NSLayoutConstraint!
  @IBOutlet weak var hControlsToContainerTrailing: NSLayoutConstraint!
  @IBOutlet weak var hCirclesHeight: NSLayoutConstraint!
  @IBOutlet weak var hControlsHeight: NSLayoutConstraint!
  var horizontalContraints: [NSLayoutConstraint] = []
  
  
  override func viewDidLoad() {
    verticalContraints = [vCirclesCenteredX,
                          vControlsCenteredX,
                          vCirclesToContainerTop,
                          vCirclesToControls,
                          vControlsToContainerBottom,
                          vCirclesWidth,
                          vControlsWidth]
    
    
    horizontalContraints = [hCirclesCenteredY,
                            hControlsCenteredY,
                            hCirclesToContainerLeading,
                            hCirclesToControls,
                            hControlsToContainerTrailing,
                            hCirclesHeight,
                            hControlsHeight]
                            
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
//    nextSegmentButton.lineColor = Constants.GeekSpeakBlueColor
    nextSegmentButton.tintColor = Constants.GeekSpeakBlueColor
//    startPauseButton.lineColor  = Constants.GeekSpeakBlueColor
    startPauseButton.tintColor  = Constants.GeekSpeakBlueColor
    
    if let timer = timer {
      setupButtonLayout(timer)
    }
    
    setupTimeLabelContraints(totalTimeLabel)
    setupTimeLabelContraints(sectionTimeLabel)
    setupDescriptionLabelContraints(totalLabel)
    setupDescriptionLabelContraints(segmentLabel)
    
    let breakView  = PieShapeView()
    breakView.opaque     = false
    breakView.startAngle = Rotation(degrees: 0)
    breakView.endAngle   = Rotation(degrees: 0)
    breakView.color      = Constants.BreakColor
    breakView.pieLayer.clipToCircle = true
    timerCirclesView.addSubview(breakView)
    
    let ring1bg   = configureBGRing( RingView(),
                          withColor: Constants.GeekSpeakBlueColor)
    let ring1fg   = configureFGRing( RingView(),
                          withColor: Constants.GeekSpeakBlueColor)
    
    let ring2bg   = configureBGRing( RingView(),
                          withColor: Constants.GeekSpeakBlueColor)
    let ring2fg   = configureFGRing( RingView(),
                          withColor: Constants.GeekSpeakBlueColor)
    
    let ring3bg   = configureBGRing( RingView(),
                          withColor: Constants.GeekSpeakBlueColor)
    let ring3fg   = configureFGRing( RingView(),
                          withColor: Constants.GeekSpeakBlueColor)
    
    ring3bg.percentageOfSuperviewSize = 0.95
    ring3fg.percentageOfSuperviewSize = 0.95
    ring2bg.percentageOfSuperviewSize = 0.64
    ring2fg.percentageOfSuperviewSize = 0.64
    ring1bg.percentageOfSuperviewSize = 0.33
    ring1fg.percentageOfSuperviewSize = 0.33

    timerViews = TimerViews(  ring1bg: ring1bg,
                              ring1fg: ring1fg,
                              ring2bg: ring2bg,
                              ring2fg: ring2fg,
                              ring3bg: ring3bg,
                              ring3fg: ring3fg,
                                 fill: breakView)
    
    if let navigationController = navigationController {
      Appearance.appearanceForNavigationController( navigationController,
                                       transparent: true)
    }
    registerForTimerNotifications()
    timerUpdatedTime()
    timerChangedCountingStatus()
    timerDurationChanged()
    layoutViewsForSize(layoutSize)
    startPauseButton.percentageOfSuperviewSize = CGFloat(0.1)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

  }
  
  
  override func viewDidDisappear(animated: Bool) {
    unregisterForTimerNotifications()
  }
  
  override func viewWillTransitionToSize(size: CGSize,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    
    let duration = coordinator.transitionDuration()
    layoutViewsForSize(size, animateWithDuration: duration)
          
          
   // MARK: Manage SPlitViewContoller preferedDisplayMode
//    if let svc = splitViewController {
//      if svc.collapsed {
//        println("collapsed: \(svc.preferredDisplayMode == .Automatic)")
//      } else {
//        println("not collapsed: \(svc.preferredDisplayMode == .Automatic)")
//      }
//    }
  }
  
  
  
  
  
  // MARK: -
  // MARK: ViewController
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }


  

  
  // MARK: -
  // MARK: Actions
  @IBAction func showSettingsButtonPressed(sender: UIBarButtonItem) {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.pressButtonBarItem()
  }
  
  @IBAction func nextSegmentButtonPressed(sender: NextSegmentButton) {
    timer?.next()
  }
  
  var startPauseButtonCount: Int = 0
  @IBAction func startPauseButtonPressed(sender: PlayPauseButton) {
    startPauseButtonCount++
    if let timer = timer {
      switch timer.state {
      case .Ready,
           .Paused,
           .PausedAfterComplete:
        timer.start()
      case .Counting,
           .CountingAfterComplete:
        timer.pause()
      }
    }
  }
  
  func setupButtonLayout(timer: Timer) {
    switch timer.state {
    case .Ready,
         .Paused,
         .PausedAfterComplete:
      startPauseButton.showPlayView()
    
    case .Counting,
      .CountingAfterComplete:
      startPauseButton.showPauseView()
      
    }
  }

  
  func updateButtonLayout(timer: Timer) {
    switch timer.state {
    case .Ready,
         .Paused,
         .PausedAfterComplete:
      if startPauseButtonCount > 0 {
        startPauseButton.animateToPlayView()
      } else {
        startPauseButton.showPlayView()
      }
      
    case .Counting,
         .CountingAfterComplete:
      if startPauseButtonCount > 0 {
        startPauseButton.animateToPauseView()
      } else {
        startPauseButton.showPauseView()
      }
      
    }
    startPauseButtonCount--
    startPauseButtonCount = max(0,startPauseButtonCount)
  }
  
  
  
  
  
  // MARK: -
  // MARK: View Layout
  
  
  func layoutViewsForSize( size: CGSize) {
    layoutViewsForSize(size, animateWithDuration: 0.0)
  }
      
  
  func layoutViewsForSize(          size: CGSize,
            animateWithDuration duration: NSTimeInterval) {

    view.layoutIfNeeded()
    UIView.animateWithDuration(duration, animations: {
      if size.width < size.height {
        self.setContraintPriorityForVerticalLayout()
      } else {
        self.setContraintPriorityForHorizontalLayout()
      }
      self.view.layoutIfNeeded()
    })
  }
  
  func hideNextButtonWithDuration(duration: NSTimeInterval) {

    view.layoutIfNeeded()

    func animated() {
      self.nextSegmentButton.alpha = 0.0
      self.view.layoutIfNeeded()
    }
    
    
    func notAnimated(completed: Bool) {
      self.view.layoutIfNeeded()
      self.nextSegmentButton.hidden  = true
      self.nextSegmentButton.enabled = false
    }

      UIView.animateWithDuration( duration,
        animations: animated,
        completion: notAnimated)
  }

  
  
  
  
  func showNextButtonWithDuration(duration: NSTimeInterval) {

    view.layoutIfNeeded()
    self.nextSegmentButton.hidden  = false
    self.nextSegmentButton.enabled = true
    
    func animated() {
      self.nextSegmentButton.alpha = 1.0
      self.view.layoutIfNeeded()
    }
    
    
    func notAnimated(completed: Bool) {
      self.view.layoutIfNeeded()
    }
    
      UIView.animateWithDuration( duration,
        animations: animated,
        completion: notAnimated)
  }
  
  
  
  
  
  func setContraintPriorityForVerticalLayout() {
    verticalContraints.map(    activateContraint )
    horizontalContraints.map(deactivateContraint )
  }
  
  func setContraintPriorityForHorizontalLayout() {
    verticalContraints.map(  deactivateContraint )
    horizontalContraints.map(  activateContraint )
  }
  
  func activateContraint(constraint: NSLayoutConstraint) {
    if constraint.priority == Constants.InactiveLayoutPriority {
      activateIgnoredContraint(constraint)
    }
  }
  
  func deactivateContraint(constraint: NSLayoutConstraint) {
    if constraint.priority == Constants.ActiveLayoutPriority {
      deactivateIgnoredContraint(constraint)
    }
  }
  
  func activateIgnoredContraint(constraint: NSLayoutConstraint) {
    constraint.priority = Constants.ActiveLayoutPriority
  }
  
  func deactivateIgnoredContraint(constraint: NSLayoutConstraint) {
    constraint.priority = Constants.InactiveLayoutPriority
  }
  
  func ignoreContraint(constraint: NSLayoutConstraint) {
    constraint.priority = Constants.IgnoreLayoutPriority
  }
  
  
  
  // MARK: -
  // MARK: Warning Animation
  
  var warningDuration = NSTimeInterval(0.75)
  private var warningStartTime = NSDate().timeIntervalSince1970
  private var warningAnimationInProgress = false

  func animateWarning() {
    if !warningAnimationInProgress {
      warningStartTime = NSDate().timeIntervalSince1970
      warningAnimationInProgress = true
      flashImageView.alpha = 0.0
      animateBlackToWhite()
    }
  }
  
  func animateBlackToWhite() {
    UIView.animateWithDuration( 0.05,
      delay: 0.0,
      options: nil,
      animations: {
        self.flashImageView.alpha = 1.0
        self.view.backgroundColor = Constants.BreakColor
      },
      completion: { completed in
        if (self.warningStartTime + self.warningDuration) > NSDate().timeIntervalSince1970 {
          self.animateWhiteToBlack()
        } else {
          self.warningAnimationInProgress = false
          self.view.backgroundColor = UIColor.blackColor()
          self.flashImageView.alpha = 0.0
        }
    })
  }
  
  func animateWhiteToBlack() {
    UIView.animateWithDuration( 0.05,
      delay: 0.0,
      options: nil,
      animations: {
        self.flashImageView.alpha = 0.0
        self.view.backgroundColor = UIColor.blackColor()
      },
      completion: { completed in
        if (self.warningStartTime + self.warningDuration) > NSDate().timeIntervalSince1970 {
          self.animateBlackToWhite()
        } else {
          self.warningAnimationInProgress = false
          self.view.backgroundColor = UIColor.blackColor()
          self.flashImageView.alpha = 0.0
        }
    })
  }
  
  
  
  // MARK: -
  // MARK: Setup
  func configureFGRing(ringView: RingView, withColor color: UIColor)
                                                                   -> RingView {
                                                                    
    ringView.color      = color
    ringView.startAngle = Rotation(degrees: 0)
    ringView.endAngle   = Rotation(degrees: 0)
    configureRing(ringView)
    return ringView
  }
  
  func configureBGRing(ringView: RingView, withColor color: UIColor)
                                                                   -> RingView {
    let darkenBy = Constants.RingDarkeningFactor
    ringView.color     = color.darkenColorWithMultiplier(darkenBy)
    configureRing(ringView)
    return ringView
  }
  
  func configureRing(ringView: RingView) {
    ringView.ringWidth = Constants.LineWidth
    ringView.viewSize  = {[weak timerCirclesView] in
                            if let timerCirclesView = timerCirclesView {
                              return min(timerCirclesView.bounds.height,
                                         timerCirclesView.bounds.width)
                            } else {
                              return .None
                            }
                          }
    timerCirclesView.addSubview(ringView)
    ringView.opaque              = false
  }

  func setupTimeLabelContraints(label: UILabel) {
    
    let width =  NSLayoutConstraint(item: label,
                               attribute: .Width,
                               relatedBy: .Equal,
                                  toItem: label.superview,
                               attribute: .Width,
                              multiplier: 199 / 736,
                                constant: 0.0)
    width.priority = 1000
    label.superview?.addConstraint(width)
    
  }
  
  func setupDescriptionLabelContraints(label: UILabel) {
    if let labelSuperView = label.superview {
          let height =  NSLayoutConstraint(item: label,
                                      attribute: .Height,
                                      relatedBy: .Equal,
                                         toItem: labelSuperView,
                                      attribute: .Height,
                                     multiplier: 20 / 736,
                                       constant: 0.0)
      height.priority = 1000
      labelSuperView.addConstraint(height)
    }
  }
  
  
  
  // MARK: -
  // MARK: Utility
  enum Direction {
    case Left
    case Right
  }
  
  func padString(var string: String,
                totalLength: Int, pad: Character,
      inDirection direction: Direction) -> String {
        
    var i = 0
    for character in string {
      i++
    }
    
    let amountToPad = totalLength - i
    if amountToPad < 1 {
      return string
    }
    let padString = String(pad)
    for _ in 1...amountToPad {
      switch direction {
        case .Left:
          string = string + padString
        case .Right:
          string = padString + string
      }
    }
    return string
  }

  
  
  // MARK: Manage SPlitViewContoller preferedDisplayMode
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    if let svc = splitViewController  {
      if svc.collapsed {
        println("    collapsed (timer view controller)")
        //        return .Automatic
      } else {
        println("not collapsed (timer view controller)")
        //        return .PrimaryOverlay
      }
    }
  }


}

