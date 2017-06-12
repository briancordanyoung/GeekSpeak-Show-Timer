import UIKit


// MARK: Angle - A number that represents an angle in both
//               degrees or radians.
//       Unlike AccumulatedAngle, Angle is limited to representing
//       a single circle from -π to π
public struct Angle: AngularType {
  
  public var value: Double {
    didSet(oldValue) {
      value = Angle.limit(value)
    }
  }
  
  public init(_ value: Double) {
    self.value = Angle.limit(value)
  }
  
  
  // All other initilizers call the above init()
  public init(_ angle: Angle) {
    self.init(angle.value)
  }
  
  public init(_ angle: AccumulatedAngle) {
    self.init(angle.value)
  }
  
  public init(_ value: CGFloat) {
    self.init(Double(value))
  }
  
  public init(_ value: Int) {
    self.init(Double(value))
  }
  
  public init(transform: CGAffineTransform) {
    let b = transform.b
    let a = transform.a
    let angle = atan2(b, a)
    self.init(radians: angle)
  }
  
  public init(radians: Double) {
    self.init(radians)
  }
  
  public init(radians: CGFloat) {
    self.init(Double(radians))
  }
  
  public init(radians: Int) {
    self.init(Double(radians))
  }
  
  
  public init(degrees: Double) {
    self.init(radians: Angle.degrees2radians(degrees))
  }
  
  public init(degrees: CGFloat) {
    self.init(degrees: Double(degrees))
  }
  
  public init(degrees: Int) {
    self.init(degrees: Double(degrees))
  }
  
  
  public var radians: Double  {
    return value
  }
  
  public var degrees: Double {
    return Angle.radians2Degrees(value)
  }
  
  public var accumulatedAngle: AccumulatedAngle {
    return AccumulatedAngle(radians)
  }

  public var rotation: AccumulatedAngle {
    return AccumulatedAngle(radians)
  }

  public var description: String {
    return "\(value)"
  }
}



// Angle conversions:
// degrees <--> radians
extension Angle {
  static func radians2Degrees(_ radians:Double) -> Double {
    return radians * 180.0 / Double(M_PI)
  }
  
  static func degrees2radians(_ degrees:Double) -> Double {
    return degrees * Double(M_PI) / 180.0
  }

  static func limit(_ angle:Double) -> Double {
    var angle = angle
    let pi  = M_PI
    let tau = M_PI * 2
    
    if angle >  pi {
      angle += pi
      let totalRotations = floor(angle / tau)
      angle  = angle - (tau * totalRotations)
      angle -= pi
    }
    
    if angle < -pi {
      angle -= pi
      let totalRotations = floor(abs(angle) / tau)
      angle  = angle + (tau * totalRotations)
      angle += pi
    }
    
    return angle
  }
}

// Extend CGFloat to convert from radians
extension CGFloat {
  public init(_ angle: Angle) {
    self.init(CGFloat(angle.radians))
  }
}



// MARK: Protocol Conformance
extension Angle: ExpressibleByIntegerLiteral {
  public init(integerLiteral: IntegerLiteralType) {
    self.init(Double(integerLiteral))
  }
}

extension Angle: ExpressibleByFloatLiteral {
  public init(floatLiteral: FloatLiteralType) {
    self.init(Double(floatLiteral))
  }
}


// MARK: Extend Int to initialize with an Angle
extension Int {
  init(_ angle: Angle) {
    self = Int(angle.value)
  }
}




func isWithinAngleLimits(_ value: Double) -> Bool {
  var isWithinLimits = true
  
  if value > M_PI {
    isWithinLimits = false
  }
  
  if value < -M_PI {
    isWithinLimits = false
  }
  
  return isWithinLimits
}

func isWithinAngleLimits(_ value: CGFloat) -> Bool {
  var isWithinLimits = true
  
  if value > CGFloat(M_PI) {
    isWithinLimits = false
  }
  
  if value < CGFloat(-M_PI) {
    isWithinLimits = false
  }
  
  return isWithinLimits
}



extension Angle {
  public enum Preset {
    case halfCircle
    case quarterCircle
    case pi
  }
}

// MARK: Static Methods
extension Angle {
  public static func preset(_ preset: Preset) -> Angle {
    switch preset {
    case .halfCircle,
         .pi:
      return Angle(M_PI)
    case .quarterCircle:
      return Angle(M_PI * 0.50)
    }
  }
  
  public static var pi: Angle {
    return Angle.preset(.pi)
  }
  
  public static var halfCircle: Angle {
    return Angle.preset(.halfCircle)
  }
  
  public static var quarterCircle: Angle {
    return Angle.preset(.quarterCircle)
  }
}




// MARK: Angle & Int specific overloads

public func % (lhs: Angle, rhs: Int) -> Angle {
  return Angle(lhs.value.truncatingRemainder(dividingBy: Double(rhs)))
}


public func + (lhs: Int, rhs: Angle) -> Angle {
  return Angle(Double(lhs) + rhs.value)
}

public func - (lhs: Int, rhs: Angle) -> Angle {
  return Angle(Double(lhs) - rhs.value)
}

public func + (lhs: Angle, rhs: Int) -> Angle {
  return Angle(lhs.value + Double(rhs))
}

public func - (lhs: Angle, rhs: Int) -> Angle {
  return Angle(lhs.value - Double(rhs))
}




public func < (lhs: Int, rhs: Angle) -> Bool {
  return Double(lhs) < rhs.value
}

public func == (lhs: Int, rhs: Angle) -> Bool {
  return Double(lhs) == rhs.value
}

public func < (lhs: Angle, rhs: Int) -> Bool {
  return lhs.value < Double(rhs)
}

public func == (lhs: Angle, rhs: Int) -> Bool {
  return lhs.value == Double(rhs)
}



public func += (lhs: inout Angle, rhs: Int) {
  lhs.value = lhs.value + Double(rhs)
}

public func -= (lhs: inout Angle, rhs: Int) {
  lhs.value = lhs.value - Double(rhs)
}

public func / (lhs: Angle, rhs: Int) -> Angle {
  return Angle(lhs.value / Double(rhs))
}

public func * (lhs: Angle, rhs: Int) -> Angle {
  return Angle(lhs.value * Double(rhs))
}
