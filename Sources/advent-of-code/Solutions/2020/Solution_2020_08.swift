//
//  Solution_2020_08.swift
//
//
//  Created by Ivan Chalov on 08.12.20.
//

import Foundation
import Prelude

private typealias Bootcode = [Instruction]

private struct Instruction {
    enum Operation: String {
        case acc
        case jmp
        case nop
    }
    var operation: Operation
    var value: Int

    var canSwap: Bool {
        operation != .acc
    }

    mutating func swap() {
        switch operation {
        case .acc: break
        case .jmp: operation = .nop
        case .nop: operation = .jmp
        }
    }
}

private struct Interpreter {
    var bootcode: Bootcode
    var position: Int = 0
    var accValue = 0

    init(bootcode: Bootcode) {
        self.bootcode = bootcode
    }

    private var visited = Set<Int>()
    mutating func findLoop() -> Int {
        while visited.insert(position).inserted {
            step()
        }
        return accValue
    }

    private mutating func step() {
        let current = bootcode[position]
        switch current.operation {
        case .acc:
            accValue += current.value
            position += 1
        case .jmp:
            position += current.value
        case .nop:
            position += 1
        }
    }

    private var visitedSwappableCommands = 0
    private var isFinished: Bool {
        position >= bootcode.count
    }
    mutating func tryToFix(attempt: Int) -> Bool {
        while visited.insert(position).inserted && !isFinished {
            if bootcode[position].canSwap {
                if attempt == visitedSwappableCommands {
                    bootcode[position].swap()
                }
                visitedSwappableCommands += 1
            }
            step()
        }
        return isFinished
    }
}

extension Instruction {
    init(string: String) {
        guard
            let operation = Operation(rawValue: String(string.prefix(3))),
            let value = Int(string.dropFirst(4))
        else {
            fatalError("Incorrect Input")
        }
        self.init(operation: operation, value: value)
    }
}

struct Solution_2020_08: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init)
        let bootcode = input.map(Instruction.init(string:))

        // ------- Part 1 -------
        var loopInterpreter = Interpreter(bootcode: bootcode)
        let part1 = loopInterpreter.findLoop()
        print(part1)

        // ------- Part 2 -------
        func fixInterpreter() -> Int {
            var attempt = 0
            while true {
                var attemptInterpreter = Interpreter(bootcode: bootcode)
                if attemptInterpreter.tryToFix(attempt: attempt) {
                    return attemptInterpreter.accValue
                }
                attempt += 1
            }
        }
        let part2 = fixInterpreter()
        print(part2)

        // ------- Test -------
        assert(part1 == 1801, "WA")
        assert(part2 == 2060, "WA")
    }
}
