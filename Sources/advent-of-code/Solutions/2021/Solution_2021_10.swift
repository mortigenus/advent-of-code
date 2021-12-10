//
//  Solution_2021_10.swift
//
//
//  Created by Ivan Chalov on 10.12.21.
//

import Foundation

struct Solution_2021_10: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map { $0.map { Bracket(rawValue: String($0))! } }

        // ------- Part 1 -------
        let part1 = input.map { line in
            var stack = [Bracket]()
            for x in line {
                if x.isOpen {
                    stack.append(x)
                } else if let last = stack.last, x.matches(last) {
                    stack.removeLast()
                } else {
                    return x.score1
                }
            }
            return 0
        }.reduce(0, +)
        print(part1)

        // ------- Part 2 -------
        let scores = input
            .compactMap { line -> [Bracket]? in
                var stack = [Bracket]()
                for x in line {
                    if x.isOpen {
                        stack.append(x)
                    } else if let last = stack.last, x.matches(last) {
                        stack.removeLast()
                    } else {
                        return nil
                    }
                }
                return stack
            }
            .map { $0.reversed().map(\.matching.score2).reduce(0) { acc, x in acc * 5 + x } }
            .sorted()
        let part2 = scores[scores.count / 2]
        print(part2)

        // ------- Test -------
        assert(part1 == 469755, "WA")
        assert(part2 == 2762335572, "WA")
    }

}

private enum Bracket {
    case open(String)
    case close(String)

    init?(rawValue: String) {
        switch rawValue {
        case "(", "[", "{", "<": self = .open(rawValue)
        case ")", "]", "}", ">": self = .close(rawValue)
        default: return nil
        }
    }

    private static let openToClose = ["(" : ")", "[" : "]", "{" : "}", "<" : ">"]
    private static let closeToOpen = [")" : "(", "]" : "[", "}" : "{", ">" : "<"]

    var isOpen: Bool {
        guard case .open = self else { return false }
        return true
    }

    func matches(_ other: Bracket) -> Bool {
        switch (other, self) {
        case let (.open(b1), .close(b2)): return Self.openToClose[b1] == b2
        case let (.close(b1), .open(b2)): return Self.closeToOpen[b1] == b2
        default: return false
        }
    }

    var matching: Bracket {
        switch self {
        case let .open(b): return .close(Self.openToClose[b]!)
        case let .close(b): return .open(Self.closeToOpen[b]!)
        }
    }

    var score1: Int {
        switch self {
        case .close(")"): return 3
        case .close("]"): return 57
        case .close("}"): return 1197
        case .close(">"): return 25137
        default: return 0
        }
    }

    var score2: Int {
        switch self {
        case .close(")"): return 1
        case .close("]"): return 2
        case .close("}"): return 3
        case .close(">"): return 4
        default: return 0
        }
    }
}
