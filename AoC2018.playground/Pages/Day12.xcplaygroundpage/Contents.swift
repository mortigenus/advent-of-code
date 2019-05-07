//: [Previous](@previous)

import Foundation

var input = try readInput()
    .components(separatedBy: .newlines)

let initialState = input[0][input[0].firstIndex(of: ".")!...]
let rules = input[2...]

// ------- Test -------

//assert(part1 == "PPNJEENH", "WA")
//assert(part2 == 10375, "WA")

//: [Next](@next)
