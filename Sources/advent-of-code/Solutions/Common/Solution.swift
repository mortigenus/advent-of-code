//
//  Solution.swift
//  
//
//  Created by Ivan Chalov on 30.11.20.
//

import Foundation

enum SolutionError: Error {
    case solutionInputNotFound
    case parsingSolutionInputFailed
    case solutionNotFound
    case notImplemented
}

protocol Solution {
    var input: Input { get set }
    init(input: Input)
    func run() throws
}

struct Input {
    var year: Int
    var day: Int

    func get(trimmingWhitespace: Bool = true) throws -> String {
        let fileName = "\(year)-\(String(format:"%02d", day))"
        guard let url = Bundle.module.url(forResource: fileName, withExtension: "txt") else {
            throw SolutionError.solutionInputNotFound
        }
        let data = try Data(contentsOf: url)
        guard let result = String(data: data, encoding: .utf8) else {
            throw SolutionError.parsingSolutionInputFailed
        }
        return trimmingWhitespace
            ? result.trimmingCharacters(in: .whitespacesAndNewlines)
            : result
    }
}

struct SolutionRegistry {
    static var registry: [Int : [Solution.Type]] = [
        2018: [
            Solution_2018_01.self,
            Solution_2018_02.self,
            Solution_2018_03.self,
            Solution_2018_04.self,
            Solution_2018_05.self,
            Solution_2018_06.self,
            Solution_2018_07.self,
            Solution_2018_08.self,
            Solution_2018_09.self,
            Solution_2018_10.self,
            Solution_2018_11.self,
            Solution_2018_12.self,
            Solution_2018_13.self,
            Solution_2018_14.self,
        ],
        2019: [
            Solution_2019_01.self,
            Solution_2019_02.self,
            Solution_2019_03.self,
            Solution_2019_04.self,
            Solution_2019_05.self,
            Solution_2019_06.self,
            Solution_2019_07.self,
            Solution_2019_08.self,
            Solution_2019_09.self,
        ],
        2020: [
            Solution_2020_01.self,
            Solution_2020_02.self,
            Solution_2020_03.self,
            Solution_2020_04.self,
            Solution_2020_05.self,
            Solution_2020_06.self,
            Solution_2020_07.self,
            Solution_2020_08.self,
            Solution_2020_09.self,
            Solution_2020_10.self,
            Solution_2020_11.self,
            Solution_2020_12.self,
            Solution_2020_13.self,
            Solution_2020_14.self,
            Solution_2020_15.self,
            Solution_2020_16.self,
            Solution_2020_17.self,
            Solution_2020_18.self,
            Solution_2020_19.self,
            Solution_2020_20.self,
            Solution_2020_21.self,
            Solution_2020_22.self,
            Solution_2020_23.self,
            Solution_2020_24.self,
            Solution_2020_25.self,
        ],
        2021: [
            Solution_2021_01.self,
            Solution_2021_02.self,
            Solution_2021_03.self,
            Solution_2021_04.self,
            Solution_2021_05.self,
            Solution_2021_06.self,
            Solution_2021_07.self,
            Solution_2021_08.self,
            Solution_2021_09.self,
            Solution_2021_10.self,
            Solution_2021_11.self,
            Solution_2021_12.self,
            Solution_2021_13.self,
            Solution_2021_14.self,
            Solution_2021_15.self,
            Solution_2021_16.self,
        ],
    ]

    static func solution(year: Int, day: Int, input: Input) throws -> Solution {
        let day = day - 1 // 1st of December is at index 0
        guard
            let solutionsForYear = registry[year],
            day >= 0 && day < solutionsForYear.count
        else {
            throw SolutionError.solutionNotFound
        }
        return solutionsForYear[day].init(input: input)
    }

    private init() {}
}
