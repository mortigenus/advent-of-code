//
//  Solution_2020_22.swift
//
//
//  Created by Ivan Chalov on 22.12.20.
//

import Foundation
import Algorithms
import Prelude


private typealias Deck = [Int]
private extension Deck {
    init(string: String) {
        self = string
            .split(whereSeparator: \.isNewline)
            .dropFirst()
            .compactMap(String.init >>> Int.init)
    }
}

private struct Game {
    var player1: Deck
    var player2: Deck

    mutating func play() {
        while !player1.isEmpty && !player2.isEmpty {
            let card1 = player1.removeFirst()
            let card2 = player2.removeFirst()
            let winnerTakes = [max(card1, card2), min(card1, card2)]
            if card1 > card2 {
                player1.append(contentsOf: winnerTakes)
            } else {
                player2.append(contentsOf: winnerTakes)
            }
        }
    }

    var score: Int {
        let winner = player1.isEmpty ? player2 : player1
        return winner.reversed().indexed().map { ($0.index + 1) * $0.element }.sum()
    }
}

private struct RecursiveGame {
    var player1: Deck
    var player2: Deck

    var winner: Int? = nil

    init(player1: Deck, player2: Deck) {
        self.player1 = player1
        self.player2 = player2
    }

    private var history1 = Set<[Int]>()
    private var history2 = Set<[Int]>()

    private var inLoop: Bool {
        history1.contains(player1) && history2.contains(player2)
    }

    private mutating func updateHistory() {
        history1.insert(player1)
        history2.insert(player2)
    }

    mutating func play() {
        while !player1.isEmpty && !player2.isEmpty {
            guard !inLoop else {
                winner = 1
                return
            }
            updateHistory()
            let card1 = player1.removeFirst()
            let card2 = player2.removeFirst()
            if player1.count >= card1 && player2.count >= card2 {
                var subGame = RecursiveGame(
                    player1: Array(player1.prefix(card1)),
                    player2: Array(player2.prefix(card2))
                )
                subGame.play()
                if subGame.winner == 1 {
                    player1.append(contentsOf: [card1, card2])
                } else {
                    player2.append(contentsOf: [card2, card1])
                }
            } else {
                if card1 > card2 {
                    player1.append(contentsOf: [card1, card2])
                } else {
                    player2.append(contentsOf: [card2, card1])
                }
            }
        }
        winner = player1.isEmpty ? 2 : 1
    }

    var score: Int {
        guard let winner = winner else { return 0 }
        let winnerDeck = winner == 1 ? player1 : player2
        return winnerDeck.reversed().indexed().map { ($0.index + 1) * $0.element }.sum()
    }
}

struct Solution_2020_22: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .components(separatedBy: "\n\n")
        let player1 = Deck(string: input[0])
        let player2 = Deck(string: input[1])

        // ------- Part 1 -------
        var game = Game(player1: player1, player2: player2)
        game.play()
        let part1 = game.score
        print(part1)

        // ------- Part 2 -------
        var recursiveGame = RecursiveGame(player1: player1, player2: player2)
        recursiveGame.play()
        let part2 = recursiveGame.score
        print(part2)

        // ------- Test -------
        assert(part1 == 30780, "WA")
        assert(part2 == 36621, "WA")
    }
}
