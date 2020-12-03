//
//  Solution_2020_03.swift
//  
//
//  Created by Ivan Chalov on 03.12.20.
//

import Foundation
import Algorithms

private enum Point {
    case empty
    case tree

    init(character: Character) {
        switch character {
        case "#":
            self = .tree
        case ".":
            self = .empty
        default:
            fatalError("Incorrect Input")
        }
    }
}

struct Solution_2020_03: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init)
            .map { $0.map(Point.init(character:)) }

        // ------- Part 1 -------
        func solve(steps: [(x: Int, y: Int)]) -> Int {
            let width = input[0].count
            return input.indices
                .reduce(into: Array(repeating: 0, count: steps.count)) { acc, row in
                    steps.indexed()
                        .filter { _, step in
                            row % step.y == 0
                        }
                        .map { index, step in
                            (index: index, element: step.x * (row / step.y) % width)
                        }
                        .filter { _, column in
                            input[row][column] == .tree
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
