//
//  Solution_2021_19.swift
//
//
//  Created by Ivan Chalov on 19.12.21.
//

import Foundation

struct Solution_2021_19: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .components(separatedBy: "\n\n")
            .map { $0.split(whereSeparator: \.isNewline).dropFirst() }
            .map { $0.map { $0.split(separator: ",").map { Int($0)! } } }
            .map { $0.map(Point.init) }

        // ------- Part 1 -------
        var coordinates = input
        let distances = coordinates.map(allDistances)
        func commonPoints(_ first: Int, _ second: Int) -> [(i: Int, j: Int)] {
            let secondDistanceSets = distances[second].map(Set.init)
            return distances[first].indices.flatMap { i in
                secondDistanceSets.indices.compactMap { j in
                    return distances[first][i].filter { secondDistanceSets[j].contains($0) }.count >= 12
                    ? (i, j)
                    : nil
                }
            }
        }

        var scannerCoords: [Point?] = Array(repeating: .none, count: coordinates.count)
        scannerCoords[0] = Point([0, 0, 0])

        while scannerCoords.contains(where: { $0 == nil }) {
            for first in scannerCoords.indices where scannerCoords[first] != nil {
                for second in scannerCoords.indices.dropFirst() where scannerCoords[second] == nil {
                    let ps = commonPoints(first, second)
                    guard ps.count >= 12 else { continue }
                    var countX = [Int: Int]()
                    var countY = [Int: Int]()
                    var countZ = [Int: Int]()

                    for (i, j) in ps {
                        countX[coordinates[first][i].x - coordinates[second][j].x, default: 0] += 1
                        countX[coordinates[first][i].x + coordinates[second][j].x, default: 0] += 1
                        countX[coordinates[first][i].x - coordinates[second][j].y, default: 0] += 1
                        countX[coordinates[first][i].x + coordinates[second][j].y, default: 0] += 1
                        countX[coordinates[first][i].x - coordinates[second][j].z, default: 0] += 1
                        countX[coordinates[first][i].x + coordinates[second][j].z, default: 0] += 1

                        countY[coordinates[first][i].y - coordinates[second][j].y, default: 0] += 1
                        countY[coordinates[first][i].y + coordinates[second][j].y, default: 0] += 1
                        countY[coordinates[first][i].y - coordinates[second][j].z, default: 0] += 1
                        countY[coordinates[first][i].y + coordinates[second][j].z, default: 0] += 1
                        countY[coordinates[first][i].y - coordinates[second][j].x, default: 0] += 1
                        countY[coordinates[first][i].y + coordinates[second][j].x, default: 0] += 1

                        countZ[coordinates[first][i].z - coordinates[second][j].z, default: 0] += 1
                        countZ[coordinates[first][i].z + coordinates[second][j].z, default: 0] += 1
                        countZ[coordinates[first][i].z - coordinates[second][j].x, default: 0] += 1
                        countZ[coordinates[first][i].z + coordinates[second][j].x, default: 0] += 1
                        countZ[coordinates[first][i].z - coordinates[second][j].y, default: 0] += 1
                        countZ[coordinates[first][i].z + coordinates[second][j].y, default: 0] += 1
                    }
                    let countXMax = countX.max(by: { $0.value < $1.value })!.key
                    let countYMax = countY.max(by: { $0.value < $1.value })!.key
                    let countZMax = countZ.max(by: { $0.value < $1.value })!.key

                    var rotation: [(Point) -> Int] = Array(repeating: { _ in fatalError() }, count: 3)
                    let firstCommon = coordinates[first][ps[0].i]
                    let secondCommon = coordinates[second][ps[0].j]
                    switch countXMax {
                    case firstCommon.x - secondCommon.x, firstCommon.x + secondCommon.x:
                        rotation[0] = \.x
                        switch countYMax {
                        case firstCommon.y - secondCommon.y, firstCommon.y + secondCommon.y:
                            rotation[1] = \.y
                            rotation[2] = \.z
                        case firstCommon.y - secondCommon.z, firstCommon.y + secondCommon.z:
                            rotation[1] = \.z
                            rotation[2] = \.y
                        default:
                            fatalError()
                        }
                    case firstCommon.x - secondCommon.y, firstCommon.x + secondCommon.y:
                        rotation[0] = \.y
                        switch countYMax {
                            case firstCommon.y - secondCommon.z, firstCommon.y + secondCommon.z:
                            rotation[1] = \.z
                            rotation[2] = \.x
                        case firstCommon.y - secondCommon.x, firstCommon.y + secondCommon.x:
                            rotation[1] = \.x
                            rotation[2] = \.z
                        default:
                            fatalError()
                        }
                    case firstCommon.x - secondCommon.z, firstCommon.x + secondCommon.z:
                        rotation[0] = \.z
                        switch countYMax {

                        case firstCommon.y - secondCommon.x, firstCommon.y + secondCommon.x:
                            rotation[1] = \.x
                            rotation[2] = \.y
                        case firstCommon.y - secondCommon.y, firstCommon.y + secondCommon.y:
                            rotation[1] = \.y
                            rotation[2] = \.x
                        default:
                            fatalError()
                        }
                    default:
                        fatalError()
                    }
                    let secondCoord = [countXMax, countYMax, countZMax]
                    let signs = secondCoord.indices.map {
                        secondCoord[$0] == firstCommon[$0] - rotation[$0](secondCommon) ? 1 : -1
                    }
                    coordinates[second] = coordinates[second].map { point in
                        Point(secondCoord.indices.map {
                            signs[$0] * (rotation[$0](point) + signs[$0] * secondCoord[$0])
                        })
                    }
                    scannerCoords[second] = Point(secondCoord)
                    for (i, j) in ps {
                        assert(coordinates[first][i] == coordinates[second][j])
                    }
                }
            }
        }
        let part1 = coordinates.reduce(into: Set<Point>()) { $0.formUnion($1) }.count
        print(part1)

        // ------- Part 2 -------
        let part2 = allDistances(scannerCoords.map{ $0! }).joined().max()!
        print(part2)

        // ------- Test -------
        assert(part1 == 462, "WA")
        assert(part2 == 12158, "WA")
    }

}

private struct Point: Hashable {
    var x: Int { coords[0] }
    var y: Int { coords[1] }
    var z: Int { coords[2] }
    private var coords: [Int]
    init(_ xs: [Int]) { coords = xs }

    func distance(to point: Point) -> Int {
        zip(coords, point.coords).map { abs($0.1 - $0.0) }.reduce(0, +)
    }

    subscript(_ i: Int) -> Int { coords[i] }
}

private func allDistances(_ points: [Point]) -> [[Int]] {
    points.reduce(into: []) { acc, point in
        acc.append(points.map { $0.distance(to: point) })
    }
}
