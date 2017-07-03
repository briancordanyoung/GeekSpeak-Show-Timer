import UIKit

public typealias Rotation = AccumulatedAngle

// MARK: AccumulatedAngle - A number that represents an angle in both 
//                          degrees or radians.
public struct AccumulatedAngle: AngularType, CustomStringConvertible {
  
  public var value: Double
  
  public init(_ value: Double) {
    self.value = value
  }
  
  
  // All other initilizers call the above init()
  public init(_ accumulatedAngle: AccumulatedAngle) {
    self.init(Double(accumulatedAngle.value))
  }
  
  public init(_ angle: Angle) {
    self.init(Double(angle.value))
  }
  
  public init(_ value: CGFloat) {
    self.init(Double(value))
  }
  
  public init(_ value: Int) {
    self.init(Double(value))
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
  
  public var angle: Angle {
    return Angle(radians)
  }
  
  public var description: String {
    return "\(value)"
  }
  
}

// Extend CGFloat to convert from radians
public extension CGFloat {
   public init(_ rotation: Rotation) {
    self.init(CGFloat(rotation.radians))
  }
}



// MARK: Protocol Conformance
 extension AccumulatedAngle: ExpressibleByIntegerLiteral {
  public init(integerLiteral: IntegerLiteralType) {
    self.init(Double(integerLiteral))
  }
}

 extension AccumulatedAngle: ExpressibleByFloatLiteral {
  public init(floatLiteral: FloatLiteralType) {
    self.init(Double(floatLiteral))
  }
}


// MARK: Extend Int to initialize with an AccumulatedAngle
public extension Int {
  public init(_ accumulatedAngle: AccumulatedAngle) {
    self = Int(accumulatedAngle.radians)
  }
}


public extension AccumulatedAngle {
  public enum Preset {
    case circle
    case halfCircle
    case quarterCircle
    case threeQuarterCircle
    case tau
    case pi
  }
}

// MARK: Class Methods
public extension AccumulatedAngle {
  public static func preset(_ preset: Preset) -> AccumulatedAngle {
    switch preset {
    case .circle,
         .tau:
      return AccumulatedAngle(Double.tau)
    case .halfCircle,
         .pi:
      return AccumulatedAngle(Double.pi)
    case .quarterCircle:
      return AccumulatedAngle(Double.pi * 0.50)
    case .threeQuarterCircle:
      return AccumulatedAngle(Double.pi * 1.50)
    }
  }
  
  public static var pi: AccumulatedAngle {
    return AccumulatedAngle.preset(.pi)
  }
  
  public static var tau: AccumulatedAngle {
    return AccumulatedAngle.preset(.tau)
  }
  
  public static var circle: AccumulatedAngle {
    return AccumulatedAngle.preset(.circle)
  }
  
  public static var halfCircle: AccumulatedAngle {
    return AccumulatedAngle.preset(.halfCircle)
  }
  
  public static var quarterCircle: AccumulatedAngle {
    return AccumulatedAngle.preset(.quarterCircle)
  }
  
  public static var threeQuarterCircle: AccumulatedAngle {
    return AccumulatedAngle.preset(.threeQuarterCircle)
  }
}



// MARK: AccumulatedAngle & Angle specific overloads

public func % (lhs: AccumulatedAngle, rhs: Angle) -> AccumulatedAngle {
  return AccumulatedAngle(lhs.value.truncatingRemainder(dividingBy: rhs.value))
}


public func + (lhs: Angle, rhs: AccumulatedAngle) -> AccumulatedAngle {
  return AccumulatedAngle(lhs.value + rhs.value)
}

public func - (lhs: Angle, rhs: AccumulatedAngle) -> AccumulatedAngle {
  return AccumulatedAngle(lhs.value - rhs.value)
}

public func + (lhs: AccumulatedAngle, rhs: Angle) -> AccumulatedAngle {
  return AccumulatedAngle(lhs.value + rhs.value)
}

public func - (lhs: AccumulatedAngle, rhs: Angle) -> AccumulatedAngle {
  return AccumulatedAngle(lhs.value - rhs.value)
}



public func < (lhs: Angle, rhs: AccumulatedAngle) -> Bool {
  return lhs.value < rhs.value
}

public func == (lhs: Angle, rhs: AccumulatedAngle) -> Bool {
  return lhs.value == rhs.value
}

public func < (lhs: AccumulatedAngle, rhs: Angle) -> Bool {
  return lhs.value < rhs.value
}

public func == (lhs: AccumulatedAngle, rhs: Angle) -> Bool {
  return lhs.value == rhs.value
}



public func += (lhs: inout AccumulatedAngle, rhs: Angle) {
  lhs.value = lhs.value + rhs.value
}

public func -= (lhs: inout AccumulatedAngle, rhs: Angle) {
  lhs.value = lhs.value - rhs.value
}

public func / (lhs: AccumulatedAngle, rhs: Angle) -> AccumulatedAngle {
  return AccumulatedAngle(lhs.value / rhs.value)
}

public func * (lhs: AccumulatedAngle, rhs: Angle) -> AccumulatedAngle {
  return AccumulatedAngle(lhs.value * rhs.value)
}




// MARK: AccumulatedAngle & Int specific overloads

public func % (lhs: AccumulatedAngle, rhs: Int) -> AccumulatedAngle {
  return AccumulatedAngle(lhs.value.truncatingRemainder(dividingBy: Double(rhs)))
}


public func + (lhs: Int, rhs: AccumulatedAngle) -> AccumulatedAngle {
  return AccumulatedAngle(Double(lhs) + rhs.value)
}

public func - (lhs: Int, rhs: AccumulatedAngle) -> AccumulatedAngle {
  return AccumulatedAngle(Double(lhs) - Double(rhs.value))
}

public func + (lhs: AccumulatedAngle, rhs: Int) -> AccumulatedAngle {
  return AccumulatedAngle(lhs.value + Double(rhs))
}

public func - (lhs: AccumulatedAngle, rhs: Int) -> AccumulatedAngle {
  return AccumulatedAngle(lhs.value - Double(rhs))
}



public func < (lhs: Int, rhs: AccumulatedAngle) -> Bool {
  return Double(lhs) < rhs.value
}

public func == (lhs: Int, rhs: AccumulatedAngle) -> Bool {
  return Double(lhs) == rhs.value
}

public func < (lhs: AccumulatedAngle, rhs: Int) -> Bool {
  return lhs.value < Double(rhs)
}

public func == (lhs: AccumulatedAngle, rhs: Int) -> Bool {
  return lhs.value == Double(rhs)
}



public func += (lhs: inout AccumulatedAngle, rhs: Int) {
  lhs.value = lhs.value + Double(rhs)
}

public func -= (lhs: inout AccumulatedAngle, rhs: Int) {
  lhs.value = lhs.value - Double(rhs)
}

public func / (lhs: AccumulatedAngle, rhs: Int) -> AccumulatedAngle {
  return AccumulatedAngle(lhs.value / Double(rhs))
}

public func * (lhs: AccumulatedAngle, rhs: Int) -> AccumulatedAngle {
  return AccumulatedAngle(lhs.value * Double(rhs))
}


