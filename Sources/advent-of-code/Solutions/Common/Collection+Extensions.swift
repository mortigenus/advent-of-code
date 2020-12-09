//
//  Collection+Extensions.swift
//  
//
//  Created by Ivan Chalov on 03.12.20.
//

import Foundation

extension Collection where Element == Int {
    @inlinable func sum() -> Int {
        reduce(0, +)
    }
    @inlinable func product() -> Int {
        reduce(1, *)
    }
}

extension Collection {
    @inlinable public func scan(
        _ nextPartialResult: (Element, Element) throws -> Element
    ) rethrows -> Element {
        let head = self.first!
        let tail = self.dropFirst()
        return try tail.reduce(head, nextPartialResult)
    }

    @inlinable public func reduce<Result>(
        _ initialResult: Result,
        while predicate: (Result) -> Bool,
        _ nextPartialResult: (Result, Self.Element) throws -> Result) rethrows -> Result {
        var acc = initialResult
        for x in self {
            acc = try nextPartialResult(acc, x)
            if !predicate(acc) {
                return acc
            }
        }
        return acc
    }

    @inlinable public func reduce<Result>(
        into initialResult: Result,
        while predicate: (Result) -> Bool,
        _ updateAccumulatingResult: (inout Result, Self.Element) throws -> ()) rethrows -> Result {
        var acc = initialResult
        for x in self {
            try updateAccumulatingResult(&acc, x)
            if !predicate(acc) {
                return acc
            }
        }
        return acc
    }
}
