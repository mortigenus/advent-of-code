//
//  Solution_2020_05.swift
//
//
//  Created by Ivan Chalov on 05.12.20.
//

import Foundation

struct Solution_2020_05: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init)

        // ------- Part 1 -------
        func parseNumber(from string: String) -> Int {
            string.reversed()
                .reduce((sum: 0, power: 1)) { acc, char in
                    switch char {
                    case "B", "R":
                        return (acc.sum + acc.power, acc.power * 2)
                    case "F", "L":
                        return (acc.sum, acc.power * 2)
                    default:
                        fatalError("Incorrect Input")
                    }
                }
                .sum
        }
        let passes = input
            .map(parseNumber(from:))
            .sorted()
        let part1 = passes.last!
        print(part1)

        // ------- Part 2 -------
        let part2 = zip(passes, passes[1...]).first(where: { cur, next in cur + 1 != next })!.0 + 1
        print(part2)

        // ------- Test -------
        assert(part1 == 855, "WA")
        assert(part2 == 552, "WA")
    }
}
