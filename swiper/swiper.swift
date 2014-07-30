extension String {
  subscript (i: Int) -> String {
    return String(Array(self)[i])
  }
  subscript (r: Range<Int>) -> String {
    get {
      let startIndex = advance(self.startIndex, r.startIndex)
      let endIndex = advance(startIndex, r.endIndex - r.startIndex)
      return self[Range(start: startIndex, end: endIndex)]
    }
  }
}

public enum SResult {
  case Success(String, String)
  case Failure
}
public typealias Parser = String -> SResult
public let zeroParser : Parser = {
  (s : String) -> SResult
  in
  return .Failure
}
public let unitParser : Parser = {
  (s : String) -> SResult
  in
  return .Success("", s)
}

func charParser(c : String) -> Parser {
  return {
    (s : String) -> SResult
    in
    if countElements(s) > 0 && s[0] == c {
      return .Success(c, s[1..<countElements(s)])
    } else {
      return .Failure
    }
  }
}

operator prefix + {}
@prefix func +(ps : () -> [Parser]) -> Parser {
  return {
    (string s) -> SResult
    in
    var parser = zeroParser
    for p in ps() {
      parser = parser + p
    }
    return parser(s)
  }
}
func +(a : Parser, b : Parser) -> Parser {
  return {
    (s : String) -> SResult
    in
    let A = a(s)
    switch A {
      case .Success(_, _): return A
      default: return b(s)
    }
  }
}

func *(a : Parser, b : Parser) -> Parser {
  return {
    (s : String) -> SResult
    in
    let A = a(s)
    if countElements(s) == 0 {
      return .Failure
    }
    switch A {
      case let .Success(mA, rest):
	let B = b(rest)
        switch B {
	  case let .Success(mB, rest2): return .Success(mA+mB, rest2)
	  default: return B
	}
      default: return b(s)
    }
  }
}
operator prefix * {}
@prefix func *(ps : () -> [Parser]) -> Parser {
  return {
    (string s) -> SResult
    in
    var parser = unitParser
    for p in ps() {
      parser = parser * p
    }
    return parser(s)
  }
}

operator prefix % {}
@prefix func %(p : String) -> Parser {
  var parser = unitParser
  for c in p {
    parser = parser * charParser(String(c))
  }
  return parser
}

