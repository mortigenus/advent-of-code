import Foundation

struct Solution_2019_05: Solution {
    var input: Input
    func run() throws {
        let values = try input.get()
            .split(separator: ",")
            .compactMap({ Int($0) })

        // ------- Part 1 -------

        var intcode = Intcode(program: values, input: 1)
        let part1 = intcode.run().last!
        print(part1)

        // ------- Part 2 -------

        intcode = Intcode(program: values, input: 5)
        let part2 = intcode.run().last!
        print(part2)

        // ------- Test -------

        assert(part1 == 6745903, "WA")
        assert(part2 == 9168267, "WA")
    }
}
