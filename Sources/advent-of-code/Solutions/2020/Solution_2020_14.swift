//
//  Solution_2020_14.swift
//
//
//  Created by Ivan Chalov on 14.12.20.
//

import Foundation
import Algorithms
import Prelude

private enum Instruction {
    case mask(String)
    case mem(address: Int, value: Int)
}

extension Instruction {
    init(string: String) {
        if string.hasPrefix("mask") {
            self = .mask(string |> flip(String.dropFirst)(7) >>> String.init)
        }
        else if string.hasPrefix("mem") {
            let scanner = Scanner(string: string)
            scanner.currentIndex = string.index(scanner.currentIndex, offsetBy: "mem[".count)
            let address = scanner.scanInt()!
            scanner.currentIndex = string.index(scanner.currentIndex, offsetBy: "] = ".count)
            let value = scanner.scanInt()!
            self = .mem(address: address, value: value)
        } else {
            fatalError("Incorrect Input")
        }
    }
}

private protocol Chip {
    var mem: [Int: Int] { get set }
    var sum: Int { get }
    mutating func apply(instructions: [Instruction])
    mutating func apply(_ instruction: Instruction)
}

extension Chip {
    var sum: Int {
        mem.map(\.value).sum()
    }

    mutating func apply(instructions: [Instruction]) {
        instructions.forEach { apply($0) }
    }
}

private struct Chip1: Chip {
    var mask = ""
    var mem = [Int: Int]()

    mutating func apply(_ instruction: Instruction) {
        switch instruction {
        case let .mask(mask):
            self.mask = mask
        case let .mem(address: address, value: value):
            set(value, at: address)
        }
    }

    private mutating func set(
        _ value: Int,
        at address: Int
    ) {
        let (newValue: newValue, power: _, current: _) = mask.reversed().reduce(
            into: (newValue: 0, power: 1, current: value)
        ) { acc, x in
            let digit: Int
            if let maskDigit = Int(String(x)) {
                digit = maskDigit
            } else {
                digit = acc.current % 2
            }
            acc.newValue += digit * acc.power
            acc.current /= 2
            acc.power *= 2
        }
        mem[address] = newValue
    }
}

private struct Chip2: Chip {
    var mask = [Character]()
    var mem = [Int: Int]()

    mutating func apply(_ instruction: Instruction) {
        switch instruction {
        case let .mask(mask):
            self.mask = mask.map(id)
        case let .mem(address: address, value: value):
            set(value, at: address)
        }
    }

    private mutating func set(
        _ value: Int,
        at address: Int,
        _ index: Int = 0,
        _ power: Int = 1,
        _ newAddress: Int = 0
    ) {
        if index == mask.count {
            mem[newAddress] = value
            return
        }
        switch mask.reversed()[index] {
        case "1":
            set(value, at: address / 2, index + 1, power * 2, newAddress + power)
        case "0":
            set(value, at: address / 2, index + 1, power * 2, newAddress + (address % 2) * power)
        case "X":
            set(value, at: address / 2, index + 1, power * 2, newAddress + power)
            set(value, at: address / 2, index + 1, power * 2, newAddress)
        default:
            fatalError("Incorrect Mask")
        }
    }
}

struct Solution_2020_14: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init >>> Instruction.init(string:))

        // ------- Part 1 -------
        var chip1 = Chip1()
        chip1.apply(instructions: input)
        let part1 = chip1.sum
        print(part1)

        // ------- Part 2 -------
        var chip2 = Chip2()
        chip2.apply(instructions: input)
        let part2 = chip2.sum
        print(part2)

        // ------- Test -------
        assert(part1 == 17481577045893, "WA")
        assert(part2 == 4160009892257, "WA")
    }
}
