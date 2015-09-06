import Swift





extension Array {
  func anyAreTrue(transform: (T) -> Bool) -> Bool {
    return self
            .map(transform)
            .reduce(false, combine: {
              return $1 ? true : $0
            })
  }
  
  
  func anyAreFalse(transform: (T) -> Bool) -> Bool {
    return self
            .map(transform)
            .reduce(false, combine: {
              return $1 == false ? true : $0
            })
  }
}
