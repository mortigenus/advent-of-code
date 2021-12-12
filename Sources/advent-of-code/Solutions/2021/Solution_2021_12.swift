//
//  Solution_2021_12.swift
//
//
//  Created by Ivan Chalov on 12.12.21.
//

import Foundation

struct Solution_2021_12: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map { $0.split(separator: "-") }
            .map { (String($0[0]), String($0[1])) }

        // ------- Part 1 -------
        let map: [String: [String]] = input.reduce(into: [:]) { acc, x in
            acc[x.0, default: []].append(x.1)
            acc[x.1, default: []].append(x.0)
        }
        let part1 = walk("start", map).count
        print(part1)

        // ------- Part 2 -------
        let part2 = map.keys
            .filter { $0 != "start" && $0 != "end" && $0.first!.isLowercase }
            .map { walk("start", map, $0) }
            .reduce(into: Set()) { $0.formUnion($1) }
            .count
        print(part2)

        // ------- Test -------
        assert(part1 == 5212, "WA")
        assert(part2 == 134862, "WA")
    }

}

private func walk(
    _ cave: String,
    _ map: [String: [String]],
    _ possibleTwice: String? = nil,
    _ visited: Set<String> = [],
    _ path: [String] = []
) -> Set<[String]> {
    guard cave != "end" else { return Set([path]) }
    guard possibleTwice == cave || !cave.first!.isLowercase || !visited.contains(cave) else { return Set() }

    let newPossibleTwice = possibleTwice == cave ? nil : possibleTwice
    let newVisited = possibleTwice == cave
    ? visited
    : (cave.first!.isLowercase ? visited.union([cave]) : visited)

    return map[cave]!
        .map { nextCave in
            walk(
                nextCave,
                map,
                newPossibleTwice,
                newVisited,
                path + [cave]
            )
        }
        .reduce(into: Set()) { $0.formUnion($1) }
}
