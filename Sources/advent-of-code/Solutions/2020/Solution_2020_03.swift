//
//  Solution_2020_03.swift
//  
//
//  Created by Ivan Chalov on 03.12.20.
//

import Foundation
import Algorithms

struct Solution_2020_03: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init)

        // ------- Part 1 -------
        func solve(steps: [(x: Int, y: Int)]) -> Int {
            let width = input[0].count
            return input.indices
                .reduce(into: Array(repeating: 0, count: steps.count)) { acc, row in
                    let s = input[row]
                    steps.indexed()
                        .filter { _, step in
                            row % step.y == 0
                        }
                        .map { index, step in
                            (index: index, element: step.x * (row / step.y) % width)
                        }
                        .filter { _, column in
                            s[s.index(s.startIndex, offsetBy: column)] == "#"
                        }
                        .forEach { index, _ in
                            acc[index] += 1
                        }
                }
                .product()
        }
        let part1 = solve(steps: [(3,1)])
        print(part1)

        // ------- Part 2 -------
        let part2 = solve(steps: [(1,1), (3,1), (5,1), (7,1), (1,2)])
        print(part2)

        // ------- Test -------
        assert(part1 == 191, "WA")
        assert(part2 == 1478615040, "WA")
    }
}
