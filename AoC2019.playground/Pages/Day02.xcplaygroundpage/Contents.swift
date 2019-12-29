//: [Previous](@previous)

import Foundation

let input = try readInput()

let values = input
    .split(separator: ",")
    .compactMap({ Int($0) })

// ------- Part 1 -------

func run(program: [Int], _ noun: Int, _ verb: Int) -> Int {
    var program = program
    program[1] = noun
    program[2] = verb

    let intcode = Intcode(program: program)
    intcode.run()
    return intcode.program[0]
}

let part1 = run(program: values, 12, 2)
print(part1)

// ------- Part 2 -------

let desiredOutput = 19690720
var result = (0, 0)
findSolution: for noun in 0...99 {
    for verb in 0...99 {
        if run(program: values, noun, verb) == desiredOutput {
            result = (noun, verb)
            break findSolution
        }
    }
}
let part2 = result.0 * 100 + result.1
print(part2)

// ------- Test -------

assert(part1 == 2890696, "WA")
assert(part2 == 8226, "WA")

//: [Next](@next)
