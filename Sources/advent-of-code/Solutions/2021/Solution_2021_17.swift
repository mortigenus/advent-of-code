//
//  Solution_2021_17.swift
//
//
//  Created by Ivan Chalov on 17.12.21.
//

import Foundation

struct Solution_2021_17: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .dropFirst("target area: ".count)
            .components(separatedBy: ", ")
            .map { str in str.dropFirst(2).components(separatedBy: "..").map { Int($0)! } }
        let targetX = input[0][0]...input[0][1]
        let targetY = input[1][0]...input[1][1]

        // ------- Part 1 -------
        func launch(x: Int, y: Int) -> Int? {
            var maxY = 0
            var position = (x: 0, y: 0)
            var velocity = (x: x, y: y)
            while position.x <= targetX.upperBound, position.y >= targetY.lowerBound {
                position.x += velocity.x
                position.y += velocity.y
                maxY = max(maxY, position.y)

                if targetX ~= position.x, targetY ~= position.y {
                    return maxY
                }

                velocity.x -= velocity.x.signum()
                velocity.y -= 1
            }
            return nil
        }

        let xRangeMax = max(abs(targetX.lowerBound), abs(targetX.upperBound))
        let yRangeMax = max(abs(targetY.lowerBound), abs(targetY.upperBound))
        let launchData = (-xRangeMax...xRangeMax).flatMap { x in
            (-yRangeMax...yRangeMax).compactMap { y in
                launch(x: x, y: y)
            }
        }

        let part1 = launchData.max()!
        print(part1)

        // ------- Part 2 -------
        let part2 = launchData.count
        print(part2)

        // ------- Test -------
        assert(part1 == 6786, "WA")
        assert(part2 == 2313, "WA")
    }

}
