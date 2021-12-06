//
//  Solution_2021_06.swift
//
//
//  Created by Ivan Chalov on 06.12.21.
//

import Foundation

struct Solution_2021_06: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .split(separator: ",")
            .map { Int($0)! }

        // ------- Part 1 -------
        func solve(rounds: Int) -> Int {
            (1...rounds)
                .reduce(Dictionary(grouping: input, by: { $0 }).mapValues(\.count)) { timers, _ in
                    var newTimers = [Int: Int]()
                    for timer in 1...8 {
                        newTimers[timer - 1] = timers[timer]
                    }
                    let newFish = timers[0] ?? 0
                    newTimers[6, default: 0] += newFish
                    newTimers[8, default: 0] += newFish
                    return newTimers
                }
                .values.reduce(0, +)
        }
        let part1 = solve(rounds: 80)
        print(part1)

        // ------- Part 2 -------
        let part2 = solve(rounds: 256)
        print(part2)

        // ------- Test -------
        assert(part1 == 361169, "WA")
        assert(part2 == 1634946868992, "WA")
    }

}
