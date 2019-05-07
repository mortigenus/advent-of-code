//
//  AoCTests.swift
//  AoCTests
//
//  Created by Ivan Chalov on 06/05/2019.
//  Copyright © 2019 Ivan Chalov. All rights reserved.
//

import XCTest

class AoCTests: XCTestCase {

    func testPerformance1() {
        var grid = [[Int]](repeating: [Int](repeating: 0, count: 3000), count: 3000)

        let (x, y, s) = (30, 50, 1215)
        self.measure {
            let newSum = grid[y+s][x...(x+s)].reduce(into:0, {$0 += $1})
        }
    }

    func testPerformance2() {
        var grid = [[Int]](repeating: [Int](repeating: 0, count: 3000), count: 3000)

        let (x, y, s) = (30, 50, 1215)
        self.measure {
            var newSum = 0
            for j in x...(x+s) {
                newSum += grid[y+s][j]
            }
        }
    }


}
