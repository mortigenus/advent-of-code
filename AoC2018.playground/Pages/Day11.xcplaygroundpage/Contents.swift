//: [Previous](@previous)

import Foundation

let gridSerial = 6392

var grid = [[Int]](repeating: [Int](repeating: 0, count: 300), count: 300)

for x in 1...300 {
    for y in 1...300 {
        let rackId = x + 10
        grid[y-1][x-1] = ((rackId * y + gridSerial) * rackId) % 1000 / 100 - 5
    }
}

var maxSum = Int.min
var (maxX, maxY) = (0, 0)
for x in 0...297 {
    for y in 0...297 {

        let square = grid[y...(y+2)].map({ $0[x...(x+2)] })
        let sum = square.reduce(0, { $0 + $1.reduce(0,+) })

        if (sum > maxSum) {
            maxSum = sum
            (maxX, maxY) = (x, y)
        }

    }
}

let part1 = "\(maxX+1),\(maxY+1)"
print(part1)

var sums = [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: 0, count: 300), count: 300), count: 300)

maxSum = Int.min
var size = 0
(maxX, maxY) = (0, 0)

for s in 0..<300 {
    for y in 0..<(300-s) {
        for x in 0..<(300-s) {

            guard x + s < 300, y + s < 300 else {
                continue
            }

            if s == 0 {
                sums[s][y][x] = grid[y][x]
            } else {
                var newSum = 0
                for j in x...(x+s) {
                    newSum += grid[y+s][j]
                }
                for i in y..<(y+s) {
                    newSum += grid[i][x+s]
                }

                sums[s][y][x] = sums[s-1][y][x] + newSum
            }

            if sums[s][y][x] > maxSum {
                maxSum = sums[s][y][x]
                (size, maxX, maxY) = (s, x, y)
            }
        }
    }
}

let part2 = "\(maxX+1),\(maxY+1),\(size+1)"
print(part2)

// ------- Test -------

assert(part1 == "20,58", "WA")
assert(part2 == "233,268,13", "WA")

//: [Next](@next)
