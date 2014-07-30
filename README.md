# Swiper

Swiper is a domain-specific language for writing parsers in Swift, taking
advantage of swift's powerful operator overloading as well as its type system.
Swiper is a work in progress, but here's how it works right now:

## An Example

```swift
func expr(s : String) -> SResult {
  switch (%"(")(s) {
  case let .Success(_,r):
    switch ((expr * %" ")* * expr)(r) {
    case let .Success(es,r):
      switch (%")")(r) {
      case let .Success(_,r): return .Success(es,r)
      default: return .Failure
      }
    default: return .Failure
    }
  default:
    switch (%"0" + %"1")(s) {
    case let .Success(num,r): return .Success(num,r)
    default: return .Failure
    }
  }
}
switch expr("((0 1 1) (0 1 0))") {
  case let .Success(_,_): println("Success")
  default: println("Failure")
}
// => Success
```

## The Parsers

### String Parsers

```swift
let p = %"abc"
switch p("abc") {
  case let .Success(a,r): println(a)
  default: println("failed")
}
// => "abc"
```

### Sum Parsers

```swift
let p = %"a" + %"b"
switch p("a") {
  case let .Success(_,_):
    switch p("b") {
      case let .Success(_,_):
        println("Both Passed")
      default: println("`b` Failed")
    }
    default: println("`a` Failed")
}
// -> Both Passed
```

### Product Parsers

```swift
let p = %"a" * (%"b" + %"c")
switch p("ab") {
  case let .Success(a,r): println(a)
  default: println("failed")
}
// => "ab"
```

### Power Parsers

```swift
let p = (%"a")*
switch p("aaa") {
  case let .Success(a,r): println(a)
  default: println("failed")
}
// => "aaa"
```

### Recursive Parsers

```swift
func p(s : String) -> SResult {
  return ((%"a" * p) + %"a")(s)
}
switch p("aaa") {
  case let .Success(a,r): println(a)
  default: println("failed")
}
// => "aaa"
```

## Parsing Regular Languages

The inductive rules for building a regular language are pretty simple, and the
parsers provided map nicely to the rules. Here are the possible values of a
regular language and how they can be matched with Swiper:

1. `charParser` matches the singleton `{a}` for some `a` in the alphabet.
2. `A + B` matches expressions matched by `A` and expressions matched by `B`.
3. `A * B` matches the concatenation of expressions matched by `A` and by `B`.
4. `A*` matches members of the Kleene closure of expressions matched by `A`.

