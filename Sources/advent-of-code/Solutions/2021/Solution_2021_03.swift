//
//  Solution_2021_03.swift
//
//
//  Created by Ivan Chalov on 03.12.21.
//

import Foundation

struct Solution_2021_03: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(Array.init)

        // ------- Part 1 -------
        let transposed = input.first!.indices.map { index in input.map { $0[index] } }
        var gammaString = ""
        var epsilonString = ""
        transposed.forEach { line in
            let zeroCount = line.filter { $0 == "0" }.count
            let oneCount = line.filter { $0 == "1" }.count
            if oneCount > zeroCount {
                gammaString += "1"
                epsilonString += "0"
            } else {
                gammaString += "0"
                epsilonString += "1"
            }
        }
        let part1 = Int(gammaString, radix: 2)! * Int(epsilonString, radix: 2)!
        print(part1)

        // ------- Part 2 -------
        var oxygenGeneratorRating: Int?
        var oxygenGeneratorSource = input
        var co2ScrubberRating: Int?
        var co2ScrubberSource = input
        transposed.indices.forEach { i in
            if oxygenGeneratorRating == nil {
                let zeroCount = oxygenGeneratorSource.map { $0[i] }.filter { $0 == "0" }.count
                let oneCount = oxygenGeneratorSource.map { $0[i] }.filter { $0 == "1" }.count
                if oneCount >= zeroCount {
                    oxygenGeneratorSource = oxygenGeneratorSource.filter { $0[i] == "1" }
                } else {
                    oxygenGeneratorSource = oxygenGeneratorSource.filter { $0[i] == "0" }
                }
                if oxygenGeneratorSource.count == 1 {
                    oxygenGeneratorRating = Int(String(oxygenGeneratorSource[0]), radix: 2)!
                }
            }

            if co2ScrubberRating == nil {
                let zeroCount = co2ScrubberSource.map { $0[i] }.filter { $0 == "0" }.count
                let oneCount = co2ScrubberSource.map { $0[i] }.filter { $0 == "1" }.count
                if oneCount < zeroCount {
                    co2ScrubberSource = co2ScrubberSource.filter { $0[i] == "1" }
                } else {
                    co2ScrubberSource = co2ScrubberSource.filter { $0[i] == "0" }
                }
                if co2ScrubberSource.count == 1 {
                    co2ScrubberRating = Int(String(co2ScrubberSource[0]), radix: 2)!
                }
            }
        }
        let part2 = oxygenGeneratorRating! * co2ScrubberRating!
        print(part2)

        // ------- Test -------
        assert(part1 == 4006064, "WA")
        assert(part2 == 5941884, "WA")
    }

}
