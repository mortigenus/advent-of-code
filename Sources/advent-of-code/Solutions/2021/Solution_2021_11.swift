//
//  Solution_2021_11.swift
//
//
//  Created by Ivan Chalov on 11.12.21.
//

import Foundation

struct Solution_2021_11: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map { $0.map { Int(String($0))! } }

        // ------- Part 1 -------
        let octopusesSeq = sequence(
            state: input,
            next: { state -> Int in
                incrementAll(&state)
                return walkAll(&state)
            })

        let part1 = octopusesSeq.prefix(100).reduce(0, +)
        print(part1)

        // ------- Part 2 -------
        let octopusesCount = input.count * input.first!.count
        let part2 = octopusesSeq
            .enumerated()
            .first(where: { $0.element == octopusesCount })!
            .offset + 1
        print(part2)

        // ------- Test -------
        assert(part1 == 1723, "WA")
        assert(part2 == 327, "WA")
    }

}

private func incrementAll(_ m: inout [[Int]]) {
    for i in m.indices {
        for j in m[i].indices {
            m[i][j] += 1
        }
    }
}

private func walkAll(_ m: inout [[Int]]) -> Int {
    m.indices
        .map { i in
            m[i].indices
                .map { j in walkOctopuses(i: i, j: j, &m) }
                .reduce(0, +)
        }
        .reduce(0, +)
}

private func bumpAdjacent(i: Int, j: Int, _ m: inout [[Int]]) {
    [(1, 1), (1, 0), (1, -1), (0, 1), (0, -1), (-1, 1), (-1, 0), (-1, -1)]
        .forEach { dirI, dirJ in
            let (idxI, idxJ) = (i + dirI, j + dirJ)
            if m.indices ~= idxI, m[idxI].indices ~= idxJ, m[idxI][idxJ] != 0 {
                m[idxI][idxJ] += 1
            }
        }
}

private func walkOctopuses(i: Int, j: Int, _ m: inout [[Int]]) -> Int {
    guard m[i][j] > 9 else { return 0 }

    m[i][j] = 0
    bumpAdjacent(i: i, j: j, &m)
    return 1 + [(1, 1), (1, 0), (1, -1), (0, 1), (0, -1), (-1, 1), (-1, 0), (-1, -1)]
        .compactMap { dirI, dirJ in
            let (idxI, idxJ) = (i + dirI, j + dirJ)
            return m.indices ~= idxI && m[idxI].indices ~= idxJ
            ? walkOctopuses(i: idxI, j: idxJ, &m)
            : nil
        }.reduce(0, +)
}
