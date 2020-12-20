//
//  Solution_2020_20.swift
//
//
//  Created by Ivan Chalov on 20.12.20.
//

import Foundation
import Algorithms
import Prelude


private struct Tile: CustomDebugStringConvertible {
    var tileId: Int
    var content: [[Character]]

    var debugDescription: String {
        var debugString = "Tile \(tileId):\n"
        for row in content {
            debugString += "\(String(row))\n"
        }
        return debugString
    }

    var clockwiseFromTopPossibleEdges: [[[Character]]] {
        [
            [
                content.first!,
                content.first!.reversed(),
            ],
            [
                content[column: 9],
                content[column: 9].reversed(),
            ],
            [
                content.last!,
                content.last!.reversed(),
            ],
            [
                content[column: 0],
                content[column: 0].reversed(),
            ],
        ]
    }

    var possibleEdges: FlattenSequence<[[[Character]]]> {
        clockwiseFromTopPossibleEdges.joined()
    }

    mutating func rotate(times: Int) {
        self.content.rotate(times: times)
    }

    mutating func hflip() {
        self.content .hflip()
    }

    mutating func vflip() {
        self.content.vflip()
    }

    var insides: [[Character]] {
        self.content.dropFirst().dropLast().map { $0.dropFirst().dropLast() }
    }
}

private extension Array where Element == Array<Character> {
    mutating func rotate(times: Int) {
        let times = times % 4
        if times == 0 { return }
        if times == 1 { self = self.indices.map { self[column: $0] }; self.hflip() }
        if times == 2 { self.vflip(); self.hflip() }
        if times == 3 { self.rotate(times: 1); self.rotate(times: 2) }
    }

    mutating func hflip() {
        self = self.map { $0.reversed() }
    }

    mutating func vflip() {
        self = self.reversed()
    }
}

extension Tile {
    init(string: String) {
        let (tileId, content) = string
            .split(whereSeparator: \.isNewline)
            .map(String.init)
            |> { (rows: [String]) -> (Int, [[Character]]) in
                (
                    Int(rows[0].dropFirst(5).dropLast())!,
                    rows.dropFirst().map { $0.map(id) }
                )
            }
        self.init(tileId: tileId, content: content)
    }

}

struct Solution_2020_20: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .components(separatedBy: "\n\n")
            .map(Tile.init(string:))
        let tiles = Dictionary(uniqueKeysWithValues: input.map { ($0.tileId, $0) })

        // ------- Part 1 -------
        let possibleEdges = input
            .flatMap { tile -> [(String, Int)] in
                tile.possibleEdges.map { (String($0), tile.tileId) }
            }
            .sorted(by: { $0.0 < $1.0 })
        var matchedEdges = [Int: Int]()
        var index = 0
        while index < possibleEdges.count {
            if possibleEdges[index].0 == possibleEdges[index + 1].0 {
                matchedEdges[possibleEdges[index].1, default: 0] += 1
                matchedEdges[possibleEdges[index + 1].1, default: 0] += 1
                index += 2
            } else {
                index += 1
            }
        }
        var corners = matchedEdges.filter { $0.value == 4 }
        let part1 = corners.keys.product()
        print(part1)

        // ------- Part 2 -------
        let startingCorner = tiles[corners.keys.first!]!
//        let startingCorner = tiles[2801]!
        corners.removeValue(forKey: startingCorner.tileId)
        var outerEdges = matchedEdges.filter { $0.value == 6 }
        var innerTiles = matchedEdges.filter { $0.value == 8 }
        var puzzle = [[Tile]]()
        // gathering the first row
        puzzle.append([startingCorner])
        var currentRow = 0
        var currentColumn = 1
        var previousTile = startingCorner
        while currentColumn != 11 {
            for tileId in Set(outerEdges.keys) {
                let tile = tiles[tileId]!
                if Set(tile.possibleEdges).intersection(Set(previousTile.possibleEdges)).count == 2 {
                    currentColumn += 1
                    puzzle[currentRow].append(tile)
                    previousTile = tile
                    outerEdges.removeValue(forKey: tileId)
                    break
                }
            }
        }
        for tileId in Set(corners.keys) {
            let tile = tiles[tileId]!
            if Set(tile.possibleEdges).intersection(Set(previousTile.possibleEdges)).count == 2 {
                currentColumn = 0
                puzzle[currentRow].append(tile)
                previousTile = puzzle[currentRow][0]
                corners.removeValue(forKey: tileId)
                currentRow += 1
                break
            }
        }
        // gathering rows before the last one
        while currentRow != 11 {
            puzzle.append([])
            for tileId in Set(outerEdges.keys) {
                let tile = tiles[tileId]!
                if Set(tile.possibleEdges).intersection(Set(previousTile.possibleEdges)).count == 2 {
                    currentColumn += 1
                    puzzle[currentRow].append(tile)
                    previousTile = tile
                    outerEdges.removeValue(forKey: tileId)
                    break
                }
            }
            while currentColumn != 11 {
                for tileId in Set(innerTiles.keys) {
                    let tile = tiles[tileId]!
                    if
                        Set(tile.possibleEdges).intersection(Set(previousTile.possibleEdges)).count == 2,
                        Set(tile.possibleEdges).intersection(Set(puzzle[currentRow - 1][currentColumn].possibleEdges)).count == 2
                    {
                        currentColumn += 1
                        puzzle[currentRow].append(tile)
                        previousTile = tile
                        innerTiles.removeValue(forKey: tileId)
                        break
                    }
                }
            }
            for tileId in Set(outerEdges.keys) {
                let tile = tiles[tileId]!
                if
                    Set(tile.possibleEdges).intersection(Set(previousTile.possibleEdges)).count == 2,
                    Set(tile.possibleEdges).intersection(Set(puzzle[currentRow - 1][currentColumn].possibleEdges)).count == 2
                {
                    puzzle[currentRow].append(tile)
                    previousTile = puzzle[currentRow][0]
                    outerEdges.removeValue(forKey: tileId)
                    currentColumn = 0
                    currentRow += 1
                    break
                }
            }
        }
        // gathering the last row
        puzzle.append([])
        for tileId in Set(corners.keys) {
            let tile = tiles[tileId]!
            if Set(tile.possibleEdges).intersection(Set(previousTile.possibleEdges)).count == 2 {
                puzzle[currentRow].append(tile)
                previousTile = tile
                corners.removeValue(forKey: tileId)
                currentColumn += 1
                break
            }
        }
        while currentColumn != 11 {
            for tileId in Set(outerEdges.keys) {
                let tile = tiles[tileId]!
                if
                    Set(tile.possibleEdges).intersection(Set(previousTile.possibleEdges)).count == 2,
                    Set(tile.possibleEdges).intersection(Set(puzzle[currentRow - 1][currentColumn].possibleEdges)).count == 2
                {
                    currentColumn += 1
                    puzzle[currentRow].append(tile)
                    previousTile = tile
                    outerEdges.removeValue(forKey: tileId)
                    break
                }
            }
        }
        puzzle[currentRow].append(tiles[corners.keys.first!]!)
        corners.removeValue(forKey: corners.keys.first!)

        // check that all tiles were used

        assert(corners.count == 0)
        assert(outerEdges.count == 0)
        assert(innerTiles.count == 0)

        // flip and rotate the tiles to correct positions

        func flipAndRotateUntilMatches(left: inout Tile, right: inout Tile, bottom: Tile) {
            for (i, edges) in left.clockwiseFromTopPossibleEdges.indexed() {
                for (j, otherEdges) in right.clockwiseFromTopPossibleEdges.indexed() {
                    if Set(edges) == Set(otherEdges) {
                        // if all's good, i == 1, j == 3 (right edge matches to left edge)
                        // so let's rotate the tiles accordingly
                        left.rotate(times:((1 - i) + 4) % 4)
                        right.rotate(times:((3 - j) + 4) % 4)
                        // now flipping
                        let updatedEdges = left.clockwiseFromTopPossibleEdges[1]
                        let updatedOtherEdges = right.clockwiseFromTopPossibleEdges[3]
                        if updatedEdges[0] == updatedOtherEdges[1] {
                            right.vflip()
                        } else if updatedEdges[1] == updatedOtherEdges[0] {
                            left.vflip()
                        }
                        // make sure we can attach bottom tile
                        let bottomEdges = left.clockwiseFromTopPossibleEdges[2]
                        if Set(bottom.possibleEdges).intersection(Set(bottomEdges)).count == 0 {
                            left.vflip()
                            right.vflip()
                        }
                        return
                    }
                }
            }
            fatalError("failed to match two tiles")
        }
        func flipAndRotateRightTile(left: Tile, right: inout Tile) {
            let edges = left.clockwiseFromTopPossibleEdges[1]
            for (j, otherEdges) in right.clockwiseFromTopPossibleEdges.indexed() {
                if Set(edges) == Set(otherEdges) {
                    right.rotate(times:((3 - j) + 4) % 4)
                    if edges[0] == right.clockwiseFromTopPossibleEdges[3][1] {
                        right.vflip()
                    }
                    return
                }
            }
            fatalError("failed to match two tiles")
        }
        func flipAndRotateBottomTile(top: Tile, bottom: inout Tile) {
            let edges = top.clockwiseFromTopPossibleEdges[2]
            for (j, otherEdges) in bottom.clockwiseFromTopPossibleEdges.indexed() {
                if Set(edges) == Set(otherEdges) {
                    bottom.rotate(times:(4 - j) % 4)
                    if edges[0] == bottom.clockwiseFromTopPossibleEdges[0][1] {
                        bottom.hflip()
                    }
                    return
                }
            }
            fatalError("failed to match two tiles")
        }

        // let's take care of the first row
        var currentTile = puzzle[0][0]
        var rightTile = puzzle[0][1]
        flipAndRotateUntilMatches(left: &currentTile, right: &rightTile, bottom: puzzle[1][0])
        puzzle[0][0] = currentTile
        puzzle[0][1] = rightTile
        currentTile = rightTile
        rightTile = puzzle[0][2]
        for i in 2...11 {
            flipAndRotateRightTile(left: currentTile, right: &rightTile)
            puzzle[0][i] = rightTile
            currentTile = rightTile
            if i < 11 {
                rightTile = puzzle[0][i + 1]
            }
        }
        // now we can do the other rows
        currentRow = 1
        while currentRow != 12 {
            currentTile = puzzle[currentRow - 1][0]
            var bottomTile = puzzle[currentRow][0]
            flipAndRotateBottomTile(top: currentTile, bottom: &bottomTile)
            puzzle[currentRow][0] = bottomTile
            currentTile = bottomTile
            rightTile = puzzle[currentRow][1]
            for i in 1...11 {
                flipAndRotateRightTile(left: currentTile, right: &rightTile)
                puzzle[currentRow][i] = rightTile
                currentTile = rightTile
                if i < 11 {
                    rightTile = puzzle[currentRow][i + 1]
                }
            }
            currentRow += 1
        }

        // cool... now to creating the actual picture

        let finalSize = 12 * (10 - 2)
        var image = Array(repeating: Array(repeating: Character("."), count: finalSize), count: finalSize)
        var i = 0
        var j = 0
        for (rowNumber, row) in puzzle.indexed() {
            for (tileColumn, tile) in row.indexed() {
                i = 8 * rowNumber
                for xs in tile.insides {
                    j = 8 * tileColumn
                    for y in xs {
                        image[i][j] = y
                        j += 1
                    }
                    i += 1
                }
            }
        }

        let seaMonster = """
        ..................#.
        #....##....##....###
        .#..#..#..#..#..#...
        """.split(whereSeparator: \.isNewline).map { $0.map(id) }
        func countMonsters(image: [[Character]]) -> Int {
            var monsters = 0
            image.slidingWindows(ofCount: seaMonster.count).forEach { window in
                let slices = window.map { $0.slidingWindows(ofCount: seaMonster[0].count) }
                var i1 = slices[0].makeIterator()
                var i2 = slices[1].makeIterator()
                var i3 = slices[2].makeIterator()
                while let row1 = i1.next(), let row2 = i2.next(), let row3 = i3.next() {
                    var foundIt = true
                    loopOverWindow: for (i, row) in [row1, row2, row3].indexed() {
                        for (j, char) in row.indexed() {
                            if seaMonster[i][j - row.startIndex] == "#" && char != "#" {
                                foundIt = false
                                break loopOverWindow
                            }
                        }
                    }
                    monsters += foundIt ? 1 : 0
                }
            }
            return monsters
        }
        func findRotation(image: [[Character]]) -> Int {
            var image = image
            var monstersNumber = countMonsters(image: image)
            if monstersNumber != 0 { return monstersNumber }
            for i in (1...3) {
                image.rotate(times: i)
                monstersNumber = countMonsters(image: image)
                if monstersNumber != 0 { return monstersNumber }
            }
            image.hflip()
            monstersNumber = countMonsters(image: image)
            if monstersNumber != 0 { return monstersNumber }
            for i in (1...3) {
                image.rotate(times: i)
                monstersNumber = countMonsters(image: image)
                if monstersNumber != 0 { return monstersNumber }
            }
            fatalError("Couldn't find monsters")
        }
        let monstersNumber = findRotation(image: image)
        let seaMonsterPixels = seaMonster.map { $0.filter { $0 == "#" }.count }.sum()
        let totalPixels = image.map { $0.filter { $0 == "#" }.count }.sum()
        let part2 = totalPixels - monstersNumber * seaMonsterPixels
        print(part2)

        // ------- Test -------
        assert(part1 == 51214443014783, "WA")
        assert(part2 == 2065, "WA")
    }
}
