//
//  Solution_2020_25.swift
//
//
//  Created by Ivan Chalov on 25.12.20.
//

import Foundation
import Algorithms
import Prelude


func power(_ x: Int, to y: Int, mod p: Int) -> Int {
    var x = x
    var y = y
    var result = 1
    x %= p
    guard x != 0 else { return 0 }

    while y > 0 {
        if !y.isMultiple(of: 2) {
            result = (result * x) % p
        }

        y /= 2
        x = (x * x) % p
    }
    return result
}

struct Solution_2020_25: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
        let pk1 = Int(input[0])!
        let pk2 = Int(input[1])!

        // ------- Part 1 -------
        var loopSize = 1
        var subjectValue = 7
        while true {
            if subjectValue == pk1 || subjectValue == pk2 {
                break
            }
            loopSize += 1
            subjectValue = (subjectValue * 7) % 20201227
        }
        let part1 = power(subjectValue == pk1 ? pk2 : pk1, to: loopSize, mod: 20201227)
        print(part1)

        // ------- Test -------
        assert(part1 == 3217885, "WA")
    }
}
