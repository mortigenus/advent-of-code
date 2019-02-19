//: [Previous](@previous)

import Foundation

guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else {
    fatalError("Put input for the task into \"input.txt\" file")
}

let input = try String(contentsOfFile:path)

// ------- Part 1 -------

let ids = input
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: .whitespacesAndNewlines)

func countLetters(_ s:String) -> [Character:Int] {
    var dict = [Character:Int]()
    s.forEach { c in
        dict[c] = (dict[c] ?? 0) + 1
    }
    return dict
}

func solve(_ s:String) -> (Bool, Bool) {
    let dict = countLetters(s)
    let twice = dict.firstIndex(where: {(_,v) in v == 2}) != nil
    let thrice = dict.firstIndex(where: {(_,v) in v == 3}) != nil
    return (twice, thrice)
}

let b2i: (Bool) -> Int = { $0 ? 1 : 0 }

let (twice, thrice) = ids.reduce((0,0), { (res, id) in
    let (twice, thrice) = solve(id)
    return (res.0 + b2i(twice), res.1 + b2i(thrice))
})

let part1 = twice * thrice

// ------- Part 2 -------

func distance(_ s1: String, _ s2: String) -> Int {
    //strings are the same length2
    return s1.indices.reduce(0, { (res, i) in
        return res + b2i(s1[i] != s2[i])
    })
}

func commonPart(_ s1: String, _ s2: String) -> String {
    var resultString = s1
    if let index = s1.indices.first(where: { i in s1[i] != s2[i] }) {
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

// ------- Test -------

assert(part1 == 8715, "WA")
assert(part2 == "fvstwblgqkhpuixdrnevmaycd", "WA")

//: [Next](@next)
