import UIKit


enum TimerLabelDisplay: String, CustomStringConvertible {
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
    
    static let GeekSpeakBlueInactiveColor = UIColor(red: 14/255,
                                                  green: 115/255,
                                                   blue: 115/255,
                                                  alpha: 0.2)
    
    static let BreakColor         = UIColor(red: 0.75,
                                          green: 0.0,
                                           blue: 0.0,
                                          alpha: 1.0)
    
    static let WarningColor       = UIColor(red: 23/255,
                                          green: 157/255,
                                           blue: 172/255,
                                          alpha: 1.0)
    
    static let AlarmColor         = UIColor(red: 30/255,
                                          green: 226/255,
                                           blue: 166/255,
                                          alpha: 1.0)
    
    static let LineWidth              = (CGFloat(90) / CGFloat(736)) * (1 / 0.95) * 2
    static let RingDarkeningFactor    = CGFloat(1.0)
    
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
    return view.frame.size
  }
  
  private var layoutIsVertical: Bool {
    return self.layoutSize.width < self.layoutSize.height
  }
  
  private var layoutIsHorizontal: Bool {
    return self.layoutSize.width < self.layoutSize.height
  }
  
  var timer: Timer?
  
  // Required on load
  @IBOutlet weak var timerCirclesView: UIView!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var sectionTimeLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var segmentLabel: UILabel!
  @IBOutlet weak var flashImageView: UIImageView!
  @IBOutlet weak var backButton: BackButton!
  @IBOutlet weak var startPauseButton: PlayPauseButton!
  @IBOutlet weak var nextSegmentButton: NextSegmentButton!
  
  @IBOutlet weak var containerStackView: UIStackView!
  @IBOutlet weak var controlsStackView: UIStackView!
  
  
  override func viewDidLoad() {
    addSwipeGesture()
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    nextSegmentButton.tintColor = Constants.GeekSpeakBlueColor
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
    breakView.startAngle = TauAngle(degrees: 0)
    breakView.endAngle   = TauAngle(degrees: 0)
    breakView.color      = Constants.BreakColor
    breakView.pieLayer.clipToCircle = true
    timerCirclesView.addSubview(breakView)
    
    let ring1bg   = configureBGRing( RingView(),
                          withColor: Constants.GeekSpeakBlueInactiveColor)
    let ring1fg   = configureFGRing( RingView(),
                          withColor: Constants.GeekSpeakBlueColor)
    
    let ring2bg   = configureBGRing( RingView(),
                          withColor: Constants.GeekSpeakBlueInactiveColor)
    let ring2fg   = configureFGRing( RingView(),
                          withColor: Constants.GeekSpeakBlueColor)
    
    let ring3bg   = configureBGRing( RingView(),
                          withColor: Constants.GeekSpeakBlueInactiveColor)
    let ring3fg   = configureFGRing( RingView(),
                          withColor: Constants.GeekSpeakBlueColor)
    
    ring3bg.fillScale = 0.95
    ring3fg.fillScale = 0.95
    ring2bg.fillScale = 0.64
    ring2fg.fillScale = 0.64
    ring1bg.fillScale = 0.33
    ring1fg.fillScale = 0.33

    
    timerViews = TimerViews(  ring1bg: ring1bg,
                              ring1fg: ring1fg,
                              ring2bg: ring2bg,
                              ring2fg: ring2fg,
                              ring3bg: ring3bg,
                              ring3fg: ring3fg,
                                 fill: breakView)
    
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
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    
    let duration = coordinator.transitionDuration()
    layoutViewsForSize(size, animateWithDuration: duration)
          
  }
  
  
  
  
  
  
  // MARK: -
  // MARK: ViewController
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }


  

  
  // MARK: -
  // MARK: Actions
  @IBAction func backButtonPressed(sender: AnyObject) {
    if let primaryViewController = parentViewController
                                                     as? PrimaryViewController {
                                                  
      primaryViewController.presentMenuViewController()
    }
  }
  
  @IBAction func nextSegmentButtonPressedToo(sender: NextSegmentButton) {
    timer?.next()
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

    if size.width < size.height {
      self.setContraintsForVerticalLayout()
    } else {
      self.setContraintsForHorizontalLayout()
    }
  }
  
  func setContraintsForVerticalLayout() {
    containerStackView.axis = .Vertical
    controlsStackView.axis = .Horizontal
  }
  
  func setContraintsForHorizontalLayout() {
    containerStackView.axis = .Horizontal
    controlsStackView.axis = .Vertical
  }
  
  // MARK: -
  // MARK: Gestures
  
  func addSwipeGesture() {
    let gesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                action: "panGestureRecognized:")
    gesture.edges = .Left
    view.addGestureRecognizer(gesture)
  }
  
  func panGestureRecognized(sender: UIPanGestureRecognizer) {
    guard let primaryViewController = UIApplication.sharedApplication()
                 .keyWindow?.rootViewController as? PrimaryViewController else {
      assertionFailure("Could not find PrimaryViewController as root View controller")
      return
    }

    primaryViewController.panGestureRecognized(sender)
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
      options: [],
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
      options: [],
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
                                                                    
    ringView.color          = color
    ringView.startAngle     = TauAngle(degrees: 0)
    ringView.endAngle       = TauAngle(degrees: 0)
    ringView.ringStyle      = .Rounded
    configureRing(ringView)
    return ringView
  }
  
  func configureBGRing(ringView: RingView, withColor color: UIColor)
                                                                   -> RingView {
    let darkenBy = Constants.RingDarkeningFactor
    ringView.color          = color.darkenColorWithMultiplier(darkenBy)
    ringView.startAngle     = TauAngle(degrees: 0)
    ringView.endAngle       = TauAngle(degrees: 360)
    ringView.ringStyle      = .Sharp

    configureRing(ringView)
    return ringView
  }
  
  func configureRing(ringView: RingView) {
    ringView.ringWidth = Constants.LineWidth
    timerCirclesView.addSubview(ringView)
    ringView.opaque              = false
  }

  func setupTimeLabelContraints(label: UILabel) {
    
    let width =  NSLayoutConstraint(item: label,
                               attribute: .Width,
                               relatedBy: .Equal,
                                  toItem: label.superview,
                               attribute: .Width,
                              multiplier: 160 / 736,
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
        
    let i = string.characters.count
    
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

  

}

