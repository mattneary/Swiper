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
  func runTests() {
    let tests = [
      testUnitParser,
      testZeroParser
    ]
    for test in tests {
      print(test() ? "." : "F")
    }
  }
}
ParserTests().runTests()

