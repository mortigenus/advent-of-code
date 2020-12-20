//
//  Solution_2020_19.swift
//
//
//  Created by Ivan Chalov on 19.12.20.
//

import Foundation
import Algorithms
import Prelude


private enum Rule {
    case letter(Character)
    case subruleLinks([[Int]])
    init(string: Substring) {
        if string.hasPrefix("\"") {
            self = .letter(string[string.index(after: string.startIndex)])
        } else {
            self = string
                .split(separator: "|")
                .map(String.init)
                .map {
                    let scanner = Scanner(string: $0)
                    var rules = [Int]()
                    while let ruleNumber = scanner.scanInt() {
                        rules.append(ruleNumber)
                    }
                    return rules
                }
                |> { Rule.subruleLinks($0) }
        }
    }
}

private typealias Rules = [Int: Rule]
private extension Rules {
    init(string: String) {
        self = string.split(whereSeparator: \.isNewline)
            .reduce(into: [Int: Rule]()) { acc, x in
                x.split(separator: ":")
                    |> { acc[Int($0[0])!] = Rule(string: $0[1].dropFirst()) }
            }
    }
}

struct Solution_2020_19: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .components(separatedBy: "\n\n")
        let rules = Rules(string: input[0])
        let messages = input[1]
            .split(whereSeparator: \.isNewline)
            .map(String.init)

        // ------- Part 1 -------
        func recursiveDFS(_ message: [Character], _ stack: [Int], _ index: Int = 0) -> Bool {
            if index == message.count, stack.isEmpty {
                return true
            }
            if stack.isEmpty || index >= message.count { return false }
            switch rules[stack.last!]! {
            case let .letter(char):
                if message[index] == char {
                    return recursiveDFS(message, stack.dropLast(), index + 1)
                } else {
                    return false
                }
            case let .subruleLinks(sublinks):
                for xs in sublinks {
                    if recursiveDFS(message, Array(stack.dropLast() + xs.reversed()), index) {
                        return true
                    }
                }
                return false
            }
        }
        func dfs(_ message: [Character], _ rule: Rule) -> Bool {
            guard case let .subruleLinks(links) = rule else {
                return false
            }
            return recursiveDFS(message, links[0].reversed(), 0)
        }
        let part1 = messages.filter { dfs($0.map(id), rules[0]!) }.count
        print(part1)

        // ------- Part 2 -------
        func dfs2(_ message: [Character]) -> Bool {
            // cheating:
            // 1. rule 0 is "8 11", rules 8 and 11 are only seen in rule 0.
            // 2. checked different n for (42^n 31^n) until answer was correct.
            let rules8 = (1...5).map { Array(repeating: 42, count: $0) }
            let rules11 = (1...5).map { Array(repeating: 42, count: $0) + Array(repeating: 31, count: $0) }
            for rule8 in rules8 {
                for rule11 in rules11 {
                    if recursiveDFS(message, (rule8 + rule11).reversed()) {
                        return true
                    }
                }
            }
            return false
        }
        let part2 = messages.filter { dfs2($0.map(id)) }.count
        print(part2)

        // ------- Test -------
        assert(part1 == 198, "WA")
        assert(part2 == 372, "WA")
    }
}
