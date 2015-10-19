import UIKit

class ActivityView: UIView {
  private let pieActivityView = PieShapeView()
  
  enum Parity {
    case Even
    case Odd
  }
  
  var activity = CGFloat(0) {
    didSet {
      
//      print("\(activityPercentage)")
      let position = 360 * activityPercentage
//      pieActivityView.startAngle = TauAngle(degrees: 0)
//      pieActivityView.endAngle   = TauAngle(degrees: position)
      
//      switch activityParity {
//      case .Even:
//        print("Even  \(position)")
//        pieActivityView.startAngle = TauAngle(degrees: 0)
//        pieActivityView.endAngle   = TauAngle(degrees: position)
//      case .Odd:
//        print("Odd  \(position)")
//        pieActivityView.startAngle = TauAngle(degrees: position)
//        pieActivityView.endAngle   = TauAngle(degrees: 0)
//      }
    }
  }
  
  private var activityPercentage: CGFloat {
    let rounded = floor(activity)
    return activity - rounded
  }
  
  private var activityParity: Parity {
    let parity: Parity
    if Int(activity) % 2 == 0 {
      parity = .Even
    } else {
      parity = .Odd
    }
    return parity
  }

  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  func setup() {
    pieActivityView.pieLayer.clipToCircle = true
    pieActivityView.color = Appearance.Constants.GeekSpeakBlueColor
//    addSubview(pieActivityView)
  }

}


