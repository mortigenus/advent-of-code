//
//  Solution_2020_03.swift
//  
//
//  Created by Ivan Chalov on 03.12.20.
//

import Foundation

struct Solution_2020_03: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init)

        // ------- Part 1 -------
        func solve(stepX: Int, stepY: Int) -> Int {
            let width = input[0].count
            var i = 0, j = 0, count = 0
            while j < input.count {
                let s = input[j]
                if s[s.index(s.startIndex, offsetBy: i)] == "#" {
                    count += 1
                }
                j += stepY
                i = (i + stepX) % width
            }
            return count
        }
        let part1 = solve(stepX: 3, stepY: 1)
        print(part1)

        // ------- Part 2 -------
        let part2 = [(1,1), (3,1), (5,1), (7,1), (1,2)].map(solve).product()
        print(part2)

        // ------- Test -------
        assert(part1 == 191, "WA")
        assert(part2 == 1478615040, "WA")
    }
}
