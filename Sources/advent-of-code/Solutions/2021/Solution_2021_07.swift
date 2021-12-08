//
//  Solution_2021_07.swift
//
//
//  Created by Ivan Chalov on 07.12.21.
//

import Foundation

struct Solution_2021_07: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .split(separator: ",")
            .map { Int($0)! }

        // ------- Part 1 -------
        let crabs = input.reduce(into: Array(repeating: 0, count: input.max()! + 1)) { acc, x in
            acc[x] += 1
        }
        func solve(distance: (Int, Int) -> Int) -> Int {
            crabs.indices
                .map { to in
                    crabs.indices.reduce(0) { sum, from in sum + distance(from, to) }
                }
                .min()!
        }
        let part1 = solve(distance: { (abs($0 - $1) * crabs[$0]) })
        print(part1)

        // ------- Part 2 -------
        let part2 = solve(distance: { from, to in
            let fuelPerCrab = (1 + abs(from - to)) * abs(from - to) / 2
            return fuelPerCrab * crabs[from]
        })
        print(part2)

        // ------- Test -------
        assert(part1 == 344605, "WA")
        assert(part2 == 93699985, "WA")
    }

}
