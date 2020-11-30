import Foundation

private enum State: String {
    case dead = "."
    case alive = "#"
}

struct Solution_2018_12: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .components(separatedBy: .newlines)

        let initialState = input[0][input[0].firstIndex(where: { $0 == "." || $0 == "#" })!...]
            .map({ State(rawValue: String($0))! })
        let length = initialState.count
        let rules = input[2...]
            .reduce(into:[[State]:State]()) { acc, str in
                let pattern = str[...str.index(str.startIndex, offsetBy: 4)]
                    .map({ State(rawValue: String($0))! })
                let result = State(rawValue: String(str.last!))!
                acc[pattern] = result
            }

        var state = [State](repeating:.dead, count:length * 4)

        for i in 0..<length {
            state[i + length] = initialState[i]
        }

        func tick(_ state: [State]) -> [State] {
            var newState = [State](repeating:.dead, count:state.count)
            for i in state.indices {
                guard i >= 2, i < state.count - 2 else { continue }

                newState[i] = rules[Array(state[(i-2)...(i+2)])]!
            }
            return newState
        }

        for _ in 0..<20 {
            state = tick(state)
        }

        func calc(_ state: [State]) -> Int {
            return state.enumerated().reduce(0) { acc, x in
                if x.element == .dead {
                    return acc
                }
                return acc + (x.offset - length)
            }
        }

        let part1 = calc(state)
        print(part1)

        // if we continue `tick()`ing, we'll get to the point when all the flowers
        // are travelling to the right one pot a tick in a stable formation

        // debug printing showed that 200 iterations is enough
        let iterations = 200
        for _ in 20..<(iterations - 1) {
            state = tick(state)
        }
        let value1 = calc(state)
        state = tick(state)
        let value2 = calc(state)
        let diff = value2 - value1
        let part2 = (50_000_000_000 - iterations) * diff + value2
        print(part2)

        // ------- Test -------

        assert(part1 == 2049, "WA")
        assert(part2 == 2300000000006, "WA")
    }
}
