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
    var allIntervals: FlattenSequence<[ClosedRange<Int>]>
    var rules = [String: FlattenSequence<[ClosedRange<Int>]>]()

    init(input: String) {
        var allRanges = [ClosedRange<Int>]()
        for line in input.split(whereSeparator: \.isNewline) {
            let ruleParts = line.split(separator: ":")
            let ranges = ruleParts[1].dropFirst()
                .components(separatedBy: " or ")
                .map { range in
                    range
                        .split(separator: "-")
                        .compactMap(String.init >>> Int.init)
                        |> { $0[0]...$0[1] }
                }
            allRanges.append(contentsOf: ranges)
            rules[String(ruleParts[0])] = ranges.joined()
        }
        allIntervals = allRanges.joined()
    }
}

struct Solution_2020_16: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .components(separatedBy: "\n\n")
        let rules = Rules(input: input[0])
        let tickets = input[2]
            .split(whereSeparator: \.isNewline)
            .map(String.init)
            .dropFirst()
            .map { ticket -> [Int] in
                ticket
                    .split(separator: ",")
                    .compactMap(String.init >>> Int.init)
            }

        // ------- Part 1 -------
        let part1: Int = tickets
            .flatMap {
                $0.filter { !rules.allIntervals.contains($0) }
            }
            .sum()
        print(part1)

        // ------- Part 2 -------
        let validTickets = tickets
            .filter {
                $0.allSatisfy { rules.allIntervals.contains($0) }
            }

        var xs = Array(
            repeating: Array(
                repeating: Set<String>(),
                count: validTickets[0].count
            ),
            count: validTickets.count
        )

        for (ticketIndex, ticketNumbers) in validTickets.indexed() {
            for (numberIndex, number) in ticketNumbers.indexed() {
                for (field, range) in rules.rules {
                    if range.contains(number) {
                        xs[ticketIndex][numberIndex].insert(field)
                    }
                }
            }
        }

        var intersections = Array(repeating: Set<String>?.none, count: xs[0].count)
        for i in xs[0].indices {
            for j in xs.indices {
                if intersections[i] == nil {
                    intersections[i] = xs[j][i]
                } else {
                    intersections[i]!.formIntersection(xs[j][i])
                }
            }
        }

        var leftFields = Set(rules.rules.keys)
        var resultPositions = Array(repeating: "", count: intersections.count)
        while !leftFields.isEmpty {
            let index = intersections.firstIndex(where: { $0!.count == 1 })!
            let field = intersections[index]!.first!
            resultPositions[index] = field
            intersections.indices.forEach {
                intersections[$0]?.remove(field)
            }
            leftFields.remove(field)
        }

        let departureFields = resultPositions.indexed().filter { $0.element.hasPrefix("departure") }
        let myTicket = input[1].split(whereSeparator: \.isNewline)[1].split(separator: ",").compactMap(String.init >>> Int.init)
        var part2 = 1
        for (index, _) in departureFields {
            part2 *= myTicket[index]
        }
        print(part2)


        // ------- Test -------
        assert(part1 == 20060, "WA")
        assert(part2 == 2843534243843, "WA")
    }
}
