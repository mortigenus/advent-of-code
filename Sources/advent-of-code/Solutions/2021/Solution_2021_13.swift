//
//  Solution_2021_13.swift
//
//
//  Created by Ivan Chalov on 13.12.21.
//

import Foundation

struct Solution_2021_13: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .components(separatedBy: "\n\n")
            .map { $0.split(whereSeparator: \.isNewline) }
        let dots = input[0]
            .map { $0.split(separator: ",") }
            .map { (x: Int($0[0])!, y: Int($0[1])!) }
        let folds = input[1]
            .map { $0.split(whereSeparator: \.isWhitespace).last! }
            .map { $0.split(separator: "=") }
            .map { (axis: $0[0], value: Int($0[1])!) }
        
        // ------- Part 1 -------
        var field = Array(repeating: Array(repeating: 0, count: 2000), count: 2000)
        for dot in dots {
            field[dot.y][dot.x] += 1
        }

        let instruction = folds[0]
        var max = (x: 2000, y: 2000)
        max = fold(axis: instruction.axis, value: instruction.value, &field, max)
        let part1 = field.map { $0.filter { $0 > 0 }.count }.reduce(0, +)
        print(part1)

        // ------- Part 2 -------
        folds.dropFirst().forEach {
            max = fold(axis: $0.axis, value: $0.value, &field, max)
        }
        for xs in field[...max.y] {
            for x in xs[...max.x] {
                print(x > 0 ? "#" : " ", terminator: "")
            }
            print("")
        }
        let part2 = "BLKJRBAG" // magic OCR with eyes

        // ------- Test -------
        assert(part1 == 755, "WA")
        assert(part2 == "BLKJRBAG", "WA")
    }

}

private func fold(axis: Substring, value: Int, _ m: inout [[Int]], _ max: (x: Int, y: Int)) -> (x: Int, y: Int) {
    switch axis {
    case "x":
        for i in m.indices[..<max.y] {
            for j in m[i].indices[value..<max.x] {
                if m[i][j] > 0 {
                    m[i][2 * value - j] += m[i][j]
                    m[i][j] = 0
                }
            }
        }
        return (value, max.y)
    case "y":
        for i in m.indices[value..<max.y] {
            for j in m[i].indices[..<max.x] {
                if m[i][j] > 0 {
                    m[2 * value - i][j] += m[i][j]
                    m[i][j] = 0
                }
            }
        }
        return (max.x, value)
    default: fatalError()
    }
}
