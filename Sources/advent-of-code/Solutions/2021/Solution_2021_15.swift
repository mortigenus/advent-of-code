//
//  Solution_2021_15.swift
//
//
//  Created by Ivan Chalov on 15.12.21.
//

import Foundation
import SortedCollections

struct Solution_2021_15: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map { $0.map { Int(String($0))! }}

        // ------- Part 1 -------
        func solve(target: Point, map: [[Int]]) -> Int? {
            let vertices = map.indices.flatMap { i in map[i].indices.map { j in Point(i: i, j: j) } }
            var minDistance = Dictionary(uniqueKeysWithValues: vertices.map { ($0, Int.max) })
            minDistance[vertices[0]] = 0

            var queue = SortedSet([DistPoint(point: vertices[0], distance: 0)])

            while !queue.isEmpty {
                let min = queue.removeFirst()

                if min.point == vertices.last {
                    return minDistance[min.point]!
                }

                for next in adjacent(i: min.point.i, j: min.point.j, map) {
                    let newDistance = min.distance + map[next.i][next.j]
                    if newDistance < minDistance[next]! {
                        queue.remove(DistPoint(point: next, distance: minDistance[next]!))

                        minDistance[next] = newDistance
                        queue.insert(DistPoint(point: next, distance: minDistance[next]!))
                    }
                }

            }
            return nil

        }
        let part1 = solve(target: Point(i: 99, j: 99), map: input)!
        print(part1)

        // ------- Part 2 -------
        var newMap = Array(repeating: Array(repeating: 0, count: 500), count: 500)
        for d in 0..<5 {
            for r in 0..<5 {
                for i in input.indices {
                    for j in input[i].indices {
                        var newValue = input[i][j] + r + d
                        if newValue > 9 { newValue -= 9 }
                        newMap[d * input.count + i][r * input.first!.count + j] = newValue
                    }
                }
            }
        }
        let part2 = solve(target: Point(i: 499, j: 499), map: newMap)!
        print(part2)

        // ------- Test -------
        assert(part1 == 361, "WA")
        assert(part2 == 2838, "WA")
    }

}

private struct Point: Hashable { var i, j: Int }
private struct DistPoint: Hashable, Comparable {
    var point: Point, distance: Int

    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.distance < rhs.distance
    }
}

private func adjacent(i: Int, j: Int, _ m: [[Int]]) -> [Point] {
    [(1, 0), (0, 1), (0, -1), (-1, 0)]
        .compactMap { dirI, dirJ in
            let (idxI, idxJ) = (i + dirI, j + dirJ)
            return m.indices ~= idxI && m[idxI].indices ~= idxJ
            ? Point(i: idxI, j: idxJ)
            : nil
        }
}
