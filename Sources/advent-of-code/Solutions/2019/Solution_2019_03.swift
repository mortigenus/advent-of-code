import Foundation

private struct Instruction {
    enum Direction: String {
        case right = "R"
        case left = "L"
        case up = "U"
        case down = "D"
    }
    let direction: Direction
    let distance: Int

    init(string: String) {
        var value = string
        self.direction = Direction(rawValue:String(value.removeFirst()))!
        self.distance = Int(value)!
    }

    func positions(from position: Pair) -> [Pair] {
        switch self.direction {
        case .up:
            return ((position.y + 1)...(position.y + self.distance)).map {
                Pair(x: position.x, y: $0)
            }
        case .down:
            return ((position.y - self.distance)...(position.y - 1)).reversed().map {
                Pair(x: position.x, y: $0)
            }
        case .left:
            return ((position.x - self.distance)...(position.x - 1)).reversed().map {
                Pair(x: $0, y: position.y)
            }
        case .right:
            return ((position.x + 1)...(position.x + self.distance)).map {
                Pair(x: $0, y: position.y)
            }
        }
    }
}

private struct Pair: Hashable, Equatable {
    var x: Int
    var y: Int

    mutating func move(by instruction: Instruction) {
        switch instruction.direction {
        case .up:
            y += instruction.distance
        case .down:
            y -= instruction.distance
        case .left:
            x -= instruction.distance
        case .right:
            x += instruction.distance
        }
    }
}

struct Solution_2019_03: Solution {
    var input: Input
    func run() throws {
        let instructions = try input.get()
            .split { $0.isNewline }
            .map { instructionLine in
                instructionLine
                    .split(separator: ",")
                    .map({ String($0) })
                    .map({ Instruction(string: $0) })
            }

        // ------- Part 1 -------

        var currentPosition = Pair(x: 0, y: 0)
        var steps = 1
        let set1 = instructions[0].reduce(into: [Pair : Int]()) { acc, instruction in
            instruction.positions(from: currentPosition).forEach {
                if acc[$0] == nil {
                    acc[$0] = steps
                }
                steps += 1
            }
            currentPosition.move(by: instruction)
        }
        currentPosition = Pair(x: 0, y: 0)
        steps = 1
        let set2 = instructions[1].reduce(into: [Pair : Int]()) { acc, instruction in
            instruction.positions(from: currentPosition).forEach {
                if acc[$0] == nil {
                    acc[$0] = steps
                }
                steps += 1
            }
            currentPosition.move(by: instruction)
        }

        let intersections = set1.reduce(into: [(Pair, Int)]()) { acc, kvPair in
            let (pair, steps) = kvPair
            guard pair.x != 0 || pair.y != 0 else {
                return
            }
            if let secondSteps = set2[pair] {
                acc.append((pair, steps + secondSteps))
            }
        }

        let pair = intersections
            .map({ $0.0 })
            .min(by: { ($0.x + $0.y) < ($1.x + $1.y) })!
        let part1 = pair.x + pair.y
        print(part1)

        // ------- Part 2 -------

        let part2 = intersections
            .map({ $0.1 })
            .min()!
        print(part2)

        // ------- Test -------

        assert(part1 == 2129, "WA")
        assert(part2 == 134662, "WA")
    }
}
