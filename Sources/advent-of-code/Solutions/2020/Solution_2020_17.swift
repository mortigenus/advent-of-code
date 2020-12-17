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
    var dimension = Self.emptyDimension
    static var initXSize = 8
    static var initYSize = 8
    static var initZSize = 1
    static var plannedCycles = 6
    static var xSize = initXSize + 2 * plannedCycles
    static var ySize = initYSize + 2 * plannedCycles
    static var zSize = initZSize + 2 * plannedCycles

    init(string: String) {
        string
            .split(whereSeparator: \.isNewline)
            .map(mapOptional(String.init >>> Cube.init(rawValue:)))
            .indexed()
            .forEach { y, row in
                row.indexed().forEach { x, cube in
                    update(x, y, 0, with: cube)
                }
            }
    }

    var activeCount: Int {
        var active = 0
        dimension.forEach { ys in ys.forEach { xs in xs.forEach { if $0 == .active { active += 1 } } } }
        return active
    }

    mutating func update(_ x: Int, _ y: Int, _ z: Int, with cube: Cube) {
        let x = (x + Self.plannedCycles) % Self.xSize
        let y = (y + Self.plannedCycles) % Self.ySize
        let z = (z + Self.plannedCycles) % Self.zSize
        dimension[z][y][x] = cube
    }

    func cubeAt(_ x: Int, _ y: Int, _ z: Int) -> Cube? {
        let x = (x + Self.plannedCycles) % Self.xSize
        let y = (y + Self.plannedCycles) % Self.ySize
        let z = (z + Self.plannedCycles) % Self.zSize
        guard
            dimension.indices ~= z,
            dimension[z].indices ~= y,
            dimension[z][y].indices ~= x
        else {
            return nil
        }
        return dimension[z][y][x]
    }

    static var emptyDimension: [[[Cube]]] {
        Array(
            repeating: Array(
                repeating: Array(
                    repeating: Cube.inactive,
                    count: xSize
                ),
                count: ySize
            ),
            count: zSize
        )
    }

    func adjacent(_ x: Int, _ y: Int, _ z: Int) -> [Cube] {
        let curriedGet = curry(cubeAt)
        let xGets = [curriedGet(x - 1), curriedGet(x), curriedGet(x + 1)]
        let yGets = xGets.flatMap { [$0(y - 1), $0(y), $0(y + 1)] }
        var zGets = yGets.flatMap { [$0(z - 1), $0(z), $0(z + 1)] }
        zGets[13] = .inactive // inactive cubes do not interfere with rules, so it's fine
        return zGets.compactMap(id)
    }
}

private struct Game1 {
    var field: Field1

    mutating func run() {
        for x in 0..<Field1.plannedCycles {
            cycle(number: x)
        }
    }

    mutating func cycle(number: Int) {
        var newField = field
        for z in 0-number-1...Field1.initZSize+number {
            for y in 0-number-1...Field1.initYSize+number {
                for x in 0-number-1...Field1.initXSize+number {
                    let near = field.adjacent(x, y, z)
                    let me = field.cubeAt(x, y, z)!
                    let activeCount = near.filter { $0 == .active }.count
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
    var dimension = Self.emptyDimension
    static var initXSize = 8
    static var initYSize = 8
    static var initZSize = 1
    static var initWSize = 1
    static var plannedCycles = 6
    static var xSize = initXSize + 2 * plannedCycles
    static var ySize = initYSize + 2 * plannedCycles
    static var zSize = initZSize + 2 * plannedCycles
    static var wSize = initWSize + 2 * plannedCycles

    init(string: String) {
        string
            .split(whereSeparator: \.isNewline)
            .map(mapOptional(String.init >>> Cube.init(rawValue:)))
            .indexed()
            .forEach { y, row in
                row.indexed().forEach { x, cube in
                    update(x, y, 0, 0, with: cube)
                }
            }
    }

    var activeCount: Int {
        var active = 0
        dimension.forEach {
            zs in zs.forEach {
                ys in ys.forEach {
                    xs in xs.forEach {
                        if $0 == .active { active += 1 }
                    }
                }
            }
        }
        return active
    }

    mutating func update(_ x: Int, _ y: Int, _ z: Int, _ w: Int, with cube: Cube) {
        let x = (x + Self.plannedCycles) % Self.xSize
        let y = (y + Self.plannedCycles) % Self.ySize
        let z = (z + Self.plannedCycles) % Self.zSize
        let w = (w + Self.plannedCycles) % Self.wSize
        dimension[w][z][y][x] = cube
    }

    func cubeAt(_ x: Int, _ y: Int, _ z: Int, _ w: Int) -> Cube? {
        let x = (x + Self.plannedCycles) % Self.xSize
        let y = (y + Self.plannedCycles) % Self.ySize
        let z = (z + Self.plannedCycles) % Self.zSize
        let w = (w + Self.plannedCycles) % Self.wSize
        guard
            dimension.indices ~= w,
            dimension[w].indices ~= z,
            dimension[w][z].indices ~= y,
            dimension[w][z][y].indices ~= x
        else {
            return nil
        }
        return dimension[w][z][y][x]
    }

    static var emptyDimension: [[[[Cube]]]] {
        Array(
            repeating: Array(
                repeating: Array(
                    repeating: Array(
                        repeating: Cube.inactive,
                        count: xSize
                    ),
                    count: ySize
                ),
                count: zSize
            ),
            count: wSize
        )
    }

    func adjacent(_ x: Int, _ y: Int, _ z: Int, _ w: Int) -> [Cube] {
        let curriedGet = curry(cubeAt)
        let xGets = [curriedGet(x - 1), curriedGet(x), curriedGet(x + 1)]
        let yGets = xGets.flatMap { [$0(y - 1), $0(y), $0(y + 1)] }
        let zGets = yGets.flatMap { [$0(z - 1), $0(z), $0(z + 1)] }
        var wGets = zGets.flatMap { [$0(w - 1), $0(w), $0(w + 1)] }
        wGets[40] = .inactive // inactive cubes do not interfere with rules, so it's fine
        return wGets.compactMap(id)
    }
}

private struct Game2 {
    var field: Field2

    mutating func run() {
        for x in 0..<Field2.plannedCycles {
            cycle(number: x)
        }
    }

    mutating func cycle(number: Int) {
        var newField = field
        for w in 0-number-1...Field2.initWSize+number {
            for z in 0-number-1...Field2.initZSize+number {
                for y in 0-number-1...Field2.initYSize+number {
                    for x in 0-number-1...Field2.initXSize+number {
                        let near = field.adjacent(x, y, z, w)
                        let me = field.cubeAt(x, y, z, w)!
                        let activeCount = near.filter { $0 == .active }.count
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
