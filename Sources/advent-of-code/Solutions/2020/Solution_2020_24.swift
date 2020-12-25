//
//  Solution_2020_24.swift
//
//
//  Created by Ivan Chalov on 24.12.20.
//

import Foundation
import Algorithms
import Prelude


private struct Point3: Hashable {
    var x: Int
    var y: Int
    var z: Int

    init(_ x: Int, _ y: Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    static func + (lhs: Point3, rhs: Point3) -> Point3 {
        Point3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }

    var adjacent: [Point3] {
        return Direction.allCases.map(\.unitVector).map { self + $0 }
    }
}

private enum Tile {
    case black
    case white

    mutating func flip() {
        self = self == .black ? .white : .black
    }
}

private typealias Lobby = [Point3: Tile]
private extension Lobby {
    init(string: String) {
        self = string
            .split(whereSeparator: \.isNewline)
            .map(Prelude.map(id) >>> Instructions.init)
            .reduce(into: [Point3: Tile]()) { acc, x in
                acc[x.map(\.unitVector).scan(+), default: .white].flip()
            }
    }

    var blackTiles: [Point3] {
        self.filter { $0.value == .black }.map(\.key)
    }

    func isBlack(_ point: Point3) -> Bool {
        self[point] == .black
    }
}

private enum Direction: String, CaseIterable {
    case w
    case e
    case nw
    case ne
    case se
    case sw

    var unitVector: Point3 {
        switch self {
        case  .w: return Point3(-1,  1,  0)
        case  .e: return Point3( 1, -1,  0)
        case .nw: return Point3( 0,  1, -1)
        case .ne: return Point3( 1,  0, -1)
        case .sw: return Point3(-1,  0,  1)
        case .se: return Point3( 0, -1,  1)
        }
    }
}

private typealias Instructions = [Direction]
private extension Instructions {
    init(_ xs: [Character]) {
        var i = 0
        var result = [Direction]()
        while i < xs.count {
            switch xs[i] {
            case "w", "e":
                result.append(Direction(rawValue: String(xs[i]))!)
                i += 1
            case "n", "s":
                result.append(Direction(rawValue: String(xs[i...i+1]))!)
                i += 2
            default:
                fatalError("Incorrect input")
            }
        }
        self = result
    }
}

private struct Game {
    var lobby: Lobby

    mutating func play(rounds: Int) {
        for _ in 1...rounds {
            playRound()
        }
    }

    private mutating func playRound() {
        var newLobby = lobby
        lobby.blackTiles.forEach { blackTile in
            let adjacent = blackTile.adjacent

            // Rule 1
            let blackAdjacent = adjacent.filter { lobby.isBlack($0) }.count
            if blackAdjacent == 0 || blackAdjacent > 2 {
                newLobby[blackTile] = .white
            }

            // Rule 2
            adjacent.forEach { possiblyWhiteTile in
                guard !lobby.isBlack(possiblyWhiteTile) else { return }
                if possiblyWhiteTile.adjacent.filter({ lobby.isBlack($0) }).count == 2 {
                    newLobby[possiblyWhiteTile] = .black
                }
            }
        }
        lobby = newLobby
    }
}


struct Solution_2020_24: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get() |> Lobby.init(string:)

        // ------- Part 1 -------
        let part1 = input.blackTiles.count
        print(part1)

        // ------- Part 2 -------
        var game = Game(lobby: input)
        game.play(rounds: 100)
        let part2 = game.lobby.blackTiles.count
        print(part2)
        
        // ------- Test -------
        assert(part1 == 330, "WA")
        assert(part2 == 3711, "WA")
    }
}
