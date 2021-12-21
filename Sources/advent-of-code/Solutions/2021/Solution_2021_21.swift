//
//  Solution_2021_21.swift
//
//
//  Created by Ivan Chalov on 21.12.21.
//

import Foundation

struct Solution_2021_21: Solution {
    var input: Input

    func run() throws {
        let input = [2, 1]

        // ------- Part 1 -------
        func game1() -> Int {
            var player1Pos = input[0]
            var player2Pos = input[1]
            var player1Score = 0
            var player2Score = 0
            var die = 0
            var dieRolls = 0
            var loosingPlayerScore = 0
            func roll() -> Int {
                die += 1
                if die > 100 { die -= 100 }
                return die
            }

            while true {
                let p1Rolls = roll() + roll() + roll()
                player1Pos = (player1Pos + p1Rolls - 1) % 10 + 1
                player1Score += player1Pos
                dieRolls += 3
                if player1Score >= 1000 {
                    loosingPlayerScore = player2Score
                    break
                }

                let p2Rolls = roll() + roll() + roll()
                player2Pos = (player2Pos + p2Rolls - 1) % 10 + 1
                while player2Pos > 10 { player2Pos -= 10 }
                player2Score += player2Pos
                dieRolls += 3
                if player2Score >= 1000 {
                    loosingPlayerScore = player1Score
                    break
                }

            }
            return loosingPlayerScore * dieRolls
        }
        let part1 = game1()
        print(part1)

        // ------- Part 2 -------
        struct Call: Hashable {
            var playerTurn: Int
            var playerPositions0: Int
            var playerPositions1: Int
            var playerScores0: Int
            var playerScores1: Int
        }
        var cache = [Call: (Int, Int)]()
        func game2(
            playerTurn: Int,
            playerPositions: (Int, Int),
            playerScores: (Int, Int)
        ) -> (Int, Int) {
            guard playerScores.0 < 21 else { return (playerTurn % 2, (playerTurn + 1) % 2) }
            guard playerScores.1 < 21 else { return ((playerTurn + 1) % 2, playerTurn % 2) }

            let diceRolls = [3: 1, 4: 3, 5: 6, 6: 7, 7: 6, 8: 3, 9: 1]
            return diceRolls
                .map { roll, weight -> (Int, Int) in
                    let newPlayerPosition = (playerPositions.0 + roll - 1) % 10 + 1
                    let call = Call(
                        playerTurn: (playerTurn + 1) % 2,
                        playerPositions0: playerPositions.1,
                        playerPositions1: newPlayerPosition,
                        playerScores0: playerScores.1,
                        playerScores1: playerScores.0 + newPlayerPosition
                    )
                    let (player1Wins, player2Wins) = cache[call] ?? game2(
                        playerTurn: (playerTurn + 1) % 2,
                        playerPositions: (playerPositions.1, newPlayerPosition),
                        playerScores: (playerScores.1, playerScores.0 + newPlayerPosition)
                    )
                    cache[call] = (player1Wins, player2Wins)
                    return (weight * player1Wins, weight * player2Wins)
                }
                .reduce((0, 0)) { acc, wins in (acc.0 + wins.0, acc.1 + wins.1) }
        }
        let game2Wins = game2(playerTurn: 0, playerPositions: (input[0], input[1]), playerScores: (0, 0))
        let part2 = max(game2Wins.0, game2Wins.1)
        print(part2)

        // ------- Test -------
        assert(part1 == 797160, "WA")
        assert(part2 == 27464148626406, "WA")
    }

}
