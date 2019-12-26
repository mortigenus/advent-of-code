//: [Previous](@previous)

import Foundation

let input = try readInput()
    .split { $0.isNewline }
    .map { line in
        line.split(separator: ")").map { String($0) }
    }


// ------- Part 1 -------

typealias OrbitMap = [String: [String]]

let orbitMap = input
    .reduce(into:OrbitMap()) { acc, x in
        acc[x[0], default:[]].append(x[1])
    }

func countOrbits(in orbitMap: OrbitMap) -> Int {
    func count(keys: [String]) -> Int {
        let directCount = keys
            .compactMap { orbitMap[$0]?.count }
            .reduce(0, +)
        let indirectCount = keys
            .compactMap { orbitMap[$0] }
            .map { count(keys: $0) }
            .reduce(0, +)
        return directCount + indirectCount
    }
    return count(keys: Array(orbitMap.keys))
}

let part1 = countOrbits(in: orbitMap)
print(part1)

// ------- Part 2 -------

let reverseOrbitMap = input
    .reduce(into:[String: String]()) { acc, x in
        acc[x[1]] = x[0]
    }

func findParent(for object: String) -> String? {
    reverseOrbitMap[object]
}

let yourParent = findParent(for: "YOU")
let santaParent = findParent(for: "SAN")
var parent1 = yourParent
var parent2 = santaParent
var pathToCommonParent1 = 0
var pathToCommonParent2 = 0
while parent1 != parent2 {
    pathToCommonParent1 += 1
    parent1 = findParent(for: parent1!)
    parent2 = santaParent
    pathToCommonParent2 = 0
    while parent2 != nil && parent2 != parent1 {
        parent2 = findParent(for: parent2!)
        pathToCommonParent2 += 1
    }
}

let part2 = pathToCommonParent1 + pathToCommonParent2
print(part2)

// ------- Test -------

assert(part1 == 145250, "WA")
assert(part2 == 274, "WA")

//: [Next](@next)
