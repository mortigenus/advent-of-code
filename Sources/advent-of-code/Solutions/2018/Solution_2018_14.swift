import Foundation

private func digits(_ input: Int) -> [Int] {
    return String(input).compactMap({ Int(String($0)) })
}

private struct State {
    var scores = [3 ,7]
    var (i, j) = (0, 1)

    func generateNewScores() -> [Int] {
        return digits(scores[i] + scores[j])
    }

    func newIndex(for currentRecipe: Int) -> Int {
        return (currentRecipe + scores[currentRecipe] + 1) % scores.count
    }

    // returns newly added scores
    @discardableResult
    mutating func tick() -> [Int] {
        let new = generateNewScores()
        scores.append(contentsOf: new)

        i = newIndex(for: i)
        j = newIndex(for: j)

        return new
    }
}

struct Solution_2018_14: Solution {
    var input: Input
    func run() {
        let input = 635041

        var state = State()

        while state.scores.count < input + 10 {
            state.tick()
        }

        let part1 = state.scores[input..<(input + 10)].map({String($0)}).joined(separator: "")
        print(part1)

        state = State()
        let target = ArraySlice(digits(input))
        let targetLength = target.count
        var part2: Int?

        while true {
            // `new` can only have 1 or 2 elements
            let new = state.tick()

            if state.scores.suffix(targetLength) == target {
                part2 = state.scores.count - targetLength
                break
            } else if new.count > 1 && state.scores.suffix(targetLength + 1).prefix(targetLength) == target {
                part2 = state.scores.count - targetLength - 1
                break
            }
        }

        print(part2!)

        // ------- Test -------

        assert(part1 == "1150511382", "WA")
        assert(part2 == 20173656, "WA")
    }
}
