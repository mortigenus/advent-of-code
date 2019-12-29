//: [Previous](@previous)

import Foundation

let input = try readInput()

let values = input
    .split(separator: ",")
    .compactMap({ Int($0) })

// ------- Part 1 -------

var part1: Int?
var intcode = Intcode(program: values, input: 1)
intcode.output = { part1 = $0 }
intcode.run()
print(part1!)

// ------- Part 2 -------

var part2: Int?
intcode = Intcode(program: values, input: 5)
intcode.output = { part2 = $0 }
intcode.run()
print(part2!)

// ------- Test -------

assert(part1 == 6745903, "WA")
assert(part2 == 9168267, "WA")

//: [Next](@next)
