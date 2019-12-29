//: [Previous](@previous)

import Foundation

let input = try readInput()

let values = input
    .split(separator: ",")
    .compactMap({ Int($0) })

// ------- Part 1 -------

func generatePermutations(for array: [Int]) -> [[Int]] {
    var permutation = array
    var result = [[Int]]()
    func heapPermutation(count: Int) {
        if count == 1 {
            result.append(permutation)
            return
        }

        for i in 0..<count {
            heapPermutation(count: count - 1)
            if count % 2 == 1 {
                permutation.swapAt(0, count - 1)
            } else {
                permutation.swapAt(i, count - 1)
            }
        }
    }
    heapPermutation(count: array.count)
    return result
}

func run(program: [Int], phases: [Int], feedbackMode: Bool = false) -> Int {
    var result: Int?

    let intcodes = phases
        .map { Intcode(program: program, input: $0) }
    intcodes[0].send(input: 0)

    let last = intcodes.count - 1

    intcodes[0..<last]
        .enumerated()
        .forEach { index, intcode in
            intcode.output = { intcodes[index + 1].send(input: $0) }
        }
    intcodes[last].output = {
        if feedbackMode {
            intcodes[0].send(input: $0)
        }
        result = $0
    }

    intcodes.forEach { $0.run() }

    return result!
}

let permutations = generatePermutations(for: Array(0...4))
let part1 = permutations.reduce(Int.min) { acc, x in
    return max(acc, run(program: values, phases: x))
}

print(part1)

// ------- Part 2 -------

let permutations2 = generatePermutations(for: Array(5...9))
let part2 = permutations2.reduce(Int.min) { acc, x in
    return max(acc, run(program: values, phases: x, feedbackMode: true))
}

print(part2)

// ------- Test -------

assert(part1 == 118936, "WA")
assert(part2 == 57660948, "WA")

//: [Next](@next)
