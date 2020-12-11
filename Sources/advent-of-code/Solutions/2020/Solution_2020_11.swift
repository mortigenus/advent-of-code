//
//  Solution_2020_11.swift
//
//
//  Created by Ivan Chalov on 11.12.20.
//

import Foundation
import Algorithms
import Prelude

private enum Seat: String {
    case floor = "."
    case free = "L"
    case occupied = "#"

    var isFree: Bool {
        self != .occupied
    }

    var isOccupied: Bool {
        self == .occupied
    }
}

private typealias WaitingArea = [[Seat]]
private extension WaitingArea {
    var occupiedSeats: Int {
        self
            .map(Prelude.filter(\.isOccupied) >>> \.count)
            .sum()
    }

    func adjacent1(i: Int, j: Int) -> [Seat] {
        [(1, 1), (1, 0), (1, -1), (0, 1), (0, -1), (-1, 1), (-1, 0), (-1, -1)]
            .compactMap { dirI, dirJ in
                let (idxI, idxJ) = (i + dirI, j + dirJ)
                return self.indices ~= idxI && self[idxI].indices ~= idxJ
                    ? self[idxI][idxJ]
                    : nil
            }
    }

    func adjacent2(i: Int, j: Int) -> [Seat] {
        [(1, 1), (1, 0), (1, -1), (0, 1), (0, -1), (-1, 1), (-1, 0), (-1, -1)]
            .compactMap { dirI, dirJ in
                var (idxI, idxJ) = (i + dirI, j + dirJ)
                while self.indices ~= idxI && self[idxI].indices ~= idxJ {
                    if self[idxI][idxJ] != .floor {
                        return self[idxI][idxJ]
                    }
                    idxI += dirI
                    idxJ += dirJ
                }
                return nil
            }
    }
}

private struct Game {
    enum AdjacentAlgorithm {
        case immediatelyNear
        case firstSeen

        var method: (WaitingArea) -> (Int, Int) -> [Seat] {
            switch self {
            case .immediatelyNear:
                return WaitingArea.adjacent1
            case .firstSeen:
                return WaitingArea.adjacent2
            }
        }
    }
    var waitingArea: WaitingArea
    var tolerance: Int
    var adjacentMethod: (WaitingArea) -> (_ i: Int, _ j: Int) -> [Seat]

    init(
        waitingArea: WaitingArea,
        tolerance: Int = 4,
        adjacentAlgorithm: AdjacentAlgorithm = .immediatelyNear
    ) {
        self.waitingArea = waitingArea
        self.tolerance = tolerance
        self.adjacentMethod = adjacentAlgorithm.method
    }

    mutating func runUntilStable() {
        while step() { }
    }

    mutating func step() -> Bool {
        var newLayout = waitingArea
        var layoutChanged = false
        for i in waitingArea.indices {
            for j in waitingArea[i].indices {
                switch waitingArea[i][j] {
                case .floor:
                    continue
                case .free:
                    if adjacentMethod(waitingArea)(i, j).allSatisfy(\.isFree) {
                        newLayout[i][j] = .occupied
                        layoutChanged = true
                    }
                case .occupied:
                    if adjacentMethod(waitingArea)(i, j).filter(\.isOccupied).count >= tolerance {
                        newLayout[i][j] = .free
                        layoutChanged = true
                    }
                }
            }
        }
        waitingArea = newLayout
        return layoutChanged
    }
}

struct Solution_2020_11: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init)
            .map(mapOptional(String.init >>> Seat.init(rawValue:)))

        // ------- Part 1 -------
        var game1 = Game(waitingArea: input)
        game1.runUntilStable()
        let part1 = game1.waitingArea.occupiedSeats
        print(part1)

        // ------- Part 2 -------
        var game2 = Game(waitingArea: input, tolerance: 5, adjacentAlgorithm: .firstSeen)
        game2.runUntilStable()
        let part2 = game2.waitingArea.occupiedSeats
        print(part2)

        // ------- Test -------
        assert(part1 == 2346, "WA")
        assert(part2 == 2111, "WA")
    }
}
