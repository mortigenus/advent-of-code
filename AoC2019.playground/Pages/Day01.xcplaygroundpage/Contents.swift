//: [Previous](@previous)

import Foundation

let input = try readInput()

let masses = input
    .components(separatedBy: .whitespacesAndNewlines)
    .compactMap({ Int($0) })

// ------- Part 1 -------

func fuelNeeded(for mass: Int) -> Int {
    return max((mass / 3) - 2, 0)
}

let part1 = masses
    .map { fuelNeeded(for: $0) }
    .reduce(0, +)
print(part1)

// ------- Part 2 -------

func fuelNeededCountingFuel(for mass: Int) -> Int {
    guard mass > 0 else {
        return 0
    }

    let fuelMass = max((mass / 3) - 2, 0)
    return fuelMass + fuelNeededCountingFuel(for: fuelMass)
}

let part2 = masses
    .map { fuelNeededCountingFuel(for: $0) }
    .reduce(0, +)
print(part2)

// ------- Test -------

assert(part1 == 3268951, "WA")
assert(part2 == 4900568, "WA")

//: [Next](@next)
