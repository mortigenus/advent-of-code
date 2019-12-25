//: [Previous](@previous)

import Foundation

let input = try readInput()

let values = input
    .split(separator: ",")
    .compactMap({ Int($0) })

// ------- Part 1 -------

enum Mode: Int {
    case position
    case immediate

    init?(rawValue: Int) {
        switch rawValue % 10 {
        case 0:
            self = .position
        case 1:
            self = .immediate
        default:
            return nil
        }
    }
}

enum Operation: Int {
    case add = 1
    case mult
    case read
    case write
    case ifTrue
    case ifFalse
    case lessThan
    case equals
    case halt = 99
}

func value(at position: Int, mode: Mode, in program: [Int]) -> Int {
    switch mode {
    case .position:
        return program[program[position]]
    case .immediate:
        return program[position]
    }
}

func run(program: [Int], input: Int) -> [Int] {
    var program = program
    var output = [Int]()
    var currentPosition = 0
    programExecution: while currentPosition < program.count {
        let operation = program[currentPosition]
        let modes = [operation / 100, operation / 1000, operation / 10000]
            .map({ Mode(rawValue: $0)! })
        let param: (Int) -> Int = { number in
            return value(at: currentPosition + number, mode: modes[number - 1], in: program)
        }
        let writePosition: (Int) -> Int = { number in
            return program[currentPosition + number]
        }
        switch Operation(rawValue: operation % 100)! {
        case .add:
            program[writePosition(3)] = param(1) + param(2)
            currentPosition += 4
        case .mult:
            program[writePosition(3)] = param(1) * param(2)
            currentPosition += 4
        case .read:
            program[writePosition(1)] = input
            currentPosition += 2
        case .write:
            output.append(param(1))
            currentPosition += 2
        case .ifTrue:
            if param(1) != 0 {
                currentPosition = param(2)
            } else {
                currentPosition += 3
            }
        case .ifFalse:
            if param(1) == 0 {
                currentPosition = param(2)
            } else {
                currentPosition += 3
            }
        case .lessThan:
            program[writePosition(3)] = param(1) < param(2) ? 1 : 0
            currentPosition += 4
        case .equals:
            program[writePosition(3)] = param(1) == param(2) ? 1 : 0
            currentPosition += 4
        case .halt:
            break programExecution
        }
    }
    return output
}

let part1 = run(program: values, input: 1).last!
print(part1)

// ------- Part 2 -------

let part2 = run(program: values, input: 5).last!
print(part2)

// ------- Test -------

assert(part1 == 6745903, "WA")
assert(part2 == 9168267, "WA")

//: [Next](@next)
