# Swiper

Swiper is a domain-specific language for writing parsers in Swift, taking
advantage of swift's powerful capacity for operator overloading as well as its
type system. Swiper is a work in progress, but here's how it works right now:

## String Parsers

```swift
let p = %"abc"
switch p("abc") {
  case .Success(a,r): println(a)
  default: println("failed")
}
// => "abc"
```

## Sum Parsers

```swift
let p = %"a" + %"b"
switch p("a") {
  case .Success(_,_):
    switch p("b") {
      case .Success(_,_):
        println("Both Passed")
      default: println("`b` Failed")
    }
    default: println("`a` Failed")
}
// -> Both Passed
```

## Product Parsers

```swift
let p = %"a" * (%"b" + %"c")
switch p("ab") {
  case .Success(a,r): println(a)
  default: println("failed")
}
// => "ab"
```

## Power Parsers

```swift
let p = (%"a")*
switch p("aaa") {
  case .Success(a,r): println(a)
  default: println("failed")
}
// => "aaa"
```

These parsers map nicely to the definition of a regular language and are
sufficient for parsing any regular language. However, currently there is
support internally for recurvsive expression matching. I will be working to
make a nice interface for working with these parsers.

