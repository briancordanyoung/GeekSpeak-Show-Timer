

func comments(_: () -> ()) {
    // This is a no-op function created to use the trailing closure syntax
    // to wrap up a bunch of comments for 
}

// See: http://owensd.io/2015/05/12/optionals-if-let.html
extension Optional {
 
  var hasValue: Bool {
    get {
      return hasValue(self)
    }
  }
  
  func hasValue<T>(_ value: T?) -> Bool {
    switch (value) {
    case .some(_): return true
    case .none:    return false
    }
  }
  
  var hasNoValue: Bool {
    get {
      return hasNoValue(self)
    }
  }

  func hasNoValue<T>(_ value: T?) -> Bool {
    let result = hasValue(value)
    return !result
  }

}
