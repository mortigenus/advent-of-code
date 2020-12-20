//
//  Solution_2020_16.swift
//
//
//  Created by Ivan Chalov on 16.12.20.
//

import Foundation
import Algorithms
import Prelude

private struct Rules {
    private var rules = [String: [Bool]]()
    private var allIntervals: [Bool] = Array(repeating: false, count: 1000)

    var fields: Set<String> {
        Set(rules.keys)
    }

    init(input: String) {
        for line in input.split(whereSeparator: \.isNewline) {
            let ruleParts = line.split(separator: ":")
            ruleParts[1].dropFirst()
                .components(separatedBy: " or ")
                .map { range in
                    range
                        .split(separator: "-")
                        .compactMap(String.init >>> Int.init)
                        |> { $0[0]...$0[1] }
                }
                .forEach { range in
                    range.forEach {
                        allIntervals[$0] = true
                        rules[
                            String(ruleParts[0]),
                            default: Array(repeating: false, count: 1000)
                        ][$0] = true
                    }
                }
        }
    }

    func isValid(number: Int) -> Bool {
        allIntervals[number]
    }

    func isValid(ticket: Ticket) -> Bool {
        ticket.allSatisfy(isValid)
    }

    func validRules(for number: Int) -> Set<String> {
        rules.filter { $0.value[number] }.map(\.key) |> Set.init
    }
}

private typealias Ticket = [Int]
private extension Ticket {
    init(string: String) {
        self = string
            .split(separator: ",")
            .compactMap(String.init >>> Int.init)
    }
}

struct Solution_2020_16: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .components(separatedBy: "\n\n")
        let rules = Rules(input: input[0])
        let myTicket = input[1]
            .split(whereSeparator: \.isNewline)[1]
            |> String.init >>> Ticket.init(string:)
        let tickets = input[2]
            .split(whereSeparator: \.isNewline)
            .map(String.init)
            .dropFirst()
            .map(Ticket.init(string:))

        // ------- Part 1 -------
        let part1: Int = tickets
            .flatMap { ticket in ticket.filter { !rules.isValid(number: $0) } }
            .sum()
        print(part1)

        // ------- Part 2 -------
        let validTickets = tickets.filter { rules.isValid(ticket: $0) }

        let possibleFields = validTickets.map { $0.map { rules.validRules(for: $0) } }

        var intersections = possibleFields[0].indices.map {
            possibleFields[column: $0].scan(uncurry(Set.intersection))
        }

        var remainingFields = rules.fields
        var resultPositions = Array(repeating: "", count: intersections.count)
        while !remainingFields.isEmpty {
            intersections.indexed().filter { $0.element.count == 1 }.forEach {
                let field = $0.element.first!
                resultPositions[$0.index] = field
                intersections.indices.forEach { intersections[$0].remove(field) }
                remainingFields.remove(field)
            }
        }

        let departureFieldPositions = resultPositions
            .indexed()
            .filter { $0.element.hasPrefix("departure") }
            .map(\.index)

        let part2 = myTicket.indexed()
            .filter { departureFieldPositions.contains($0.index) }
            .map(\.element)
            .product()
        print(part2)

        // ------- Test -------
        assert(part1 == 20060, "WA")
        assert(part2 == 2843534243843, "WA")
    }
}
