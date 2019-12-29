import Foundation

public class Intcode {
    public internal(set) var program: [Int]
    public init(program: [Int], input: [Int] = []) {
        self.program = program
        self.input = input
    }

    public convenience init(program: [Int], input: Int) {
        self.init(program: program, input: [input])
    }

    var input: [Int]
    public func send(input: Int) {
        self.input.append(input)
        if self.state == .paused {
            self.run()
        }
    }

    public var output: (Int) -> Void = { print($0) }
    
    public enum State {
        case running
        case paused
        case halted
    }
    public internal(set) var state: State = .running
    public func run() {
        self.state = .running
        while self.state == .running {
            self.step()
        }
    }

    var currentPosition: Int = 0

    func step() {
        let operation = program[currentPosition]
        switch Operation(rawValue: operation % 100)! {
        case .add:
            program[writePosition(3)] = param(1) + param(2)
            currentPosition += 4
        case .mult:
            program[writePosition(3)] = param(1) * param(2)
            currentPosition += 4
        case .read:
            if input.count > 0 {
                program[writePosition(1)] = input.removeFirst()
                currentPosition += 2
            } else {
                state = .paused
            }
        case .write:
            output(param(1))
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
            state = .halted
        }
    }

    enum Mode: Int {
        case position
        case immediate

        public init?(rawValue: Int) {
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

    func writePosition(_ number: Int) -> Int {
        program[currentPosition + number]
    }

    func param(_ number: Int) -> Int {
        let operation = program[currentPosition]
        let modes = [operation / 100, operation / 1000, operation / 10000]
            .map({ Mode(rawValue: $0)! })
        switch modes[number - 1] {
        case .position:
            return program[program[currentPosition + number]]
        case .immediate:
            return program[currentPosition + number]
        }
    }
}
