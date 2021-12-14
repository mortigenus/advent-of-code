//
//  Solution_2021_14.swift
//
//
//  Created by Ivan Chalov on 14.12.21.
//

import Foundation
import Algorithms

struct Solution_2021_14: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .components(separatedBy: "\n\n")
        let template = input[0]
        let rules = input[1]
            .split(whereSeparator: \.isNewline)
            .map { $0.components(separatedBy: " -> ") }
            .map {
                (
                    pair: $0[0],
                    new1: String($0[0].first!)+$0[1],
                    new2: $0[1]+String($0[0].last!)
                )
            }
        
        // ------- Part 1 -------
        func solve(rounds: Int) -> Int {
            func getCountedPairs() -> Dictionary<String, Int> {
                Dictionary(
                    grouping: (template + "$").slidingWindows(ofCount: 2).map(String.init),
                    by: { $0 })
                    .mapValues(\.count)
            }

            let result = (1...rounds).reduce(getCountedPairs()) { countedPairs, _ in
                rules.reduce(into: countedPairs) { newPairs, rule in
                    if let x = countedPairs[rule.pair], x > 0 {
                        newPairs[rule.pair]! -= x
                        newPairs[rule.new1, default: 0] += x
                        newPairs[rule.new2, default: 0] += x
                    }
                }
            }

            let charCounts: [Character: Int] = result.reduce(into: [:]) { acc, x in
                acc[x.key.first!, default: 0] += x.value
            }
            return charCounts.values.max()! - charCounts.values.min()!
        }
        let part1 = solve(rounds: 10)
        print(part1)

        // ------- Part 2 -------
        let part2 = solve(rounds: 40)
        print(part2)

        // ------- Test -------
        assert(part1 == 2112, "WA")
        assert(part2 == 3243771149914, "WA")
    }

}
