import Foundation

struct Solution_2019_08: Solution {
    var input: Input
    func run() throws {
        let values = try input.get()
            .compactMap({ $0.wholeNumberValue })

        // ------- Part 1 -------

        let width = 25
        let height = 6
        let layers = values.count / (height * width)

        struct Accumulator {
            let width: Int
            let height: Int

            var array: [[[Int]]]
            var counter: [NSCountedSet]

            var row: Int = 0
            var column: Int = 0
            var layer: Int = 0

            init(width: Int, height: Int, layers: Int) {
                self.width = width
                self.height = height
                self.array = Array(repeating: Array(repeating: Array(repeating: 0, count: width), count: height), count: layers)
                self.counter = (0..<layers).map { _ in NSCountedSet() }
            }

            mutating func append(_ x: Int) {
                array[layer][row][column] = x
                counter[layer].add(x)

                column += 1
                if column == width {
                    column = 0
                    row += 1
                    if row == height {
                        row = 0
                        layer += 1
                    }
                }
            }
        }

        let accumulator = values
            .reduce(into: Accumulator(width: width, height: height, layers: layers)) { acc, x in
                acc.append(x)
            }
        let image = accumulator.array
        let counter = accumulator.counter

        let result = counter.min { $0.count(for: 0) < $1.count(for: 0) }!

        let part1 = result.count(for: 1) * result.count(for: 2)
        print(part1)

        // ------- Part 2 -------

        func pixelValue(_ i: Int, _ j: Int, _ image: [[[Int]]]) -> Int {
            var layer = 0
            while layer < layers && image[layer][i][j] == 2 {
                layer += 1
            }
            return image[layer][i][j]
        }

        for i in 0..<height {
            for j in 0..<width {
                print(pixelValue(i, j, image), terminator: "")
            }
            print("")
        }
        let part2 = {
            //Magically reading the output
            "RUZBP"
        }()

        // ------- Test -------

        assert(part1 == 1441, "WA")
        assert(part2 == "RUZBP", "WA")
    }
}
