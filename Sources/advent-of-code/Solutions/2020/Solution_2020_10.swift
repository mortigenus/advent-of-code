//
//  Solution_2020_10.swift
//
//
//  Created by Ivan Chalov on 10.12.20.
//

import Foundation
import Algorithms
import Prelude

struct Solution_2020_10: Solution {
    var input: Input
    func run() throws {
//        let input = """
//        16
//        10
//        15
//        5
//        1
//        11
//        7
//        19
//        6
//        12
//        4
//        """
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init)
            .compactMap(Int.init)
            .sorted()

        // ------- Part 1 -------
        let joltages = [0] + input + [input.last! + 3]
        let diffs = zipWith((-))(joltages.dropFirst())(joltages).histogram()
        let part1 = diffs[1]! * diffs[3]!
        print(part1)

        // ------- Part 2 -------
        let (part2, _, _) = joltages.indices.reversed().dropFirst().reduce((1, 0, 0)) { acc, i in
            _ = () // speeding up type-checking 🏎
            return (
                sum([
                    i + 1 < joltages.count && joltages[i + 1] - joltages[i] <= 3 ? acc.0 : 0,
                    i + 2 < joltages.count && joltages[i + 2] - joltages[i] <= 3 ? acc.1 : 0,
                    i + 3 < joltages.count && joltages[i + 3] - joltages[i] <= 3 ? acc.2 : 0,
                ]),
                acc.0,
                acc.1
            )
        }
        print(part2)

        // ------- Test -------
        assert(part1 == 2040, "WA")
        assert(part2 == 28346956187648, "WA")
    }
}
