//
//  Solution_2020_02.swift
//  
//
//  Created by Ivan Chalov on 30.11.20.
//

import Foundation

struct PasswordRow {
    var from: Int
    var to: Int
    var letter: String
    var password: String
}

extension PasswordRow {
    init(rowDescription: String) {
        let pattern = "(?<from>\\d+)-(?<to>\\d+) (?<letter>.): (?<password>.+)"
        let regex = try! NSRegularExpression(pattern: pattern)

        let captureGroupToString = regex.captureGroupToString(in: rowDescription)
        let captureGroupToInt = regex.captureGroupToInt(in: rowDescription)

        guard
            let from = captureGroupToInt("from"),
            let to = captureGroupToInt("to"),
            let letter = captureGroupToString("letter"),
            let password = captureGroupToString("password")
        else {
            fatalError("Wrong input format")
        }

        self.init(from: from, to: to, letter: letter, password: password)
    }
}

extension PasswordRow {
    var isValid1: Bool {
        from...to ~= password.filter { String($0) == letter }.count
    }

    var isValid2: Bool {
        let letter1 = String(password[password.index(password.startIndex, offsetBy: from - 1)]) == letter
        let letter2 = String(password[password.index(password.startIndex, offsetBy: to - 1)]) == letter
        return letter1 != letter2
    }
}

struct Solution_2020_02: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init)
            .map(PasswordRow.init(rowDescription:))

        // ------- Part 1 -------
        let part1 = input.filter(\.isValid1).count
        print(part1)

        // ------- Part 2 -------
        let part2 = input.filter(\.isValid2).count
        print(part2)

        // ------- Test -------
        assert(part1 == 564, "WA")
        assert(part2 == 325, "WA")
    }
}
