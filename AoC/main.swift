//
//  main.swift
//  AoC
//
//  Created by Ivan Chalov on 05/05/2019.
//  Copyright © 2019 Ivan Chalov. All rights reserved.
//

import Foundation

public func readInput() throws -> String {
    let input: String
    if CommandLine.arguments.count == 4 && CommandLine.arguments[2] == "cli" {
        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        var url = URL(fileURLWithPath: CommandLine.arguments[3], relativeTo: currentDirectoryURL)
        url.appendPathComponent("Resources/input.txt")

        input = try String(contentsOf: url)
    } else {
        guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else {
            fatalError("Put input for the task into \"input.txt\" file")
        }

        input = try String(contentsOfFile:path)
    }

    return input.trimmingCharacters(in: .whitespacesAndNewlines)
}

