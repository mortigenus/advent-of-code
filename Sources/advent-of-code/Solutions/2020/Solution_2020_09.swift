//
//  Solution_2020_09.swift
//
//
//  Created by Ivan Chalov on 09.12.20.
//

import Foundation
import Algorithms
import Prelude


struct Solution_2020_09: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init)
            .compactMap(Int.init)

        // ------- Part 1 -------
        func check<S: Sequence>(_ input: Int, preamble: S) -> Bool where S.Element == Int {
            preamble.contains(where: { preamble.contains(input - $0) } )
        }
        let xmas = input.dropFirst(25)
        let (_, part1) = xmas.indexed().reduce(
            (index: 0, element: 0),
            while: { check($0.element, preamble: input.dropFirst($0.index - xmas.startIndex).prefix(25)) })
            { $1 }
        print(part1)

        // ------- Part 2 -------
        let (result2, _) = xmas.indices.reduce(
            (result: [Int](), sum: 0),
            while: { $0.result.count < 2 || $0.sum != part1 })
        {
            xmas[$1...].reduce(
                into: (result: [Int](), sum: 0),
                while: { $0.sum < part1 })
            { acc, x in
                acc.sum += x
                acc.result.append(x)
            }
        }
        let part2 = result2.min()! + result2.max()!
        print(part2)

        // ------- Test -------
        assert(part1 == 32321523, "WA")
        assert(part2 == 4794981, "WA")
    }
}
