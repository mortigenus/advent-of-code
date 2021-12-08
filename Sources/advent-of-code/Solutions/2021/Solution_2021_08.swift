//
//  Solution_2021_08.swift
//
//
//  Created by Ivan Chalov on 08.12.21.
//

import Foundation

struct Solution_2021_08: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map { $0.components(separatedBy: " | ") }
            .map { $0.map { $0.split(whereSeparator: \.isWhitespace) } }

        // ------- Part 1 -------
        let part1 = input
            .map { $0[1].filter { Set([2, 3, 4, 7]).contains($0.count) }.count }
            .reduce(0, +)
        print(part1)

        // ------- Part 2 -------
        func solve(_ signals: [Substring], _ output: [Substring]) -> Int {
            var digits: [Set<Character>?] = Array(repeating: nil, count: 10)
            var signals = signals.map { Set($0) }.sorted(by: { $0.count < $1.count })
            digits[1] = signals.removeFirst()
            digits[7] = signals.removeFirst()
            digits[4] = signals.removeFirst()
            digits[8] = signals.removeLast()

            var containsOneIndex = signals.partition(by: { $0.isSuperset(of: digits[1]!) })
            digits[3] = signals.remove(at: signals[containsOneIndex...].firstIndex(where: { $0.count == 5 })!)
            digits[6] = signals.remove(at: signals[..<containsOneIndex].firstIndex(where: { $0.count == 6 })!)
            containsOneIndex -= 1
            let c = digits[8]!.subtracting(digits[6]!).first!
            digits[2] = signals[..<containsOneIndex].first(where: { $0.contains(c) })!
            digits[5] = signals[..<containsOneIndex].first(where: { !$0.contains(c) })!
            let e = digits[6]!.subtracting(digits[5]!).first!
            digits[0] = signals[containsOneIndex...].first(where: { $0.contains(e) })!
            digits[9] = signals[containsOneIndex...].first(where: { !$0.contains(e) })!

            return output
                .map { digits.firstIndex(of: Set($0))! }
                .reversed()
                .reduce((sum: 0, pow: 1)) { acc, x in
                    (acc.sum + x * acc.pow, acc.pow * 10)
                }
                .sum
        }
        let part2 = input
            .map { line in solve(line[0], line[1]) }
            .reduce(0, +)
        print(part2)

        // ------- Test -------
        assert(part1 == 294, "WA")
        assert(part2 == 973292, "WA")
    }

}
