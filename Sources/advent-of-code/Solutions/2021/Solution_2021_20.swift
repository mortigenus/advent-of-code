//
//  Solution_2021_20.swift
//
//
//  Created by Ivan Chalov on 20.12.21.
//

import Foundation
import SortedCollections

struct Solution_2021_20: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .components(separatedBy: "\n\n")

        let algorithm = input[0].map(pixelToInt)
        let image = input[1]
            .split(whereSeparator: \.isNewline)
            .map { $0.map(pixelToInt) }
            .enumerated()
            .reduce(into: Dictionary<Point, Int>()) { acc, line in
                line.element.indices.forEach { j in
                    acc[Point(i: line.offset, j: j)] = line.element[j]
                }
            }

        // ------- Part 1 -------
        func solve(rounds: Int) -> Int {
            var image = image
            for round in 1...rounds {
                var newImage = image
                for i in -round..<100+round { for j in -round..<100+round {
                    let point = Point(i: i, j: j)
                    // algorithm[0] == 0 and algorithm[512] == 0 in my input
                    // => points around the image change from 0 to 1 and back depending on the round
                    let algorithmIndex = point.adjacent().map { image[$0, default: (round + 1) % 2] }.fromBinary()
                    newImage[point] = algorithm[algorithmIndex]
                }}
                image = newImage
            }
            return image.filter { $0.value == 1 }.count
        }
        let part1 = solve(rounds: 2)
        print(part1)

        // ------- Part 2 -------
        let part2 = solve(rounds: 50)
        print(part2)

        // ------- Test -------
        assert(part1 == 5349, "WA")
        assert(part2 == 15806, "WA")
    }

}

private struct Point: Hashable {
    var i, j: Int

    func adjacent() -> [Point] {
        [
            (-1,-1), (-1, 0), (-1, 1),
            ( 0,-1), ( 0, 0), ( 0, 1),
            ( 1,-1), ( 1, 0), ( 1, 1),
        ]
            .map { Point(i: i + $0.0, j: j + $0.1) }
    }
}

private func pixelToInt(_ c: Character) -> Int {
    return c == "#" ? 1 : 0
}

private extension Collection where Element == Int {
    func fromBinary() -> Int {
        self.reversed().reduce((sum: 0, mult: 1)) { acc, x in (acc.sum + x * acc.mult, acc.mult * 2) }.sum
    }
}
