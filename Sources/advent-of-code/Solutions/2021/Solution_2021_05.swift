//
//  Solution_2021_05.swift
//
//
//  Created by Ivan Chalov on 05.12.21.
//

import Foundation

struct Solution_2021_05: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map { line -> (from: (x: Int, y: Int), to: (x: Int, y: Int)) in
                let fromToStrings = line.components(separatedBy: " -> ")
                let from = fromToStrings[0].split(separator: ",").map { Int($0)! }
                let to = fromToStrings[1].split(separator: ",").map { Int($0)! }
                return ((from[0], from[1]), (to[0], to[1]))
            }

        // ------- Part 1 -------
        var floor = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
        input.forEach { line in
            let steps = max(abs(line.to.x - line.from.x), abs(line.to.y - line.from.y)) + 1
            let dx = (line.to.x - line.from.x).signum()
            let dy = (line.to.y - line.from.y).signum()
            guard dx == 0 || dy == 0 else { return }

            var x = line.from.x
            var y = line.from.y
            (1...steps).forEach { _ in floor[x][y] += 1; x += dx; y += dy }
        }
        let part1 = countDangerousAreas(floor)
        print(part1)

        // ------- Part 2 -------
        floor = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
        input.forEach { line in
            let steps = max(abs(line.to.x - line.from.x), abs(line.to.y - line.from.y)) + 1
            let dx = (line.to.x - line.from.x).signum()
            let dy = (line.to.y - line.from.y).signum()

            var x = line.from.x
            var y = line.from.y
            (1...steps).forEach { _ in floor[x][y] += 1; x += dx; y += dy }
        }
        let part2 = countDangerousAreas(floor)
        print(part2)

        // ------- Test -------
        assert(part1 == 7414, "WA")
        assert(part2 == 19676, "WA")
    }

}

private func countDangerousAreas(_ floor: [[Int]]) -> Int {
    floor.map { $0.filter { $0 >= 2 }.count }.reduce(0, +)
}
