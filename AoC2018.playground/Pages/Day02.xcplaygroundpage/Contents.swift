//: [Previous](@previous)

import Foundation

let input = try readInput()

// ------- Part 1 -------

let ids = input
    .components(separatedBy: .whitespacesAndNewlines)

func countLetters(_ s:String) -> NSCountedSet {
    return s.reduce(into: NSCountedSet()) { acc, c in
        acc.add(c)
    }
}

func solve(_ s:String) -> (Bool, Bool) {
    let counted = countLetters(s)

    let twice = counted.contains(where: { counted.count(for: $0) == 2 })
    let thrice = counted.contains(where: { counted.count(for: $0) == 3 })
    return (twice, thrice)
}

let b2i: (Bool) -> Int = { $0 ? 1 : 0 }

let (twice, thrice) = ids.reduce(into: (0,0), { (res, id) in
    let (twice, thrice) = solve(id)
    res.0 += b2i(twice)
    res.1 += b2i(thrice)
})

let part1 = twice * thrice
print(part1)

// ------- Part 2 -------

func distance(_ s1: String, _ s2: String) -> Int {
    //strings are the same length
    return s1.indices.reduce(into: 0, { (res, i) in
        res += b2i(s1[i] != s2[i])
    })
}

func commonPart(_ s1: String, _ s2: String) -> String {
    var resultString = s1
    if let index = s1.indices.first(where: { s1[$0] != s2[$0] }) {
        resultString.remove(at: index)
    }
    return resultString
}

//let lazyIds = ids.lazy
//let pairs = lazyIds.flatMap({ id1 in lazyIds.map ({ id2 in (id1, id2) }) })
//guard let pairIndex = pairs.firstIndex(where: { distance($0, $1) == 1 }) else {
//    fatalError("Should have found a pair...")
//}
//
//let pair = pairs[pairIndex]
//let part2 = commonPart(pair.0, pair.1)

func solve2(_ ids: [String]) -> String {
    for i in ids.indices {
        for j in (i + 1)..<ids.endIndex {
            if distance(ids[i], ids[j]) == 1 {
                return commonPart(ids[i], ids[j])
            }
        }
    }
    fatalError("Shouldn't happen")
}

let part2 = solve2(ids)
print(part2)

// ------- Test -------

assert(part1 == 8715, "WA")
assert(part2 == "fvstwblgqkhpuixdrnevmaycd", "WA")

//: [Next](@next)
