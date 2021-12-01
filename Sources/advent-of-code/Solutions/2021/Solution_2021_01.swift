//
//  Solution_2021_01.swift
//
//
//  Created by Ivan Chalov on 01.12.21.
//

import Foundation
import Algorithms

struct Solution_2021_01: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .compactMap { Int($0) }

        // ------- Part 1 -------
        let countIncreases: ([Int]) -> Int = { xs in
            zip(xs, xs.dropFirst()).filter { $0.1 > $0.0 }.count
        }
        let part1 = countIncreases(input)
        print(part1)

        // ------- Part 2 -------
        let windowSums = input.slidingWindows(ofCount: 3).map { $0.reduce(0, +) }
        let part2 = countIncreases(windowSums)
        print(part2)

        // ------- Test -------
        assert(part1 == 1665, "WA")
        assert(part2 == 1702, "WA")
    }

}
