//: [Previous](@previous)

import Foundation

guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else {
    fatalError("Put input for the task into \"input.txt\" file")
}

let input = try String(contentsOfFile:path)

let frequencies = input
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: .whitespacesAndNewlines)
    .compactMap({ Int($0) })

// ------- Part 1 -------

let part1 = frequencies.reduce(0, +)

// ------- Part 2 -------

var current = 0
var index = 0
var visited = Set<Int>()

while visited.insert(current).inserted {
    current += frequencies[index]
    index = (index + 1) % frequencies.count
}

let part2 = current

/*
 Originally my solution was to construct an infinite lazy sequence : D

 let repeatedFrequencies = sequence(first: (0, frequencies[0]), next: { (idx, _) in
     let next = (idx + 1) % frequencies.count
     return (next, frequencies[next])
 }).lazy.map({$0.1})

 var current = 0
 var visited = Set<Int>([current])

 _ = repeatedFrequencies.first(where: { change in
     current += change
     return !visited.insert(current).inserted
 })

 let part2 = current
*/

// ------- Test -------

assert(part1 == 425, "WA")
assert(part2 == 57538, "WA")

//: [Next](@next)
