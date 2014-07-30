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

