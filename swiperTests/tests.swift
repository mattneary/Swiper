class ParserTests {
  func testUnitParser() -> Bool {
    switch unitParser("") {
      case let .Success(_,_): return true
      default: return false
    }
  }
  func testZeroParser() -> Bool {
    switch zeroParser("") {
      case let .Success(_,_): return false
      default: return true
    }
  }
  func testCharParser() -> Bool {
    let parser = charParser("a")
    let match = {
      () -> Bool in
      switch parser("a") {
	case let .Success(a,rest): return a == "a" && rest == ""
	default: return false
      }
    }
    let submatch = {
      () -> Bool in
      switch parser("ab") {
	case let .Success(a,rest): return a == "a" && rest == "b"
	default: return false
      }
    }
    let failure = {
      () -> Bool in
      switch parser("c") {
	case let .Success(_,_): return false
	default: return true
      }
    }
    return match() && submatch() && failure()
  }
  func runTests() {
    let tests = [
      testUnitParser,
      testZeroParser,
      testCharParser
    ]
    for test in tests {
      print(test() ? "." : "F")
    }
  }
}
ParserTests().runTests()

