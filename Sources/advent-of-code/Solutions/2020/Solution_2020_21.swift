//
//  Solution_2020_21.swift
//
//
//  Created by Ivan Chalov on 21.12.20.
//

import Foundation
import Algorithms
import Prelude

struct Solution_2020_21: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map {
                $0.split(separator: "(")
                    |> { (foodDescription: [Substring]) in
                        (
                            ingredients: foodDescription[0]
                                .split(whereSeparator: \.isWhitespace)
                                .map(String.init),
                            allergens: foodDescription[1].dropFirst(9).dropLast()
                                .split(whereSeparator: { $0.isWhitespace || $0.isPunctuation })
                                .map(String.init)
                        )
                    }
            }

        // ------- Part 1 -------
        let foodsMap = input.reduce(into: [String: [Set<String>]]()) { acc, x in
            x.allergens.forEach { acc[$0, default: []].append(Set(x.ingredients)) }
        }
        let possibleAllergensMap = foodsMap.mapValues { arrayOfSetsOfIngredients in
            arrayOfSetsOfIngredients.scan(uncurry(Set.intersection))
        }
        let possibleAllergens = Set(possibleAllergensMap.values.joined())
        let part1 = input
            .map {
                $0.ingredients.filter { !possibleAllergens.contains($0) }.count
            }
            .sum()
        print(part1)

        // ------- Part 2 -------
        var remainingAllergens = Set(possibleAllergensMap.keys)
        var definiteAllergensMap = possibleAllergensMap
        while !remainingAllergens.isEmpty {
            let definitelyFound = definiteAllergensMap.filter { $0.value.count == 1 }
            let definitelyFoundValues = Set(definitelyFound.values.joined())
            let definitelyFoundKeys = Set(definitelyFound.keys)
            definiteAllergensMap = definiteAllergensMap.mapValues {
                $0.count != 1 ? $0.subtracting(definitelyFoundValues) : $0
            }
            remainingAllergens.subtract(definitelyFoundKeys)
        }
        let part2 = definiteAllergensMap
            .map { ($0.key, $0.value.first!) }
            .sorted(by: { $0.0 < $1.0 })
            .map(\.1)
            .joined(separator: ",")
        print(part2)

        // ------- Test -------
        assert(part1 == 1913, "WA")
        assert(part2 == "gpgrb,tjlz,gtjmd,spbxz,pfdkkzp,xcfpc,txzv,znqbr", "WA")
    }
}
