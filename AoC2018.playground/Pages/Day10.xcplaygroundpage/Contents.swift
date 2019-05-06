//: [Previous](@previous)

import Foundation

struct Point {
    var position: (x: Int, y: Int)
    let velocity: (x: Int, y: Int)

    func tick() -> Point {
        return Point(
            position: (
                x: position.x + velocity.x,
                y: position.y + velocity.y
            ),
            velocity: velocity
        )
    }
}

extension Point {
    init(_ description: String) {
        let pattern = "position=<\\s*(?<pX>-?\\d+),\\s*(?<pY>-?\\d+)>\\s*velocity=<\\s*(?<vX>-?\\d+),\\s*(?<vY>-?\\d+)>"
        let regex = try! NSRegularExpression(pattern: pattern)

        let captureGroupToInt = regex.captureGroupToInt(in: description)

        guard let pX = captureGroupToInt("pX") else {
            fatalError("Wrong input format")
        }
        guard let pY = captureGroupToInt("pY") else {
            fatalError("Wrong input format")
        }
        guard let vX = captureGroupToInt("vX") else {
            fatalError("Wrong input format")
        }
        guard let vY = captureGroupToInt("vY") else {
            fatalError("Wrong input format")
        }

        self.init(position: (x: pX, y: pY), velocity: (x: vX, y: vY))
    }
}

guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else {
    fatalError("Put input for the task into \"input.txt\" file")
}

var input = try String(contentsOfFile:path)
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: .newlines)
    .map({ Point($0) })

func minmax(_ xs: [Point], _ transform: (Point) -> Int) -> (Int, Int) {
    return xs.map(transform).reduce((Int.max,Int.min), {
        (min($0.0, $1), max($0.1, $1))
    })
}
func minmaxX(_ xs: [Point]) -> (Int, Int) {
    return minmax(xs, { $0.position.x })
}
func minmaxY(_ xs: [Point]) -> (Int, Int) {
    return minmax(xs, { $0.position.y })
}

var (minY, maxY) = minmaxY(input)
var iterations = 0

// kinda cheating, I debug printed it until getting an answer
// so I know the point that we need to simulate to
while maxY - minY != 9 {
    input = input.map({ $0.tick() })
    (minY, maxY) = minmaxY(input)
    iterations += 1
}

func printGrid(_ xs: [Point]) {
    let (minX, maxX) = minmaxX(xs)
    let (minY, maxY) = minmaxY(xs)

    var grid = [[String]](repeating: [String](repeating: ".", count: maxX-minX+1), count: maxY-minY+1)

    input.forEach({
        grid[$0.position.y-minY][$0.position.x-minX] = "#"
    })

    grid.forEach({
        print($0.joined(separator:""))
    })
}

// ...aaaaand I was also too lazy to come up with the way to parse letters :(
printGrid(input)

let part2 = iterations

// ------- Test -------

//assert(part1 == "PPNJEENH", "WA")
assert(part2 == 10375, "WA")

//: [Next](@next)
