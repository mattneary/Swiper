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
  func testSumParser() -> Bool {
    let matchA = {
      (p : Parser) -> Bool in
      switch p("a") {
        case let .Success(a, rest): return a == "a" && rest == ""
	default: return false
      }
    }
    let matchB = {
      (p : Parser) -> Bool in
      switch p("b") {
        case let .Success(a, rest): return a == "b" && rest == ""
	default: return false
      }
    }
    let p1 = charParser("a") + charParser("b")
    let p2 = +{ [charParser("a"), charParser("b")] }
    return matchA(p1) && matchB(p1)
      && matchA(p2) && matchB(p2)
  }
  func testProductParser() -> Bool {
    let match = {
      (p : Parser) -> Bool in
      switch p("ab") {
        case let .Success(a, rest): return a == "ab" && rest == ""
	default: return false
      }
    }
    let p1 = charParser("a") * charParser("b")
    let p2 = *{ [charParser("a"), charParser("b")] }
    return match(p1) && match(p2)
  }
  func runTests() {
    let tests = [
      testUnitParser,
      testZeroParser,
      testCharParser,
      testSumParser,
      testProductParser
    ]
    for test in tests {
      print(test() ? "." : "F")
    }
  }
}
ParserTests().runTests()

