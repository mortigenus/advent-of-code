//
//  Solution_2021_22.swift
//
//
//  Created by Ivan Chalov on 22.12.21.
//

import Foundation

struct Solution_2021_22: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map { line -> (sign: Bool, coordinates: [ClosedRange<Int>]) in
                let instruction = line.split(maxSplits: 1, whereSeparator: \.isWhitespace)
                return (
                    instruction[0] == "on",
                    instruction[1]
                        .split(separator: ",")
                        .map { $0.dropFirst(2).components(separatedBy: "..").map { Int($0)! } }
                        .map { $0[0]...$0[1] }
                )
            }

        // ------- Part 1 -------
        func solve(_ filter: (([ClosedRange<Int>]) -> Bool)? = nil) -> Int {
            var cubeCounter = [[ClosedRange<Int>]: Int]()
            func intersect(_ range1: ClosedRange<Int>, _ range2: ClosedRange<Int>) -> ClosedRange<Int>? {
                let rLower = max(range1.lowerBound, range2.lowerBound)
                let rUpper = min(range1.upperBound, range2.upperBound)
                return rUpper >= rLower ? rLower...rUpper : nil
            }
            for instruction in input {
                guard filter?(instruction.coordinates) ?? true else { continue }
                for (coordinates, sign) in cubeCounter {
                    let intersected = zip(instruction.coordinates, coordinates).compactMap(intersect)
                    if intersected.count == 3 { cubeCounter[intersected, default: 0] -= sign }
                }
                if instruction.sign { cubeCounter[instruction.coordinates, default: 0] += 1 }
            }

            func volume(_ coords: [ClosedRange<Int>]) -> Int { coords.map(\.count).product() }
            return cubeCounter.map { $0.value * volume($0.key) }.sum()
        }

        let part1 = solve { coordinates in
            (-50...50) ~= coordinates[0].lowerBound &&
            (-50...50) ~= coordinates[0].upperBound &&
            (-50...50) ~= coordinates[1].lowerBound &&
            (-50...50) ~= coordinates[1].upperBound &&
            (-50...50) ~= coordinates[2].lowerBound &&
            (-50...50) ~= coordinates[2].upperBound
        }
        print(part1)

        // ------- Part 2 -------
        let part2 = solve()
        print(part2)

        // ------- Test -------
        assert(part1 == 537042, "WA")
        assert(part2 == 1304385553084863, "WA")
    }

}
