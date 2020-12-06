//
//  Solution_2020_06.swift
//
//
//  Created by Ivan Chalov on 06.12.20.
//

import Foundation

struct Solution_2020_06: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .components(separatedBy: "\n\n")

        // ------- Part 1 -------
        let groups = input.map { $0.split(whereSeparator: \.isNewline).map(Set.init) }
        let part1 = groups.map { $0.scan { $0.union($1) }.count }.sum()
        print(part1)

        // ------- Part 2 -------
        let part2 = groups.map { $0.scan { $0.intersection($1) }.count }.sum()
        print(part2)

        // ------- Test -------
        assert(part1 == 6714, "WA")
        assert(part2 == 3435, "WA")
    }
}
