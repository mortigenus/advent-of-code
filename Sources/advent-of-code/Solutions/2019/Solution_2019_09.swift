import Foundation

struct Solution_2019_09: Solution {
    var input: Input
    func run() throws {
        let values = try input.get()
            .split(separator: ",")
            .compactMap({ Int($0) })

        // ------- Part 1 -------

        let intcode1 = Intcode(program: values, input: 1)
        let part1 = intcode1.run().last!
        print(part1)

        // ------- Part 2 -------

        let intcode2 = Intcode(program: values, input: 2)
        let part2 = intcode2.run().last!
        print(part2)

        // ------- Test -------

        assert(part1 == 2171728567, "WA")
        assert(part2 == 49815, "WA")
    }
}
