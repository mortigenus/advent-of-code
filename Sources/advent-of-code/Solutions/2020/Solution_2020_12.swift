//
//  Solution_2020_12.swift
//
//
//  Created by Ivan Chalov on 12.12.20.
//

import Foundation
import Algorithms
import Prelude

private enum Command {
    case move(Direction)
    case rotate(clockwise: Bool)
    case forward

    init(string: String) {
        switch string {
        case "N", "E", "W", "S":
            self = .move(Direction(rawValue: string)!)
        case "L":
            self = .rotate(clockwise: false)
        case "R":
            self = .rotate(clockwise: true)
        case "F":
            self = .forward
        default:
            fatalError("Incorrect Input")
        }
    }
}

private enum Direction: String, CaseIterable {
    case north = "N"
    case east = "E"
    case south = "S"
    case west = "W"

    var unitVector: (x: Int, y: Int) {
        switch self {
        case .north: return ( 0,  1)
        case .east:  return ( 1,  0)
        case .south: return ( 0, -1)
        case .west:  return (-1,  0)
        }
    }

    mutating func rotate(by degrees: Int, clockwise: Bool = true) {
        let directions = Direction.allCases
        var value = degrees / 90 % directions.count
        if !clockwise { value = directions.count - value }
        self = directions[(directions.firstIndex(of: self)! + value) % directions.count]
    }
}

private struct Instruction {
    var command: Command
    var value: Int
}

extension Instruction {
    init(string: String) {
        self.init(
            command: Command(string: String(string.prefix(1))),
            value: Int(string.dropFirst())!
        )
    }
}

private protocol Navigation {
    var position: (x: Int, y: Int) { get }
    var manhattanDistance: Int { get }
    func advance(_ coordinates: inout (x: Int, y: Int), by value: Int, in direction: Direction)
}

extension Navigation {
    var manhattanDistance: Int {
        abs(position.x) + abs(position.y)
    }
    func advance(_ coordinates: inout (x: Int, y: Int), by value: Int, in direction: Direction) {
        let unitVector = direction.unitVector
        coordinates.x += value * unitVector.x
        coordinates.y += value * unitVector.y
    }
}

private struct Navigation1: Navigation {
    var position: (x: Int, y: Int) = (0, 0)
    var facing: Direction = .east

    mutating func apply(_ instruction: Instruction) {
        switch instruction.command {
        case let .move(direction):
            advance(&position, by: instruction.value, in: direction)
        case let .rotate(clockwise: clockwise):
            facing.rotate(by: instruction.value, clockwise: clockwise)
        case .forward:
            advance(&position, by: instruction.value, in: facing)
        }
    }
}

private struct Navigation2: Navigation {
    var position: (x: Int, y: Int) = (0, 0)
    var waypoint: (x: Int, y: Int) = (10, 1)

    mutating func apply(_ instruction: Instruction) {
        switch instruction.command {
        case let .move(direction):
            advance(&waypoint, by: instruction.value, in: direction)
        case let .rotate(clockwise: clockwise):
            rotate(by: instruction.value, clockwise: clockwise)
        case .forward:
            moveToWaypoint(times: instruction.value)
        }
    }

    mutating func rotate(by degrees: Int, clockwise: Bool = true) {
        let radians = degrees.radians() * (clockwise ? -1 : 1)
        waypoint = (
            x: lround(cos(radians) * Double(waypoint.x) - sin(radians) * Double(waypoint.y)),
            y: lround(sin(radians) * Double(waypoint.x) + cos(radians) * Double(waypoint.y))
        )
    }

    mutating func moveToWaypoint(times: Int) {
        position = (
            x: position.x + times * waypoint.x,
            y: position.y + times * waypoint.y
        )
    }
}

private extension Int {
    func radians() -> Double {
        Double(self) * .pi / 180
    }
}

struct Solution_2020_12: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init)
            .map(Instruction.init(string:))

        // ------- Part 1 -------
        var navigation1 = Navigation1()
        input.forEach { navigation1.apply($0) }
        let part1 = navigation1.manhattanDistance
        print(part1)

        // ------- Part 2 -------
        var navigation2 = Navigation2()
        input.forEach { navigation2.apply($0) }
        let part2 = navigation2.manhattanDistance
        print(part2)

        // ------- Test -------
        assert(part1 == 845, "WA")
        assert(part2 == 27016, "WA")
    }
}
