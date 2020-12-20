import Foundation

public class Intcode {

    public private(set) var program: [Int]

    private typealias Memory = [Int: Int]
    private var memory: Memory

    public init(program: [Int], input: [Int] = []) {
        self.program = program
        self.memory = Memory(uniqueKeysWithValues: zip(0..., program))
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

    public var output: ((Int) -> Void)?
    
    public enum State {
        case running
        case paused
        case halted
    }
    public internal(set) var state: State = .running

    @discardableResult
    public func run() -> [Int] {
        self.state = .running
        var result = [Int]()
        while self.state == .running {
            if let stepOutput = self.step() {
                result.append(stepOutput)
            }
        }
        return result
    }

    var currentPosition = 0
    var relativeBase = 0

    func step() -> Int? {
        let operation = readMemory(at: currentPosition)
        switch Operation(rawValue: operation % 100)! {
        case .add:
            writeToMemory(at: position(3), param(1) + param(2))
            currentPosition += 4
        case .mult:
            writeToMemory(at: position(3), param(1) * param(2))
            currentPosition += 4
        case .read:
            if input.count > 0 {
                writeToMemory(at: position(1), input.removeFirst())
                currentPosition += 2
            } else {
                state = .paused
            }
        case .write:
            let value = param(1)
            output?(value)
            currentPosition += 2
            return value
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
            writeToMemory(at: position(3), param(1) < param(2) ? 1 : 0)
            currentPosition += 4
        case .equals:
            writeToMemory(at: position(3), param(1) == param(2) ? 1 : 0)
            currentPosition += 4
        case .adjust:
            relativeBase += param(1)
            currentPosition += 2
        case .halt:
            state = .halted
        }
        return nil
    }

    enum Mode: Int {
        case position
        case immediate
        case relative

        public init?(rawValue: Int) {
            switch rawValue % 10 {
            case 0:
                self = .position
            case 1:
                self = .immediate
            case 2:
                self = .relative
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
        case adjust
        case halt = 99
    }


    public func readMemory(at address: Int) -> Int {
        memory[address, default: 0]
    }

    func writeToMemory(at address: Int, _ value: Int) {
        memory[address] = value
    }

    func position(_ number: Int) -> Int {
        let operation = program[currentPosition]
        let modes = [operation / 100, operation / 1000, operation / 10000]
            .map({ Mode(rawValue: $0)! })
        switch modes[number - 1] {
        case .position:
            return readMemory(at: currentPosition + number)
        case .immediate:
            return currentPosition + number
        case .relative:
            return relativeBase + readMemory(at: currentPosition + number)
        }
    }

    func param(_ number: Int) -> Int {
        readMemory(at: position(number))
    }
}
