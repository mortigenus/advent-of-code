//
//  Solution_2020_07.swift
//
//
//  Created by Ivan Chalov on 07.12.20.
//

import Foundation
import Prelude

struct Solution_2020_07: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init)

        // ------- Part 1 -------
        let pattern = "^(?<parent>.+) bags contain (?<description>.+)$"
        let descriptionPattern = "(?<number>\\d+) ((?<child>[\\w\\s]+)( bags?))+"
        let regex = try! NSRegularExpression(pattern: pattern)
        let descriptionRegex = try! NSRegularExpression(pattern: descriptionPattern)
        struct Maps {
            var childToParent = [String: [String]]()
            var parentToChild = [String: [(number: Int, bag: String)]]()
        }
        let maps = input.reduce(into: Maps()) { maps, rule in
            let captureGroupToString = regex.captureGroupToString(in: rule)
            guard
                let parent = captureGroupToString("parent"),
                let description = captureGroupToString("description")
            else {
                fatalError("Wrong input format")
            }
            let children = descriptionRegex.captureGroupToStrings(in: description)("child")
            let numbers = descriptionRegex.captureGroupToInts(in: description)("number")
            for (child, number) in zip(children, numbers) {
                maps.childToParent[child, default: []].append(parent)
                maps.parentToChild[parent, default: []].append((number, child))
            }
        }

        func bagsContaining(bag: String) -> Set<String> {
            Set(maps.childToParent[bag, default: []]).union(
                maps.childToParent[bag]?.map(bagsContaining(bag:)).scan(uncurry(Set.union)) ?? Set())
        }
        let part1 = bagsContaining(bag: "shiny gold").count
        print(part1)

        // ------- Part 2 -------
        func numberOfBagsInside(bag: String) -> Int {
            maps.parentToChild[bag, default: []]
                .map { $0.number + $0.number * numberOfBagsInside(bag:$0.bag) }
                .sum()
        }
        let part2 = numberOfBagsInside(bag: "shiny gold")
        print(part2)

        // ------- Test -------
        assert(part1 == 211, "WA")
        assert(part2 == 12414, "WA")
    }
}
