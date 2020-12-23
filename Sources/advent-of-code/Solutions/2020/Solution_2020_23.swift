//
//  Solution_2020_23.swift
//
//
//  Created by Ivan Chalov on 23.12.20.
//

import Foundation
import Algorithms
import Prelude


private struct Game {
    private var nextCupMap = [Int: Int]()
    private var totalCups: Int
    private var head: Int

    init(input: [Int], part: Int = 1) {
        let xs: [Int]
        if part == 1 {
            xs = input
            totalCups = 9
        } else {
            totalCups = 1_000_000
            xs = input + Array(10...totalCups)
        }
        var previous = xs[0]
        for x in xs.dropFirst() {
            nextCupMap[previous] = x
            previous = x
        }
        nextCupMap[previous] = input[0]
        head = input[0]
    }

    func next(_ cup: Int) -> Int {
        nextCupMap[cup]!
    }

    private func findDestination(current: Int) -> Int {
        func nextDestination(_ destination: Int) -> Int {
            destination - 1 == 0 ? totalCups : destination - 1
        }
        var destination = nextDestination(current)
        let cup1 = next(current)
        let cup2 = next(cup1)
        let cup3 = next(cup2)
        while true {
            if cup1 == destination || cup2 == destination || cup3 == destination {
                destination = nextDestination(destination)
            } else {
                return destination
            }
        }
    }

    mutating func play(rounds: Int) {
        var current = head
        for _ in 1...rounds {
            let destination = findDestination(current: current)

            let movingHead = next(current)
            let movingTail = next(next(next(current)))
            let nextAfterMovingTail = next(movingTail)
            let nextAfterDestination = next(destination)
            nextCupMap[movingTail] = nextAfterDestination
            nextCupMap[destination] = movingHead
            nextCupMap[current] = nextAfterMovingTail

            current = next(current)
        }
    }
}

struct Solution_2020_23: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .compactMap(String.init >>> Int.init)

        // ------- Part 1 -------
        var game1 = Game(input: input)
        game1.play(rounds: 100)
        var cup = game1.next(1)
        var result = [Int]()
        while cup != 1 {
            result.append(cup)
            cup = game1.next(cup)
        }
        let part1 = result.map(String.init).joined()
        print(part1)

        // ------- Part 2 -------
        var game2 = Game(input: input, part: 2)
        game2.play(rounds: 10_000_000)
        let nextAfterOne = game2.next(1)
        let nextAfterNextAfterOne = game2.next(nextAfterOne)
        let part2 = nextAfterOne * nextAfterNextAfterOne
        print(part2)
        
        // ------- Test -------
        assert(part1 == "97245386", "WA")
        assert(part2 == 156180332979, "WA")
    }
}
