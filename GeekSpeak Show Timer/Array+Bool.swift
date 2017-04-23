import Swift





extension Array {
  func anyAreTrue(_ transform: (Element) -> Bool) -> Bool {
    return self
            .map(transform)
            .reduce(false, {
              return $1 ? true : $0
            })
  }
  
  
  func anyAreFalse(_ transform: (Element) -> Bool) -> Bool {
    return self
            .map(transform)
            .reduce(false, {
              return $1 == false ? true : $0
            })
  }
}
