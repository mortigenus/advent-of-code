//
//  Solution_2020_15.swift
//
//
//  Created by Ivan Chalov on 15.12.20.
//

import Foundation
import Algorithms
import Prelude

private struct Game {
    var input: [Int]
    var turn = 0
    var lastNumber = -1 {
        didSet {
            if let lastTwoOccurrences = memory[lastNumber] {
                memory[lastNumber] = (lastTwoOccurrences.1, turn)
            } else {
                memory[lastNumber] = (-1, turn)
            }
        }
    }
    private var memory = [Int: (Int, Int)]()

    init(input: [Int]) {
        self.input = input
    }

    mutating func run(till targetTurn: Int) {
        readInput()
        while turn != targetTurn {
            turn += 1
            let lastTwoOccurrences = memory[lastNumber]!
            if lastTwoOccurrences.0 == -1 {
                lastNumber = 0
            } else {
                lastNumber = lastTwoOccurrences.1 - lastTwoOccurrences.0
            }
        }
    }

    private mutating func readInput() {
        for i in input {
            turn += 1
            lastNumber = i
        }
    }
}


struct Solution_2020_15: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(separator: ",")
            .compactMap(String.init >>> Int.init)


        // ------- Part 1 -------
        var game1 = Game(input: input)
        game1.run(till: 2020)
        let part1 = game1.lastNumber
        print(part1)

        // ------- Part 2 -------
        var game2 = Game(input: input)
        game2.run(till: 30000000)
        let part2 = game2.lastNumber
        print(part2)

        // ------- Test -------
        assert(part1 == 1009, "WA")
        assert(part2 == 62714, "WA")
    }
}
