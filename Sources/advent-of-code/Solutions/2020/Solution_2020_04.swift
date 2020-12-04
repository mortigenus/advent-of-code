//
//  Solution_2020_04.swift
//
//
//  Created by Ivan Chalov on 04.12.20.
//

import Foundation

private typealias Passport = [String:String]
extension Passport {
    init(string: String) {
        self = Dictionary(
            uniqueKeysWithValues: string
                .split(whereSeparator: \.isWhitespace)
                .map { $0.split(separator: ":").map(String.init) }
                .map { (key: $0[0], value: $0[1]) })
    }
}

extension Passport {
    var requiredKeys: Set<String> {
        ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    }

    var hasRequiredFields: Bool {
        Set(self.keys).isSuperset(of: requiredKeys)
    }

    var hasValidValues: Bool {
        self["byr"]?.matches("^(19[2-9]\\d|200[0-2])$") ?? false
            && self["iyr"]?.matches("^(201\\d|2020)$") ?? false
            && self["eyr"]?.matches("^(202\\d|2030)$") ?? false
            && self["hgt"]?.matches("^((1[5-8]\\d|19[0-3])cm|(59|6\\d|7[0-6])in)$") ?? false
            && self["hcl"]?.matches("^#[0-9a-f]{6}$") ?? false
            && self["ecl"]?.matches("^(amb|blu|brn|gry|grn|hzl|oth)$") ?? false
            && self["pid"]?.matches("^\\d{9}$") ?? false
    }
}

struct Solution_2020_04: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .components(separatedBy: "\n\n")
            .map(Passport.init(string:))

        // ------- Part 1 -------
        let part1 = input.filter(\.hasRequiredFields).count
        print(part1)

        // ------- Part 2 -------
        let part2 = input.filter(\.hasValidValues).count
        print(part2)

        // ------- Test -------
        assert(part1 == 235, "WA")
        assert(part2 == 194, "WA")
    }
}
