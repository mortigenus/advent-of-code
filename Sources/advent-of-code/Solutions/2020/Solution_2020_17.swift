//
//  Solution_2020_17.swift
//
//
//  Created by Ivan Chalov on 17.12.20.
//

import Foundation
import Algorithms
import Prelude

private enum Cube: String {
    case active = "#"
    case inactive = "."
}

private struct Field1 {
    var dimension: [[[Cube]]]
    var plannedCycles: Int
    var initXSize: Int
    var initYSize: Int
    var initZSize = 1
    var xSize: Int
    var ySize: Int
    var zSize: Int

    init(string: String, plannedCycles: Int = 6) {
        let cubes = string
            .split(whereSeparator: \.isNewline)
            .map(mapOptional(String.init >>> Cube.init(rawValue:)))
        self.plannedCycles = plannedCycles
        initYSize = cubes.count
        initXSize = cubes[0].count
        xSize = initXSize + 2 * plannedCycles
        ySize = initYSize + 2 * plannedCycles
        zSize = initZSize + 2 * plannedCycles
        dimension = Self.empty(dimensions: (xSize, ySize, zSize))
        cubes.indexed().forEach { y, row in
            row.indexed().forEach { x, cube in
                update(x, y, 0, with: cube)
            }
        }
    }

    var activeCount: Int {
        var count = 0
        dimension.forEach { $0.forEach { count += $0.filter { $0 == .active }.count } }
        return count
    }

    mutating func update(_ x: Int, _ y: Int, _ z: Int, with cube: Cube) {
        let (x, y, z) = convertCoordinates(x, y, z)
        dimension[z][y][x] = cube
    }

    func cubeAt(_ x: Int, _ y: Int, _ z: Int) -> Cube {
        let (x, y, z) = convertCoordinates(x, y, z)
        guard
            dimension.indices ~= z,
            dimension[z].indices ~= y,
            dimension[z][y].indices ~= x
        else {
            return .inactive
        }
        return dimension[z][y][x]
    }

    private static func empty(dimensions:(x: Int, y: Int, z: Int)) -> [[[Cube]]] {
        Array(
            repeating: Array(
                repeating: Array(
                    repeating: Cube.inactive,
                    count: dimensions.x
                ),
                count: dimensions.y
            ),
            count: dimensions.z
        )
    }

    func activeAdjacentCount(_ x: Int, _ y: Int, _ z: Int) -> Int {
        let selfActive = cubeAt(x, y, z) == .active ? 1 : 0
        let (x, y, z) = convertCoordinates(x, y, z)
        let zR = (z - 1 ... z + 1).clamped(to: 0...zSize-1)
        let yR = (y - 1 ... y + 1).clamped(to: 0...ySize-1)
        let xR = (x - 1 ... x + 1).clamped(to: 0...xSize-1)
        return dimension[zR]
            .flatMap { $0[yR].flatMap { $0[xR] } }
            .filter { $0 == .active }
            .count - selfActive
    }

    private func convertCoordinates(
        _ x: Int, _ y: Int, _ z: Int
    ) -> (x: Int, y: Int, z: Int) {
        (
            x: (x + plannedCycles) % xSize,
            y: (y + plannedCycles) % ySize,
            z: (z + plannedCycles) % zSize
        )
    }
}

private struct Game1 {
    var field: Field1

    mutating func run() {
        for x in 0..<field.plannedCycles {
            cycle(number: x)
        }
    }

    mutating func cycle(number: Int) {
        var newField = field
        for z in 0-number-1...field.initZSize+number {
            for y in 0-number-1...field.initYSize+number {
                for x in 0-number-1...field.initXSize+number {
                    let activeCount = field.activeAdjacentCount(x, y, z)
                    let me = field.cubeAt(x, y, z)
                    switch me {
                    case .active:
                        if activeCount != 2 && activeCount != 3 {
                            newField.update(x, y, z, with: .inactive)
                        }
                    case .inactive:
                        if activeCount == 3 {
                            newField.update(x, y, z, with: .active)
                        }
                    }
                }
            }
        }
        field = newField
    }
}

private struct Field2 {
    var dimension: [[[[Cube]]]]
    var initXSize: Int
    var initYSize: Int
    var initZSize = 1
    var initWSize = 1
    var plannedCycles: Int
    var xSize: Int
    var ySize: Int
    var zSize: Int
    var wSize: Int

    init(string: String, plannedCycles: Int = 6) {
        let cubes = string
            .split(whereSeparator: \.isNewline)
            .map(mapOptional(String.init >>> Cube.init(rawValue:)))
        self.plannedCycles = plannedCycles
        initYSize = cubes.count
        initXSize = cubes[0].count
        xSize = initXSize + 2 * plannedCycles
        ySize = initYSize + 2 * plannedCycles
        zSize = initZSize + 2 * plannedCycles
        wSize = initWSize + 2 * plannedCycles
        dimension = Self.empty(dimensions: (xSize, ySize, zSize, wSize))
        cubes.indexed().forEach { y, row in
            row.indexed().forEach { x, cube in
                update(x, y, 0, 0, with: cube)
            }
        }
    }

    var activeCount: Int {
        var count = 0
        dimension.forEach { $0.forEach { $0.forEach { count += $0.filter { $0 == .active }.count } } }
        return count
    }

    mutating func update(_ x: Int, _ y: Int, _ z: Int, _ w: Int, with cube: Cube) {
        let (x, y, z, w) = convertCoordinates(x, y, z, w)
        dimension[w][z][y][x] = cube
    }

    func cubeAt(_ x: Int, _ y: Int, _ z: Int, _ w: Int) -> Cube {
        let (x, y, z, w) = convertCoordinates(x, y, z, w)
        guard
            dimension.indices ~= w,
            dimension[w].indices ~= z,
            dimension[w][z].indices ~= y,
            dimension[w][z][y].indices ~= x
        else {
            return .inactive
        }
        return dimension[w][z][y][x]
    }

    private static func empty(dimensions:(x: Int, y: Int, z: Int, w: Int)) -> [[[[Cube]]]] {
        Array(
            repeating: Array(
                repeating: Array(
                    repeating: Array(
                        repeating: Cube.inactive,
                        count: dimensions.x
                    ),
                    count: dimensions.y
                ),
                count: dimensions.z
            ),
            count: dimensions.w
        )
    }

    func activeAdjacentCount(_ x: Int, _ y: Int, _ z: Int, _ w: Int) -> Int {
        let selfActive = cubeAt(x, y, z, w) == .active ? 1 : 0
        let (x, y, z, w) = convertCoordinates(x, y, z, w)
        let wR = (w - 1 ... w + 1).clamped(to: 0...wSize-1)
        let zR = (z - 1 ... z + 1).clamped(to: 0...zSize-1)
        let yR = (y - 1 ... y + 1).clamped(to: 0...ySize-1)
        let xR = (x - 1 ... x + 1).clamped(to: 0...xSize-1)
        return dimension[wR]
            .flatMap { $0[zR].flatMap { $0[yR].flatMap { $0[xR] } } }
            .filter { $0 == .active }
            .count - selfActive
    }

    private func convertCoordinates(
        _ x: Int, _ y: Int, _ z: Int, _ w: Int
    ) -> (x: Int, y: Int, z: Int, w: Int) {
        (
            x: (x + plannedCycles) % xSize,
            y: (y + plannedCycles) % ySize,
            z: (z + plannedCycles) % zSize,
            w: (w + plannedCycles) % wSize
        )
    }
}

private struct Game2 {
    var field: Field2

    mutating func run() {
        for x in 0..<field.plannedCycles {
            cycle(number: x)
        }
    }

    mutating func cycle(number: Int) {
        var newField = field
        for w in 0-number-1...field.initWSize+number {
            for z in 0-number-1...field.initZSize+number {
                for y in 0-number-1...field.initYSize+number {
                    for x in 0-number-1...field.initXSize+number {
                        let me = field.cubeAt(x, y, z, w)
                        let activeCount = field.activeAdjacentCount(x, y, z, w)
                        switch me {
                        case .active:
                            if activeCount != 2 && activeCount != 3 {
                                newField.update(x, y, z, w, with: .inactive)
                            }
                        case .inactive:
                            if activeCount == 3 {
                                newField.update(x, y, z, w, with: .active)
                            }
                        }
                    }
                }
            }
        }
        field = newField
    }
}


struct Solution_2020_17: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()

        // ------- Part 1 -------
        var game1 = Game1(field: Field1(string: input))
        game1.run()
        let part1 = game1.field.activeCount
        print(part1)

        // ------- Part 2 -------
        var game2 = Game2(field: Field2(string: input))
        game2.run()
        let part2 = game2.field.activeCount
        print(part2)

        // ------- Test -------
        assert(part1 == 276, "WA")
        assert(part2 == 2136, "WA")
    }
}
