//
//  Solution_2021_04.swift
//
//
//  Created by Ivan Chalov on 04.12.21.
//

import Foundation

struct Solution_2021_04: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .components(separatedBy: "\n\n")
        let numbers = input[0].split(separator: ",").map { Int($0)! }
        var boards = input[1...]
            .map { board in
                (
                    hasWon: false,
                    board: board
                        .split(whereSeparator: \.isNewline)
                        .map { line in
                            line
                                .split(whereSeparator: \.isWhitespace)
                                .map { (isMarked: false, number: Int(String($0))!) }
                        }
                )
            }

        // ------- Part 1 & 2 -------
        var part1: Int?
        var part2: Int?
        numbers.forEach { num in
            mark(&boards, num)

            let newWinningIndices = boards.indices.filter { b in
                hasBingo(boards[b].board) && boards[b].hasWon == false
            }
            newWinningIndices.forEach { b in
                boards[b].hasWon = true
            }
            if newWinningIndices.count != 0 {
                if part1 == nil {
                    part1 = newWinningIndices.map { score(boards[$0].board, num) }.max()
                }
                if boards.allSatisfy(\.hasWon) {
                    part2 = newWinningIndices.map { score(boards[$0].board, num) }.min()
                }
            }
        }
        print(part1!)
        print(part2!)

        // ------- Test -------
        assert(part1 == 64084, "WA")
        assert(part2 == 12833, "WA")
    }

}

private func mark(
    _ boards: inout [(hasWon: Bool, board: [[(isMarked: Bool, number: Int)]])],
    _ num: Int
) {
    boards.indices.forEach { b in
        boards[b].board.indices.forEach { i in
            boards[b].board[i].indices.forEach { j in
                if boards[b].board[i][j].number == num {
                    boards[b].board[i][j].isMarked = true
                }
            }
        }
    }
}

private func hasBingo(_ board: [[(isMarked: Bool, number: Int)]]) -> Bool {
    board.filter(allMarked).count != 0
    || board.indices.map { col in board.map { $0[col] } }.filter(allMarked).count != 0
}

private func allMarked(_ xs: [(isMarked: Bool, number: Int)]) -> Bool {
    xs.allSatisfy(\.isMarked)
}

private func score(_ board: [[(isMarked: Bool, number: Int)]], _ num: Int) -> Int {
    board.reduce(0) { acc, line in
        acc + line.filter { $0.isMarked == false }.map(\.number).reduce(0, +)
    } * num
}

