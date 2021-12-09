//
//  Solution_2021_09.swift
//
//
//  Created by Ivan Chalov on 09.12.21.
//

import Foundation

struct Solution_2021_09: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map { $0.map { Int(String($0))! } }
            .map(Array.init)

        // ------- Part 1 -------
        let lowPoints = input.indices.flatMap { i in
            input[i].indices.compactMap { j in
                adjacent(i: i, j: j, input).allSatisfy { $0 > input[i][j] }
                ? (i: i , j: j)
                : nil
            }
        }
        let part1 = lowPoints.map { 1 + input[$0.i][$0.j] }.reduce(0, +)
        print(part1)

        // ------- Part 2 -------
        let part2 = lowPoints.map { 1 + walkBasin(i: $0.i, j: $0.j, input).count }.sorted().suffix(3).reduce(1, *)
        print(part2)

        // ------- Test -------
        assert(part1 == 580, "WA")
        assert(part2 == 856716, "WA")
    }

}

private func adjacent(i: Int, j: Int, _ m: [[Int]]) -> [Int] {
    [(1, 0), (0, 1), (0, -1), (-1, 0)]
        .compactMap { dirI, dirJ in
            let (idxI, idxJ) = (i + dirI, j + dirJ)
            return m.indices ~= idxI && m[idxI].indices ~= idxJ
            ? m[idxI][idxJ]
            : nil
        }
}

private struct Point: Hashable { var i, j: Int }
private func walkBasin(i: Int, j: Int, _ m: [[Int]]) -> Set<Point> {
    [(1, 0), (0, 1), (0, -1), (-1, 0)]
        .compactMap { dirI, dirJ -> Set<Point>? in
            let (idxI, idxJ) = (i + dirI, j + dirJ)
            return m.indices ~= idxI && m[idxI].indices ~= idxJ && m[idxI][idxJ] > m[i][j] && m[idxI][idxJ] != 9
            ? Set([Point(i: idxI, j: idxJ)]).union(walkBasin(i: idxI, j: idxJ, m))
            : nil
        }
        .reduce(into: Set<Point>()) { acc, x in acc.formUnion(x) }
}
