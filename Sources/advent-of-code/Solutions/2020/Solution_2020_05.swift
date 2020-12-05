//
//  Solution_2020_05.swift
//
//
//  Created by Ivan Chalov on 05.12.20.
//

import Foundation

private func pow(_ a: Int, _ b: Int) -> Int {
    Int(pow(Double(a), Double(b)))
}

private func parseNumber(from string: String, one: Character, zero: Character) -> Int {
    string
        .reduce((sum: 0, power: string.count - 1)) { acc, char in
            switch char {
            case one:
                return (acc.sum + pow(2, acc.power), acc.power - 1)
            case zero:
                return (acc.sum, acc.power - 1)
            default:
                fatalError("Incorrect Input")
            }
        }
        .sum
}

struct Solution_2020_05: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init)

        // ------- Part 1 -------
        let passes: [Int] = input
            .map { pass in
                let row = parseNumber(from: String(pass.dropLast(3)), one: "B", zero: "F")
                let column = parseNumber(from: String(pass.suffix(3)), one: "R", zero: "L")
                return row * 8 + column
            }
            .sorted()
        let part1 = passes.last!
        print(part1)

        // ------- Part 2 -------
        let part2 = zip(passes, passes[1...]).first(where: { cur, next in cur + 1 != next })!.0 + 1
        print(part2)

        // ------- Test -------
        assert(part1 == 855, "WA")
        assert(part2 == 552, "WA")
    }
}
