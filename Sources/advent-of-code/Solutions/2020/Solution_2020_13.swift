//
//  Solution_2020_13.swift
//
//
//  Created by Ivan Chalov on 13.12.20.
//

import Foundation
import Algorithms
import Prelude


struct Solution_2020_13: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
        let time = Int(input[0])!
        let timetable = input[1].split(separator: ",")

        // ------- Part 1 -------
        let result = timetable
            .compactMap { Int($0) }
            .reduce((value: Int.max, bus: -1)) { acc, bus in
                acc.value > bus - time % bus
                    ? (value: bus - time % bus, bus: bus)
                    : acc
            }
        let part1 = result.value * result.bus
        print(part1)

        // ------- Part 2 -------
        /// gcd(a, b) = a * s + b * t
        func extendedEuclid(_ a: Int, _ b: Int) -> (s: Int, t: Int) {
            var (oldR, r) = (a, b)
            var (oldS, s) = (1, 0)
            var (oldT, t) = (0, 1)

            while r != 0 {
                let quotient = oldR / r
                (oldR, r) = (r, oldR - quotient * r)
                (oldS, s) = (s, oldS - quotient * s)
                (oldT, t) = (t, oldT - quotient * t)
            }

            return (s: oldS, t: oldT)
        }

        /// Solving the following system:
        /// x ≡ a_i (mod n_i)
        /// Precondition: all n_i are pairwise co-prime.
        func chineseRemainderTheorem(_ a: [Int], _ n: [Int]) -> Int {
            let N = n.product()
            return zip(a, n).reduce(0) { acc, x in
                let (a_i, n_i) = x
                let x_i = a_i * extendedEuclid(n_i, N / n_i).t * (N / n_i)
                return (acc + x_i) % N
            }
        }

        let (a: a, n: n) = timetable.indexed().reduce(into: (a: [Int](), n: [Int]())) { acc, x in
            guard let bus = Int(x.element) else {
                return
            }
            acc.a.append((bus - x.index % bus) % bus)
            acc.n.append(bus)
        }
        let part2 = chineseRemainderTheorem(a, n)
        print(part2)

        // ------- Test -------
        assert(part1 == 3464, "WA")
        assert(part2 == 760171380521445, "WA")
    }
}
