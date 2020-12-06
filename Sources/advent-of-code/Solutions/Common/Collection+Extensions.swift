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
}
