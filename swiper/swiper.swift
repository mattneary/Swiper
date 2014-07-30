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

