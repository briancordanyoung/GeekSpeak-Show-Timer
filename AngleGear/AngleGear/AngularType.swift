import Swift
import Foundation

public protocol AngularType : Comparable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
  var value: Double { set get }
  init(_ value: Double)
}

public func % <T:AngularType> (lhs: T, rhs: T) -> T {
  return T(lhs.value.truncatingRemainder(dividingBy: rhs.value))
}

public func + <T:AngularType> (lhs: T, rhs: T) -> T {
  return T(lhs.value + rhs.value)
}

public func - <T:AngularType> (lhs: T, rhs: T) -> T {
  return T(lhs.value - rhs.value)
}

public func < <T:AngularType> (lhs: T, rhs: T) -> Bool {
  return lhs.value < rhs.value
}

public func == <T:AngularType> (lhs: T, rhs: T) -> Bool {
  return lhs.value == rhs.value
}

public prefix func - <T: AngularType> (number: T) -> T {
  return T(-number.value)
}

public func += <T:AngularType> (lhs: inout T, rhs: T) {
  lhs.value = lhs.value + rhs.value
}

public func -= <T:AngularType> (lhs: inout T, rhs: T) {
  lhs.value = lhs.value - rhs.value
}

public func / <T:AngularType> (lhs: T, rhs: T) -> T {
  return T(lhs.value / rhs.value)
}

public func * <T:AngularType> (lhs: T, rhs: T) -> T {
  return T(lhs.value * rhs.value)
}

public func cos<T:AngularType>(_ x: T) -> T {
  return T(cos(x.value))
}

public func sin<T:AngularType>(_ x: T) -> T {
  return T(sin(x.value))
}

public func floor<T:AngularType>(_ x: T) -> T {
  return T(floor(x.value))
}

public func ceil<T:AngularType>(_ x: T) -> T {
  return T(ceil(x.value))
}

public func log<T:AngularType>(_ x: T) -> T {
  return T(log(x.value))
}

public func abs<T:AngularType>(_ x: T) -> T {
  return T(abs(x.value))
}
