//: [Previous](@previous)

import Foundation

let input = try readInput()

let polymer = input
//let polymer = input[input.startIndex...input.index(input.startIndex, offsetBy: 20)]

func shouldAnnihilate(_ a: Character, _ b: Character) -> Bool {
    return a.lowercased() == b.lowercased()
        && ((a.isLowercase && b.isUppercase) || (a.isUppercase && b.isLowercase))
}

let result: [Character] = polymer.reduce(into: []) { acc, c in
    if let top = acc.last, shouldAnnihilate(c, top) {
        acc.removeLast()
    } else {
        acc.append(c)
    }
}
let part1 = result.count
print(part1)

var prepareMap = [Character: [Character]]()
for char in "abcdefghijklmnopqrstuvwxyz" {
    prepareMap[char] = [Character]()
}

let map: [Character:[Character]] = polymer.reduce(into: prepareMap) { acc, c in
    acc.forEach { k, _ in
        guard String(k) != c.lowercased() else {
            return
        }
        if let top = acc[k]!.last, shouldAnnihilate(c, top) {
            acc[k]!.removeLast()
        } else {
            acc[k]!.append(c)
        }
    }
}
let part2 = map.values.map({ $0.count }).min()
print(part2!)

// ------- Test -------

assert(part1 == 11298, "WA")
assert(part2 == 5148, "WA")

//: [Next](@next)
