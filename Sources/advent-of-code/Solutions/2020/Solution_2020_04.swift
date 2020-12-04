//
//  Solution_2020_04.swift
//
//
//  Created by Ivan Chalov on 04.12.20.
//

import Foundation

typealias Passport = [String:String]

struct Solution_2020_04: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
            .map(String.init)
            .reduce(into: [Passport()]) { acc, x in
                if x == "" {
                    acc.append(Passport())
                    return
                }
                let fields = x.split(whereSeparator: \.isWhitespace).map { $0.split(separator: ":").map(String.init) }
                fields.forEach { keyValueArray in
                    acc[acc.index(before: acc.endIndex)][keyValueArray[0]] = keyValueArray[1]
                }
            }

        // ------- Part 1 -------
        let requiredKeys = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
        let part1 = input
            .filter { passport in
                requiredKeys.reduce(true) { acc, x in acc && passport[x] != nil }
            }
            .count
        print(part1)

        // ------- Part 2 -------
        let part2 = input
            .filter { passport in
                guard let byr = passport["byr"], byr.matches("^(19[2-9]\\d|200[0-2])$") else {
                    return false
                }
                guard let iyr = passport["iyr"], iyr.matches("^(201\\d|2020)$") else {
                    return false
                }
                guard let eyr = passport["eyr"], eyr.matches("^(202\\d|2030)$") else {
                    return false
                }
                guard let hgt = passport["hgt"], hgt.matches("^((1[5-8]\\d|19[0-3])cm|(59|6\\d|7[0-6])in)$") else {
                    return false
                }
                guard let hcl = passport["hcl"], hcl.matches("^#[0-9a-f]{6}$") else {
                    return false
                }
                guard let ecl = passport["ecl"], ecl.matches("^(amb|blu|brn|gry|grn|hzl|oth)$") else {
                    return false
                }
                guard let pid = passport["pid"], pid.matches("^\\d{9}$") else {
                    return false
                }
                return true
            }
            .count
        print(part2)

        // ------- Test -------
        assert(part1 == 235, "WA")
        assert(part2 == 194, "WA")
    }
}
