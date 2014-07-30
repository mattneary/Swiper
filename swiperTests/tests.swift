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
  func testStringParser() -> Bool {
    switch (%"abc")("abc") {
      case let .Success(a,r): return a=="abc" && r==""
      default: return false
    }
  }
  func testPowerParser() -> Bool {
    let anyMatch = {
      () -> Bool in
      let pattern = (%"a")*
      switch pattern("aaa") {
	case let .Success(a, r): return a=="aaa" && r==""
	default: return false
      }
    }
    let anyMatch2 = {
      () -> Bool in
      let pattern = (%"a")*
      switch pattern("") {
	case let .Success(a, r): return a=="" && r==""
	default: return false
      }
    }
    let someMatch = {
      () -> Bool in
      let pattern = (%"a")+
      switch pattern("aaa") {
	case let .Success(a, r): return a=="aaa" && r==""
	default: return false
      }
    }
    let someFail = {
      () -> Bool in
      let pattern = (%"a")+
      switch pattern("aaa") {
	case let .Success(_,_): return false
	default: return true
      }
    }
    return anyMatch() && anyMatch2()
      && someFail() && someMatch()
  }
  func parse(s : String) -> SResult {
    // NB. This function cannot be nested with `testBackReferences`
    // because of an apparent bug in Swift.
    // Cf. https://gist.github.com/mattneary/5848c03f12c246057b2a.
    return ((%"a" * parse) + %"a")(s)
  }
  func testBackReferences() -> Bool {
    switch parse("aaa") {
      case let .Success(a,r): return a == "aaa" && r == ""
      default: return false
    }
  }
  func runTests() {
    let tests = [
      testUnitParser,
      testZeroParser,
      testCharParser,
      testSumParser,
      testProductParser,
      testStringParser,
      testBackReferences
    ]
    for test in tests {
      print(test() ? "." : "F")
    }
  }
}
ParserTests().runTests()

