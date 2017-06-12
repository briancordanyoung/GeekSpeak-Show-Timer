import UIKit
import AngleGear
import TimerViewsGear


enum TimerLabelDisplay: String, CustomStringConvertible {
  case Remaining = "Remaining"
  case Elapsed   = "Elapsed"
  
  var description: String {
    return self.rawValue
  }
}

final class TimerViewController: UIViewController {
  
  var timer: Timer?
  var timerViews: TimerViews?
  var timerLabelDisplay: TimerLabelDisplay = .Remaining {
    didSet {
      updateTimerLabels()
    }
  }
  
  
  fileprivate var layoutSize: CGSize {
    return view.frame.size
  }
  
  fileprivate var layoutIsVertical: Bool {
    return self.layoutSize.width < self.layoutSize.height
  }
  
  fileprivate var layoutIsHorizontal: Bool {
    return self.layoutSize.width < self.layoutSize.height
  }
  
  
  // Required on load
  @IBOutlet weak var timerCirclesView: UIView!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var sectionTimeLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var segmentLabel: UILabel!
  @IBOutlet weak var flashImageView: UIImageView!
  @IBOutlet weak var backButton: BackButton!
  @IBOutlet weak var backView: BackView!
  @IBOutlet weak var startPauseButton: StartPauseButton!
  @IBOutlet weak var nextButton: NextButton!
  @IBOutlet weak var nextButtonTimerOverlay: NextButton!
  
  @IBOutlet weak var containerStackView: UIStackView!
  @IBOutlet weak var controlsStackView: UIStackView!
  
  @IBOutlet weak var activityView: ActivityView!

  
  fileprivate var controlsInOrder: [UIButton] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    controlsInOrder = [startPauseButton, nextButton]
    activityView.fillColor = Appearance.Constants.GeekSpeakBlueColor
    addSwipeGesture()
    setupBackButton()
    setupStartPauseButton()
    setupNextButton()
  }

  
  
  // MARK: -
  // MARK: Setup
  
  func setupBackButton() {
    backButton.backView = backView
    backView.unhighlight()
  }
  
  
  func setupNextButton() {
    let geekSpeakBlueColor = Appearance.Constants.GeekSpeakBlueColor

    let nextView = NextView()
    nextView.highlightColor = geekSpeakBlueColor
    nextView.tintColor      = geekSpeakBlueColor
    view.insertSubview( nextView,
          belowSubview: containerStackView)
    
    centerView( nextView,
                     ToView: nextButton,
        WithContraintParent: view)
    
    nextButton.nextView = nextView
    nextButtonTimerOverlay.nextView = nextView
  }
  
  
  func setupStartPauseButton() {
    let geekSpeakBlueColor = Appearance.Constants.GeekSpeakBlueColor

    let startPauseView = StartPauseView()
    startPauseView.highlightColor = geekSpeakBlueColor
    startPauseView.tintColor      = geekSpeakBlueColor
    view.insertSubview( startPauseView,
          belowSubview: containerStackView)
    
    centerView( startPauseView,
                     ToView: startPauseButton,
        WithContraintParent: view)
    
    startPauseButton.startPauseView = startPauseView
    
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    
    if let timer = timer {
      setupButtonLayout(timer)
    }
    
    setupTimeLabelContraints(totalTimeLabel)
    setupTimeLabelContraints(sectionTimeLabel)
    setupDescriptionLabelContraints(totalLabel)
    setupDescriptionLabelContraints(segmentLabel)
    
    let breakView  = BreakView()
    breakView.fillColor  = Appearance.Constants.BreakColor
    timerCirclesView.addSubview(breakView)
    
    let ring1bg   = configureBGRing( RingView(),
                          withColor: Appearance
                                          .Constants.GeekSpeakBlueInactiveColor)
    let ring1fg   = configureFGRing( RingView(),
                          withColor: Appearance.Constants.GeekSpeakBlueColor)
    
    let ring2bg   = configureBGRing( RingView(),
                          withColor: Appearance
                                          .Constants.GeekSpeakBlueInactiveColor)
    let ring2fg   = configureFGRing( RingView(),
                          withColor: Appearance.Constants.GeekSpeakBlueColor)
    
    let ring3bg   = configureBGRing( RingView(),
                          withColor: Appearance
                                          .Constants.GeekSpeakBlueInactiveColor)
    let ring3fg   = configureFGRing( RingView(),
                          withColor: Appearance.Constants.GeekSpeakBlueColor)
    
    ring3bg.fillScale = 0.95
    ring3fg.fillScale = 0.95
    ring2bg.fillScale = 0.64
    ring2fg.fillScale = 0.64
    ring1bg.fillScale = 0.00
    ring1fg.fillScale = 0.00

    
    timerViews = TimerViews(  ring1bg: ring1bg,
                              ring1fg: ring1fg,
                              ring2bg: ring2bg,
                              ring2fg: ring2fg,
                              ring3bg: ring3bg,
                              ring3fg: ring3fg,
                            breakView: breakView)
    
    registerForTimerNotifications()
    displayAllTime()
    timerUpdatedTime()
    timerChangedCountingStatus()
    timerDurationChanged()
    layoutViewsForSize(layoutSize)
    
    
  }
  
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

  }
  
  
  override func viewDidDisappear(_ animated: Bool) {
    unregisterForTimerNotifications()
  }
  
  override func viewWillTransition(to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    let duration = coordinator.transitionDuration
    layoutViewsForSize(size, animateWithDuration: duration)
          
  }
  
  
  
  
  
  
  // MARK: -
  // MARK: ViewController
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  
  // MARK: -
  // MARK: Actions
  @IBAction func backButtonPressed(_ sender: AnyObject) {
    if let primaryViewController = parent
                                                     as? PrimaryViewController {
                                                  
      primaryViewController.presentMenuViewController()
    }
  }
  
  @IBAction func nextButtonPressed(_ sender: NextButton) {
    timer?.next()
  }
  
  
  @IBAction func startPauseButtonPressed(_ sender: StartPauseButton) {
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
  
  func setupButtonLayout(_ timer: Timer) {
    switch timer.state {
    case .Ready,
         .Paused,
         .PausedAfterComplete:
      startPauseButton.startPauseView?.label.text = "Start Timer"
      startPauseButton.startPauseView?.currentButton = .start
      startPauseButton.startPauseView?.unhighlight()
      
    case .Counting,
         .CountingAfterComplete:
      startPauseButton.startPauseView?.label.text = "Pause Timer"
      startPauseButton.startPauseView?.currentButton = .pause
      startPauseButton.startPauseView?.unhighlight()
    }
    
    setNextButtonState(timer)
  }

  
  func updateButtonLayout(_ timer: Timer) {
    // StartPause Button
    switch timer.state {
    case .Ready,
         .Paused,
         .PausedAfterComplete:
      startPauseButton.startPauseView?.label.text = "Start Timer"
    case .Counting,
         .CountingAfterComplete:
      startPauseButton.startPauseView?.label.text = "Pause Timer"
    }
    
    if timer.state == .Ready {
      startPauseButton.startPauseView?.currentButton = .start
      startPauseButton.startPauseView?.unhighlight()
    }
    
    setNextButtonState(timer)
  }
  
  func setNextButtonState(_ timer: Timer) {
    // Next Button
    switch timer.state {
    case .Ready,
         .PausedAfterComplete,
         .CountingAfterComplete:
      disableNextButton()
    case .Counting,
         .Paused:
      enableNextButton()
    }
  }
  
  
  func disableNextButton() {
    let inactiveColor = Appearance.Constants.GeekSpeakBlueInactiveColor
    nextButton.isEnabled = false
    nextButtonTimerOverlay.isEnabled = false
    nextButton.nextView?.tintColor       = inactiveColor
    nextButton.nextView?.highlightColor  = inactiveColor
    nextButton.nextView?.label.textColor = inactiveColor
    nextButton.nextView?.highlight()
  }
  
  func enableNextButton() {
    let activeColor = Appearance.Constants.GeekSpeakBlueColor
    nextButton.isEnabled = true
    nextButtonTimerOverlay.isEnabled = true
    nextButton.nextView?.tintColor       = activeColor
    nextButton.nextView?.highlightColor  = activeColor
    nextButton.nextView?.label.textColor = activeColor
    nextButton.nextView?.unhighlight()
  }
  
  
  // MARK: -
  // MARK: View Layout
  
  
  func layoutViewsForSize( _ size: CGSize) {
    layoutViewsForSize(size, animateWithDuration: 0.0)
  }
      
  
  func layoutViewsForSize(          _ size: CGSize,
            animateWithDuration duration: TimeInterval) {

    if size.width < size.height {
      self.setContraintsForVerticalLayout()
    } else {
      self.setContraintsForHorizontalLayout()
    }
  }
  
  func setContraintsForVerticalLayout() {
    containerStackView.axis = .vertical
    controlsStackView.axis = .horizontal
    flipControlViews(controlsInOrder)
  }
  
  func setContraintsForHorizontalLayout() {
    containerStackView.axis = .horizontal
    controlsStackView.axis = .vertical
    flipControlViews(controlsInOrder.reversed())
  }
  
  func flipControlViews(_ controls : [UIButton]) {
    let arrangedViews = controlsStackView.arrangedSubviews.reversed()
    arrangedViews.forEach {controlsStackView.removeArrangedSubview($0)}
    controls.forEach {controlsStackView.addArrangedSubview($0)}
  }
  
  
  func centerView(_ view: UIView, ToView toView: UIView, WithContraintParent parent: UIView) {
    
    let y =      NSLayoutConstraint(item: view,
                               attribute: .centerY,
                               relatedBy: .equal,
                                  toItem: toView,
                               attribute: .centerY,
                              multiplier: 1.0,
                                constant: 0.0)

    let x =      NSLayoutConstraint(item: view,
                               attribute: .centerX,
                               relatedBy: .equal,
                                  toItem: toView,
                               attribute: .centerX,
                              multiplier: 1.0,
                                constant: 0.0)
    parent.addConstraints([x,y])
  }

  
  
  
  
  
  // MARK: -
  // MARK: Gestures
  
  func addSwipeGesture() {
    let gesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                action: #selector(TimerViewController.panGestureRecognized(_:)))
    gesture.edges = .left
    view.addGestureRecognizer(gesture)
  }
  
  func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
    guard let primaryViewController = UIApplication.shared
                 .keyWindow?.rootViewController as? PrimaryViewController else {
      assertionFailure("Could not find PrimaryViewController as root View controller")
      return
    }

    primaryViewController.panGestureRecognized(sender)
  }

  

  
  // MARK: -
  // MARK: Warning Animation
  
  var warningDuration = TimeInterval(0.75)
  fileprivate var warningStartTime = Date().timeIntervalSince1970
  fileprivate var warningAnimationInProgress = false

  func animateWarning() {
    if !warningAnimationInProgress {
      warningStartTime = Date().timeIntervalSince1970
      warningAnimationInProgress = true
      flashImageView.alpha = 0.0
      animateBlackToWhite()
    }
  }
  
  func animateBlackToWhite() {
    UIView.animate( withDuration: 0.05,
      delay: 0.0,
      options: [],
      animations: {
        self.flashImageView.alpha = 1.0
        self.view.backgroundColor = Appearance.Constants.BreakColor
      },
      completion: { completed in
        if (self.warningStartTime + self.warningDuration) > Date().timeIntervalSince1970 {
          self.animateWhiteToBlack()
        } else {
          self.warningAnimationInProgress = false
          self.view.backgroundColor = UIColor.black
          self.flashImageView.alpha = 0.0
        }
    })
  }
  
  func animateWhiteToBlack() {
    UIView.animate( withDuration: 0.05,
      delay: 0.0,
      options: [],
      animations: {
        self.flashImageView.alpha = 0.0
        self.view.backgroundColor = UIColor.black
      },
      completion: { completed in
        if (self.warningStartTime + self.warningDuration) > Date().timeIntervalSince1970 {
          self.animateBlackToWhite()
        } else {
          self.warningAnimationInProgress = false
          self.view.backgroundColor = UIColor.black
          self.flashImageView.alpha = 0.0
        }
    })
  }
  
  
  
  // MARK: -
  // MARK: Setup
  func configureFGRing(_ ringView: RingView, withColor color: UIColor)
                                                                   -> RingView {
                                                                    
    ringView.color          = color
    ringView.startAngle     = TauAngle(degrees: 0)
    ringView.endAngle       = TauAngle(degrees: 0)
    ringView.ringStyle      = .rounded
    configureRing(ringView)
    return ringView
  }
  
  func configureBGRing(_ ringView: RingView, withColor color: UIColor)
                                                                   -> RingView {
    let darkenBy = Appearance.Constants.RingDarkeningFactor
    ringView.color          = color.darkenColorWithMultiplier(darkenBy)
    ringView.startAngle     = TauAngle(degrees: 0)
    ringView.endAngle       = TauAngle(degrees: 360)
    ringView.ringStyle      = .sharp

    configureRing(ringView)
    return ringView
  }
  
  func configureRing(_ ringView: RingView) {
    ringView.ringWidth = Appearance.Constants.RingWidth
    timerCirclesView.addSubview(ringView)
    ringView.isOpaque              = false
  }

  func setupTimeLabelContraints(_ label: UILabel) {
    
    let width =  NSLayoutConstraint(item: label,
                               attribute: .width,
                               relatedBy: .equal,
                                  toItem: label.superview,
                               attribute: .width,
                              multiplier: 160 / 736,
                                constant: 0.0)
    width.priority = 1000
    label.superview?.addConstraint(width)
    
  }
  
  func setupDescriptionLabelContraints(_ label: UILabel) {
    if let labelSuperView = label.superview {
          let height =  NSLayoutConstraint(item: label,
                                      attribute: .height,
                                      relatedBy: .equal,
                                         toItem: labelSuperView,
                                      attribute: .height,
                                     multiplier: 20 / 736,
                                       constant: 0.0)
      height.priority = 1000
      labelSuperView.addConstraint(height)
    }
  }
  
  
}

