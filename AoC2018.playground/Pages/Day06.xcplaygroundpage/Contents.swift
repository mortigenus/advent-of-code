//: [Previous](@previous)

import Foundation

let input = try readInput()
    .components(separatedBy: .newlines)
    .map { $0.components(separatedBy: ", ") }
    .map { $0.compactMap { Int($0) } }
    .enumerated()
    .map { (id: $0.offset + 1, x: $0.element.first!, y: $0.element.last!) }

let range = input
    .reduce((minX:Int.max, maxX:Int.min, minY:Int.max, maxY:Int.min)) { acc, point in
        return (
            min(point.x, acc.minX),
            max(point.x, acc.maxX),
            min(point.y, acc.minY),
            max(point.y, acc.maxY)
        )
}

let generateGrid: ((minX: Int, maxX: Int, minY: Int, maxY: Int)) -> [(x: Int, y: Int)] = { range in
    return (range.minX...range.maxX).flatMap { x in
        (range.minY...range.maxY).map { y in
            return (x:x, y:y)
        }
    }
}

let grid = generateGrid(range)

func solvePart1() -> Int {

    let closestPoint: ((x: Int, y: Int)) -> Int = { cell in
        return input.reduce(into:(distance: Int.max, id: 0), { acc, point in
            let distance = abs(point.x - cell.x) + abs(point.y - cell.y)
            if distance < acc.distance {
                acc.distance = distance
                acc.id = point.id
            } else if distance == acc.distance {
                // resetting id if several points are the closest
                acc.id = 0
            }
        }).id
    }

    let distances = grid.map(closestPoint)

    var infinities = Set<Int>()
    grid.enumerated().forEach {
        if $0.element.x == range.minX
            || $0.element.x == range.maxX
            || $0.element.y == range.minY
            || $0.element.y == range.maxY {
            infinities.insert(distances[$0.offset])
        }
    }

    var counted = NSCountedSet()

    distances.forEach {
        if !infinities.contains($0) {
            counted.add($0)
        }
    }

    let part1 = counted.count(for:
        counted.max(by: { counted.count(for: $0) < counted.count(for: $1) }) as! Int
    )

    return part1
}

let part1 = solvePart1()
print(part1)

func solvePart2() -> Int {

    let distanceSum: ((x: Int, y: Int)) -> Int = { cell in
        return input.reduce(0) {
            $0 + abs($1.x - cell.x) + abs($1.y - cell.y)
        }
    }

    let distanceSums = grid.map(distanceSum)

    let part2 = distanceSums.filter { $0 < 10_000 }.count

    return part2

}

let part2 = solvePart2()
print(part2)

// ------- Test -------

assert(part1 == 4589, "WA")
assert(part2 == 40252, "WA")

//: [Next](@next)
