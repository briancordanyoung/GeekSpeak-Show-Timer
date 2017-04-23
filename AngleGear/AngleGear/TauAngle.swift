import UIKit


// MARK: TauAngle - A type that represents an angle in both
//               degrees or radians.
//       Unlike AccumulatedAngle, TauAngle is limited to representing
//       a single circle from 0 to 2π
public struct TauAngle: AngularType {
  
  public var value: Double {
    didSet(oldValue) {
      value = TauAngle.limit(value)
    }
  }
  
  public init(_ value: Double) {
    self.value = TauAngle.limit(value)
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
extension TauAngle {
  static func radians2Degrees(_ radians:Double) -> Double {
    return radians * 180.0 / Double(M_PI)
  }
  
  static func degrees2radians(_ degrees:Double) -> Double {
    return degrees * Double(M_PI) / 180.0
  }

  static func limit(_ angle:Double) -> Double {
    var angle = angle
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
  public init(_ angle: TauAngle) {
    self.init(CGFloat(angle.radians))
  }
}



// MARK: Protocol Conformance
extension TauAngle: ExpressibleByIntegerLiteral {
  public init(integerLiteral: IntegerLiteralType) {
    self.init(Double(integerLiteral))
  }
}

extension TauAngle: ExpressibleByFloatLiteral {
  public init(floatLiteral: FloatLiteralType) {
    self.init(Double(floatLiteral))
  }
}


// MARK: Extend Int to initialize with an Angle
extension Int {
  public init(_ angle: TauAngle) {
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
  static func preset(_ preset: Preset) -> TauAngle {
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
  
  public static var pi: TauAngle {
    return TauAngle.preset(.pi)
  }
  
  public static var halfCircle: TauAngle {
    return TauAngle.preset(.halfCircle)
  }
  
  public static var quarterCircle: TauAngle {
    return TauAngle.preset(.quarterCircle)
  }

  public static var tau: TauAngle {
    return TauAngle.preset(.tau)
  }

  public static var fullCircle: TauAngle {
    return TauAngle.preset(.fullCircle)
  }
}




// MARK: Angle & Int specific overloads

public func % (lhs: TauAngle, rhs: Int) -> TauAngle {
  return TauAngle(lhs.value.truncatingRemainder(dividingBy: Double(rhs)))
}


public func + (lhs: Int, rhs: TauAngle) -> TauAngle {
  return TauAngle(Double(lhs) + rhs.value)
}

public func - (lhs: Int, rhs: TauAngle) -> TauAngle {
  return TauAngle(Double(lhs) - rhs.value)
}

public func + (lhs: TauAngle, rhs: Int) -> TauAngle {
  return TauAngle(lhs.value + Double(rhs))
}

public func - (lhs: TauAngle, rhs: Int) -> TauAngle {
  return TauAngle(lhs.value - Double(rhs))
}




public func < (lhs: Int, rhs: TauAngle) -> Bool {
  return Double(lhs) < rhs.value
}

public func == (lhs: Int, rhs: TauAngle) -> Bool {
  return Double(lhs) == rhs.value
}

public func < (lhs: TauAngle, rhs: Int) -> Bool {
  return lhs.value < Double(rhs)
}

public func == (lhs: TauAngle, rhs: Int) -> Bool {
  return lhs.value == Double(rhs)
}



public func += (lhs: inout TauAngle, rhs: Int) {
  lhs.value = lhs.value + Double(rhs)
}

public func -= (lhs: inout TauAngle, rhs: Int) {
  lhs.value = lhs.value - Double(rhs)
}

public func / (lhs: TauAngle, rhs: Int) -> TauAngle {
  return TauAngle(lhs.value / Double(rhs))
}

public func * (lhs: TauAngle, rhs: Int) -> TauAngle {
  return TauAngle(lhs.value * Double(rhs))
}
