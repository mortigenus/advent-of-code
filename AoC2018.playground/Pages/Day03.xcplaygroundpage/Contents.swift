//: [Previous](@previous)

import Foundation

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
    init(patchDescription: String) {
        let pattern = "#(?<id>\\d+) @ (?<x>\\d+),(?<y>\\d+): (?<width>\\d+)x(?<height>\\d+)"
        let regex = try! NSRegularExpression(pattern: pattern)

        let captureGroupToString = regex.captureGroupToString(in: patchDescription)
        let captureGroupToInt = regex.captureGroupToInt(in: patchDescription)

        guard
            let id = captureGroupToString("id"),
            let x = captureGroupToInt("x"),
            let y = captureGroupToInt("y"),
            let width = captureGroupToInt("width"),
            let height = captureGroupToInt("height")
        else {
            fatalError("Wrong input format")
        }

        self.init(id: id, x: x, y: y, width: width, height: height)
    }
}

let input = try readInput()

let patches = input
    .components(separatedBy: .newlines)
    .map({ Patch(patchDescription: $0) })

let points = patches.flatMap({ $0.points })

let setOfPoints = NSCountedSet(array: points)

let part1 = setOfPoints.filter({
    setOfPoints.count(for: $0) > 1
}).count
print(part1)

let part2 = patches.first(where: { patch in
    patch.points.allSatisfy{ point in
        setOfPoints.count(for: point) == 1
    }
})!.id
print(part2)

// ------- Test -------

assert(part1 == 111630, "WA")
assert(part2 == "724", "WA")

//: [Next](@next)
