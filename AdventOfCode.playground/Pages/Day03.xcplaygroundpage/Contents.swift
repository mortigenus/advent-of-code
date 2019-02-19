//: [Previous](@previous)

import UIKit

precedencegroup LeftAssoc {
    associativity: left
}
infix operator >>-: LeftAssoc
func >>-<T, U>(a: T?, f: (T) -> U?) -> U? {
    return a.flatMap(f)
}

struct Point: Hashable {
    let x: Int
    let y: Int
}

struct Patch {
    let id: String
    let x: Int
    let y: Int
    let width: Int
    let height: Int

    let points: [Point]

    init(id: String, x: Int, y: Int, width: Int, height: Int) {
        self.id = id
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.points = (x ..< x + width).flatMap { x0 in
            (y ..< y + height).map { y0 in
                return Point(x: x0, y: y0)
            }
        }
    }
}

extension Patch {
    init?(patchDescription: String) {
        let pattern = "#(?<id>[0-9]+) @ (?<x>[0-9]+),(?<y>[0-9]+): (?<width>[0-9]+)x(?<height>[0-9]+)"
        let match = (try? NSRegularExpression(pattern: pattern))
        >>- { regex in
            regex.firstMatch(in: patchDescription,
                             range: NSMakeRange(0, patchDescription.count))
        }

        let nameAndMatchToRange:
            (String) -> (NSTextCheckingResult) -> Range<String.Index>? = { name in
            return { match in
                Range(match.range(withName: name), in: patchDescription)
            }
        }
        let rangeToString: (Range) -> String? = { String(patchDescription[$0]) }
        let stringToInt: (String) -> Int? = { Int($0) }

        guard let id = match
            >>- nameAndMatchToRange("id")
            >>- rangeToString
            else { return nil }

        guard let x = match
            >>- nameAndMatchToRange("x")
            >>- rangeToString
            >>- stringToInt
            else { return nil }

        guard let y = match
            >>- nameAndMatchToRange("y")
            >>- rangeToString
            >>- stringToInt
            else { return nil }

        guard let width = match
            >>- nameAndMatchToRange("width")
            >>- rangeToString
            >>- stringToInt
            else { return nil }

        guard let height = match
            >>- nameAndMatchToRange("height")
            >>- rangeToString
            >>- stringToInt
            else { return nil }

        self.init(id: id, x: x, y: y, width: width, height: height)
    }
}

guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else {
    fatalError("Put input for the task into \"input.txt\" file")
}

let input = try String(contentsOfFile:path)

let patches = input
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: .newlines)
    .compactMap({ Patch(patchDescription: $0) })

let points = patches.flatMap({ $0.points })

let setOfPoints = NSCountedSet(array: points)

let part1 = setOfPoints.filter({
    setOfPoints.count(for: $0) > 1
}).count

let part2 = patches.first(where: { patch in
    patch.points.allSatisfy{ point in
        setOfPoints.count(for: point) == 1
    }
})?.id

// ------- Test -------

assert(part1 == 111630, "WA")
assert(part2 == "724", "WA")

//: [Next](@next)
