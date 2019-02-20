import Foundation

precedencegroup LeftAssoc {
    associativity: left
}
infix operator >>-: LeftAssoc
public func >>-<T, U>(a: T?, f: (T) -> U?) -> U? {
    return a.flatMap(f)
}
