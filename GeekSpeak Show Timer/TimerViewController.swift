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
    static let DeemphisisedButtonScale = CGFloat(0.5)
    static let EmphisisedButtonScale   = CGFloat(1.0)
    static let GeekSpeakBlueColor = UIColor(red: 14/255,
                                          green: 115/255,
                                           blue: 192/255,
                                          alpha: 1.0)
    
    static let BreakColor         = UIColor(red: 0.75,
                                          green: 0.0,
                                           blue: 0.0,
                                          alpha: 1.0)
    
    static let WarningColor       = UIColor(red: 13/255,
                                          green: 255/255,
                                           blue: 179/255,
                                          alpha: 1.0)
    
    static let AlarmColor         = UIColor(red: 255/255,
                                          green: 255/255,
                                           blue: 150/255,
                                          alpha: 1.0)
    
    static let LineWidth          = CGFloat(90) / CGFloat(736)
  }
  
  var timerViews: TimerViews?
  var timerLabelDisplay: TimerLabelDisplay = .Remaining {
    didSet {
      updateTimerLabels()
    }
  }
  
  // TODO: The Timer Property should be injected by the SplitViewController
  //       during the segue. Revisit and stop pulling from other view controller
  var timer: Timer? {
    if let splitViewController = splitViewController as? TimerSplitViewController {
      return splitViewController.timer
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
  @IBOutlet weak var startPauseButton: PlayPauseButton!
  @IBOutlet weak var nextSegmentButton: NextSegmentButton!
  
  // Vertical Layout
  @IBOutlet weak var timerCirclesWidth: NSLayoutConstraint!
  @IBOutlet weak var startButtonToTimerCircle: NSLayoutConstraint!
  @IBOutlet weak var startButtonToSuperView: NSLayoutConstraint!
  @IBOutlet weak var buttonsEqualWidth: NSLayoutConstraint!
  @IBOutlet weak var nextButtonToStartButtonSpace: NSLayoutConstraint!
  @IBOutlet weak var nextButtonToTimerCircles: NSLayoutConstraint!
  @IBOutlet weak var nextButtonToSuperViewSide: NSLayoutConstraint!
  @IBOutlet weak var startButtonToBottom: NSLayoutConstraint!
  @IBOutlet weak var nextButtonToBottom: NSLayoutConstraint!
  var verticalContraints: [NSLayoutConstraint] = []
  
  // Horizontal Layout
  @IBOutlet weak var startButtonToTimerCircleHorizontal: NSLayoutConstraint!
  @IBOutlet weak var startButtonToSuperViewHorizontal: NSLayoutConstraint!
  @IBOutlet weak var buttonsEqualHeight: NSLayoutConstraint!
  @IBOutlet weak var nextButtonToStartButtonHorizontal: NSLayoutConstraint!
  @IBOutlet weak var startButtonToSuperViewTop: NSLayoutConstraint!
  @IBOutlet weak var nextButtonToSuperViewSideHorizontal: NSLayoutConstraint!
  @IBOutlet weak var nextButtonToTimerCircle: NSLayoutConstraint!
  @IBOutlet weak var nextButtonToBottomHorizontal: NSLayoutConstraint!
  @IBOutlet weak var timerCirclesHeight: NSLayoutConstraint!
  var horizontalContraints: [NSLayoutConstraint] = []
  
  
  @IBOutlet weak var playImage: UIImageView!
  @IBOutlet weak var pauseImage: UIImageView!
  @IBOutlet weak var skipImage: UIImageView!
  
  override func viewDidLoad() {    
    verticalContraints = [startButtonToTimerCircle,
                          startButtonToSuperView,
                          buttonsEqualWidth,
                          nextButtonToStartButtonSpace,
                          nextButtonToTimerCircles,
                          nextButtonToSuperViewSide,
                          startButtonToBottom,
                          nextButtonToBottom,
                          timerCirclesWidth]
    
    horizontalContraints = [startButtonToTimerCircleHorizontal,
                            startButtonToSuperViewHorizontal,
                            buttonsEqualHeight,
                            nextButtonToStartButtonHorizontal,
                            startButtonToSuperViewTop,
                            nextButtonToSuperViewSideHorizontal,
                            nextButtonToTimerCircle,
                            nextButtonToBottomHorizontal,
                            timerCirclesHeight]
    super.viewDidLoad()
    
    
    if let timer = timer {
      displayPlayPauseButton(timer)
    }
    
  }
  
  override func viewWillAppear(animated: Bool) {
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
    if let splitViewController = splitViewController {
      layoutViewsForSize(splitViewController.view.frame.size)
    } else {
      layoutViewsForSize(view.frame.size)
    }
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
  }
  
  
  
  
  
  // MARK: -
  // MARK: ViewController
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }


  

  
  // MARK: -
  // MARK: Actions
  @IBAction func showSettingsButtonPressed(sender: UIBarButtonItem) {
    self.splitViewController?.toggleMasterView()
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
           .Paused:
        timer.start()
      case .Counting:
        timer.pause()
      }
    }
  }
  
  func displayPlayPauseButton(timer: Timer) {
    switch timer.state {
    case .Ready:
      startPauseButton.percentageOfSuperviewSize = Constants.EmphisisedButtonScale
      nextSegmentButton.percentageOfSuperviewSize = Constants.DeemphisisedButtonScale
      if startPauseButtonCount > 0 {
        startPauseButton.animateToPlayView()
      } else {
        startPauseButton.showPlayView()
      }
      
    case .Paused:
      startPauseButton.percentageOfSuperviewSize = Constants.DeemphisisedButtonScale
      nextSegmentButton.percentageOfSuperviewSize = Constants.EmphisisedButtonScale
      if startPauseButtonCount > 0 {
        startPauseButton.animateToPlayView()
      } else {
        startPauseButton.showPlayView()
      }
      
    case .Counting:
      startPauseButton.percentageOfSuperviewSize = Constants.DeemphisisedButtonScale
      nextSegmentButton.percentageOfSuperviewSize = Constants.EmphisisedButtonScale
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
  
  func setContraintPriorityForVerticalLayout() {
    verticalContraints.map(  {$0.priority = 751})
    horizontalContraints.map({$0.priority = 749})
  }
  
  func setContraintPriorityForHorizontalLayout() {
    verticalContraints.map(  {$0.priority = 749})
    horizontalContraints.map({$0.priority = 751})
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
    ringView.color     = color.darkenColorWithMultiplier(0.2)
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

  

}

