import UIKit


// MARK: TauAngle - A type that represents an angle in both
//               degrees or radians.
//       Unlike AccumulatedAngle, TauAngle is limited to representing
//       a single circle from 0 to 2π
struct TauAngle: AngularType {
  
  var value: Double {
    didSet(oldValue) {
      value = TauAngle.limit(value)
    }
  }
  
  init(_ value: Double) {
    self.value = TauAngle.limit(value)
  }
  
  
  // All other initilizers call the above init()
  init(_ angle: Angle) {
    self.init(angle.value)
  }
  
  init(_ angle: AccumulatedAngle) {
    self.init(angle.value)
  }
  
  init(_ value: CGFloat) {
    self.init(Double(value))
  }
  
  init(_ value: Int) {
    self.init(Double(value))
  }
  
  init(transform: CGAffineTransform) {
    let b = transform.b
    let a = transform.a
    let angle = atan2(b, a)
    self.init(radians: angle)
  }
  
  init(radians: Double) {
    self.init(radians)
  }
  
  init(radians: CGFloat) {
    self.init(Double(radians))
  }
  
  init(radians: Int) {
    self.init(Double(radians))
  }
  
  
  init(degrees: Double) {
    self.init(radians: Angle.degrees2radians(degrees))
  }
  
  init(degrees: CGFloat) {
    self.init(degrees: Double(degrees))
  }
  
  init(degrees: Int) {
    self.init(degrees: Double(degrees))
  }
  
  
  var radians: Double  {
    return value
  }
  
  var degrees: Double {
    return Angle.radians2Degrees(value)
  }
  
  var accumulatedAngle: AccumulatedAngle {
    return AccumulatedAngle(radians)
  }

  var rotation: AccumulatedAngle {
    return AccumulatedAngle(radians)
  }

  var description: String {
    return "\(value)"
  }
}



// Angle conversions:
// degrees <--> radians
extension TauAngle {
  static func radians2Degrees(radians:Double) -> Double {
    return radians * 180.0 / Double(M_PI)
  }
  
  static func degrees2radians(degrees:Double) -> Double {
    return degrees * Double(M_PI) / 180.0
  }

  static func limit(var angle:Double) -> Double {
    let tau = M_PI * 2
    
    if angle >  tau {
      let totalRotations = floor(angle / tau)
      angle  = angle - (tau * totalRotations)
    }
    
    if angle < 0.0 {
      let totalRotations = floor(abs(angle) / tau)
      angle  = angle + (tau * totalRotations)
    }
    
    return angle
  }
}

// Extend CGFloat to convert from radians
extension CGFloat {
  init(_ angle: TauAngle) {
    self.init(CGFloat(angle.radians))
  }
}



// MARK: Protocol Conformance
extension TauAngle: IntegerLiteralConvertible {
  init(integerLiteral: IntegerLiteralType) {
    self.init(Double(integerLiteral))
  }
}

extension TauAngle: FloatLiteralConvertible {
  init(floatLiteral: FloatLiteralType) {
    self.init(Double(floatLiteral))
  }
}


// MARK: Extend Int to initialize with an Angle
extension Int {
  init(_ angle: TauAngle) {
    self = Int(angle.value)
  }
}





extension TauAngle {
  enum Preset {
    case halfCircle
    case quarterCircle
    case pi
    case fullCircle
    case tau
  }
}

// MARK: Static Methods
extension TauAngle {
  static func preset(preset: Preset) -> TauAngle {
    switch preset {
    case .fullCircle,
         .tau:
      return TauAngle(M_PI * 2)
    case .halfCircle,
         .pi:
      return TauAngle(M_PI)
    case .quarterCircle:
      return TauAngle(M_PI * 0.50)
    }
  }
  
  static var pi: TauAngle {
    return TauAngle.preset(.pi)
  }
  
  static var halfCircle: TauAngle {
    return TauAngle.preset(.halfCircle)
  }
  
  static var quarterCircle: TauAngle {
    return TauAngle.preset(.quarterCircle)
  }

  static var tau: TauAngle {
    return TauAngle.preset(.tau)
  }

  static var fullCircle: TauAngle {
    return TauAngle.preset(.fullCircle)
  }
}




// MARK: Angle & Int specific overloads

func % (lhs: TauAngle, rhs: Int) -> TauAngle {
  return TauAngle(lhs.value % Double(rhs))
}


func + (lhs: Int, rhs: TauAngle) -> TauAngle {
  return TauAngle(Double(lhs) + rhs.value)
}

func - (lhs: Int, rhs: TauAngle) -> TauAngle {
  return TauAngle(Double(lhs) - rhs.value)
}

func + (lhs: TauAngle, rhs: Int) -> TauAngle {
  return TauAngle(lhs.value + Double(rhs))
}

func - (lhs: TauAngle, rhs: Int) -> TauAngle {
  return TauAngle(lhs.value - Double(rhs))
}




func < (lhs: Int, rhs: TauAngle) -> Bool {
  return Double(lhs) < rhs.value
}

func == (lhs: Int, rhs: TauAngle) -> Bool {
  return Double(lhs) == rhs.value
}

func < (lhs: TauAngle, rhs: Int) -> Bool {
  return lhs.value < Double(rhs)
}

func == (lhs: TauAngle, rhs: Int) -> Bool {
  return lhs.value == Double(rhs)
}



func += (inout lhs: TauAngle, rhs: Int) {
  lhs.value = lhs.value + Double(rhs)
}

func -= (inout lhs: TauAngle, rhs: Int) {
  lhs.value = lhs.value - Double(rhs)
}

func / (lhs: TauAngle, rhs: Int) -> TauAngle {
  return TauAngle(lhs.value / Double(rhs))
}

func * (lhs: TauAngle, rhs: Int) -> TauAngle {
  return TauAngle(lhs.value * Double(rhs))
}
