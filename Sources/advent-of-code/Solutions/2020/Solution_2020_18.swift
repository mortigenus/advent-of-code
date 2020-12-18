//
//  Solution_2020_18.swift
//
//
//  Created by Ivan Chalov on 18.12.20.
//

import Foundation
import Algorithms
import Prelude

private enum Token: Equatable {
    enum Op {
        case plus
        case mult

        static func isHigherOrEqualPrecedence1(_ op1: Op, _ op2: Op) -> Bool {
            true
        }

        static func isHigherOrEqualPrecedence2(_ op1: Op, _ op2: Op) -> Bool {
            op1 == op2 || (op1 == .plus && op2 == .mult)
        }
    }
    case digit(Int)
    case `operator`(Op)
    case openParen
    case closeParen

    init(char: Character) {
        if let digit = Int(String(char)) {
            self = .digit(digit)
            return
        }
        switch char {
        case "+": self = .operator(.plus)
        case "*": self = .operator(.mult)
        case "(": self = .openParen
        case ")": self = .closeParen
        default: fatalError("Incorrect Input")
        }
    }
}

private struct Equation {
    private var reversePolishNotation: [Token]

    init(part: Int, string: String) {
        var operatorsStack = [Token]()
        var output = [Token]()
        let isHigherOrEqualPrecedence = part == 1
            ? Token.Op.isHigherOrEqualPrecedence1
            : Token.Op.isHigherOrEqualPrecedence2
        for char in string {
            guard !char.isWhitespace else { continue }
            let token = Token(char: char)
            switch token {
            case .digit:
                output.append(token)
            case let .operator(op):
                while
                    let last = operatorsStack.last,
                    last != .openParen,
                    case let .operator(lastOp) = last,
                    isHigherOrEqualPrecedence(lastOp, op)
                {
                    output.append(operatorsStack.removeLast())
                }
                operatorsStack.append(token)
            case .openParen:
                operatorsStack.append(token)
            case .closeParen:
                var op = operatorsStack.removeLast()
                while op != .openParen {
                    output.append(op)
                    op = operatorsStack.removeLast()
                }
            }
        }
        output.append(contentsOf: operatorsStack.reversed())
        reversePolishNotation = output
    }

    var value: Int {
        var calculationStack = [Int]()
        for token in reversePolishNotation {
            switch token {
            case let .digit(d):
                calculationStack.append(d)
            case let .operator(op):
                let a = calculationStack.removeLast()
                let b = calculationStack.removeLast()
                switch op {
                case .plus: calculationStack.append(a + b)
                case .mult: calculationStack.append(a * b)
                }
            default:
                fatalError("Unexpected token: \(token)")
            }
        }
        return calculationStack.last!
    }
}

struct Solution_2020_18: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(String.init)

        // ------- Part 1 -------
        let part1 = input.map(curry(Equation.init(part:string:))(1) >>>  \.value).sum()
        print(part1)

        // ------- Part 2 -------
        let part2 = input.map(curry(Equation.init(part:string:))(2) >>>  \.value).sum()
        print(part2)

        // ------- Test -------
        assert(part1 == 30753705453324, "WA")
        assert(part2 == 244817530095503, "WA")
    }
}
