# Swiper

Swiper is a domain-specific language for writing parsers in Swift, taking
advantage of swift's powerful operator overloading as well as its type system.
Swiper is a work in progress, but here's how it works right now:

## An Example

```swift
func expr(s : String) -> SResult {
  return swiperTry(
    swiperReturn(s) >>= %"(" >>= (expr * %" ")* * expr >>= %")"
  , swiperReturn(s) >>= %"0" + %"1"
  )
}
switch expr("((0 1 1) (0 1 0))") {
  case let .Success(m,_): println(m)
  default: println("Failure")
}
// => "((0 1 1) (0 1 0))"
```

## What Remains

The key feature not yet in Swiper is the generation of an abstract syntax tree
(AST) which can then be used to evaluate the expression. For now, we are
waiting for Swift to support recursive `enums`. Once we have this, as well as a
monad transformer basis rather than the current simple monad, it will work like
this:

```swift
enum Expr {
  case Node(String, String)
  case Group(String, [Expr])
}
func expr(s : String) -> Expr {
  return swiperTry(
    doo( { "_"    <- %"(" }
        ,{ "list" <- (expr * %" ")* * expr }
        ,{ "_"    <- %")" }
        ,{ <<- "list" :-: $0("list") })
   ,doo( { "number" <- %"0" + %"1" }
        ,{ <<- "number" :: $0("number") })
  )(s)
}
expr("((0 1) (1 1))")
// => Group("list",
//      [Group("list", [Node("number", "0"), Node("number", "1")]),
//       Group("list", [Node("number", "1"), Node("number", "1")])])
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

## Combining Parsers

There are two special shorthands for combining parsers which will become even
more useful once parsing begins to return a more structured value than merely
the matched string. The shorthands are `>>=` for parser products and
`swiperTry(...)` for parser sums. They both work at a different level of
abstraction than the normal `*` and `+` operators.` Here's how they work:

```swift
// >>= : SResult -> Parser -> SResult
(%"a")("abc") >>= %"b" == (%"a" * %"b")("abc")
// swiperTry : (@auto_closure () -> SResult)...
swiperTry( (%"a")("abc"), (%"b")("abc") ) == (%"a" + %"b")("abc")
```

