//
//  Sequence+Extensions.swift
//  
//
//  Created by Ivan Chalov on 03.12.20.
//

import Foundation

extension Sequence where Element == Int {
    func sum() -> Int {
        reduce(0, +)
    }
    func product() -> Int {
        reduce(1, *)
    }
}
