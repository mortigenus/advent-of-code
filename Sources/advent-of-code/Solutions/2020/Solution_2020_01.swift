//
//  Solution_2020_01.swift
//  
//
//  Created by Ivan Chalov on 30.11.20.
//

import Foundation
import Algorithms

struct Solution_2020_01: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init)
            .compactMap(Int.init)
            .sorted()

        // ------- Part 1 -------
        func solve(_ input: [Int], count: Int) -> Int? {
            input.combinations(ofCount: count)
                .first(where: { $0.sum() == 2020 })?
                .product()
        }
        let part1 = solve(input, count: 2)
        print(part1!)

        // ------- Part 2 -------
        let part2 = solve(input, count: 3)
        print(part2!)

        // ------- Test -------
        assert(part1 == 731731, "WA")
        assert(part2 == 116115990, "WA")
    }
}
