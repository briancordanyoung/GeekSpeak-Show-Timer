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
    static let GeekSpeakBlueColor = UIColor(red: 14/255,
                                          green: 115/255,
                                           blue: 192/255,
                                          alpha: 1.0)
    
    static let WarningColor       = UIColor(red: 13/255,
                                          green: 255/255,
                                           blue: 179/255,
                                          alpha: 1.0)
    
    static let AlarmColor         = UIColor(red: 255/255,
                                          green: 255/255,
                                           blue: 150/255,
                                          alpha: 1.0)
  }
  
  var timerViews: TimerViews?
  var timerLabelDisplay: TimerLabelDisplay = .Remaining {
    didSet {
      updateTimerLabels()
    }
  }
  
  // TODO: The Timer Property should be set by the SplitViewController
  //       during the segue. Revisit and stop pulling from other view controller
  var timer: Timer? {
    if let splitViewController = splitViewController as? SplitViewController {
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
  @IBOutlet weak var startPauseButton: UIButton!
  @IBOutlet weak var nextSegmentButton: UIButton!
  
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
  
  
  
  var lineWidth: CGFloat {
    return self.dynamicType.lineWidthForSize(timerCirclesView.frame.size)
  }
  
  
  class func lineWidthForSize(size: CGSize) -> CGFloat {
    let developmentLineWidth    = CGFloat(90)
    let developmentViewWidth    = CGFloat(736)
    let currentViewWidth = (size.width + size.height) / 2
    return (currentViewWidth / developmentViewWidth) * developmentLineWidth
  }
  
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
  }
  
  override func viewWillAppear(animated: Bool) {
    setupTimeLabelContraints(totalTimeLabel)
    setupTimeLabelContraints(sectionTimeLabel)
    setupDescriptionLabelContraints(totalLabel)
    setupDescriptionLabelContraints(segmentLabel)
    styleButtons()
    
    let fillView  = PieShapeView()
    fillView.opaque     = false
    fillView.startAngle = Rotation(degrees: 0)
    fillView.endAngle   = Rotation(degrees: 0)
    fillView.color      = UIColor(red: 0.75, green: 0.0, blue: 0.0, alpha: 1.0)
    fillView.pieLayer.clipToCircle = true
    timerCirclesView.addSubview(fillView)
    
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
                                 fill: fillView)
    
    if let navigationController = navigationController {
      Appearance.appearanceForNavigationController( navigationController,
                                       transparent: true)
      
    }
    registerForTimerNotifications()
    timerUpdatedTime()
    timerChangedCountingStatus()
    timerDurationChanged()
    layoutViewsForSize(view.frame.size)
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
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    timerViews?.layoutSubviewsWithLineWidth(lineWidth)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }


  

  
  // MARK: -
  // MARK: Actions
  @IBAction func showSettingsButtonPressed(sender: UIBarButtonItem) {
    self.splitViewController?.toggleMasterView()
  }
  
  @IBAction func startPauseButtonPressed(sender: UIButton) {
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

  @IBAction func nextSegmentButtonPressed(sender: UIButton) {
    timer?.next()
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
      ringView.endAngle   = Rotation(degrees: 10)
      ringView.ringWidth  = lineWidth
      configureRing(ringView)
      return ringView
  }
  
  func configureBGRing(ringView: RingView, withColor color: UIColor)
                                                                   -> RingView {
      ringView.color     = color.darkenColorWithMultiplier(0.2)
      ringView.ringWidth = lineWidth
      configureRing(ringView)
      return ringView
  }
  
  func configureRing(ringView: UIView) {
    timerCirclesView.addSubview(ringView)
    ringView.opaque              = false
  }

  private func styleButtons() {
    styleButton(startPauseButton)
    styleButton(nextSegmentButton)
  }
  
  private func styleButton(button: UIButton)  {
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 15
    button.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).CGColor
    button.titleLabel?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

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

