//
//  Solution_2021_02.swift
//
//
//  Created by Ivan Chalov on 02.12.21.
//

import Foundation

struct Solution_2021_02: Solution {
    var input: Input

    enum Direction: String {
        case forward
        case up
        case down
    }

    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map { $0.split(whereSeparator: \.isWhitespace) }
            .map {
                (
                    direction: Direction(rawValue: String($0[0]))!,
                    value: Int($0[1])!
                )
            }


        // ------- Part 1 -------
        let (x1, y1): (x: Int, y: Int) = input.reduce((x: 0, y: 0)) { acc, command in
            switch command.direction {
            case .forward:
                return (acc.x + command.value, acc.y)
            case .up:
                return (acc.x, acc.y - command.value)
            case .down:
                return (acc.x, acc.y + command.value)
            }
        }
        let part1 = x1 * y1
        print(part1)

        // ------- Part 2 -------
        let (x2, y2, _): (x: Int, y: Int, aim: Int) = input.reduce((x: 0, y: 0, aim: 0)) { acc, command in
            switch command.direction {
            case .forward:
                return (acc.x + command.value, acc.y + acc.aim * command.value, acc.aim)
            case .up:
                return (acc.x, acc.y, acc.aim - command.value)
            case .down:
                return (acc.x, acc.y, acc.aim + command.value)
            }
        }
        let part2 = x2 * y2
        print(part2)

        // ------- Test -------
        assert(part1 == 1924923, "WA")
        assert(part2 == 1982495697, "WA")
    }

}
