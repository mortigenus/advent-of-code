import Foundation

private enum Track: String, Equatable {
    case straight = "|"
    case side = "-"
    case curveRight = "/"
    case curveLeft = "\\"
    case intersection = "+"

    case empty = " "

    init(_ string: String) {
        if let cartDirection = Cart.Direction(rawValue: string) {
            // we know that carts stand on straight lines only
            switch cartDirection {
            case .up, .down:
                self = .straight
            case .left, .right:
                self = .side
            }
        } else {
            self.init(rawValue: string)!
        }
    }
}

private struct Position: Equatable, Comparable, Hashable {
    var x: Int
    var y: Int

    static func < (lhs: Position, rhs: Position) -> Bool {
        return lhs.y == rhs.y ? lhs.x < rhs.x : lhs.y < rhs.y
    }
}

private struct Cart {
    enum Direction: String, CaseIterable {
        case up = "^"
        case right = ">"
        case down = "v"
        case left = "<"

        mutating func cw() {
            let directions = Direction.allCases
            self = directions[(directions.firstIndex(of: self)! + 1) % directions.count]
        }
        mutating func ccw() {
            let directions = Direction.allCases
            self = directions[(directions.firstIndex(of: self)! + directions.count - 1) % directions.count]
        }

    }

    enum IntersectionOrder: CaseIterable {
        case left
        case straight
        case right

        mutating func next() {
            let cases = IntersectionOrder.allCases
            self = cases[(cases.firstIndex(of: self)! + 1) % cases.count]
        }
    }

    var position: Position
    var direction: Direction
    var nextIntersection = IntersectionOrder.left
    var crashed: Bool = false

    mutating func intersection() {
        switch nextIntersection {
        case .straight:
            //no-op
            break
        case .left:
            direction.ccw()
        case .right:
            direction.cw()
        }
        nextIntersection.next()
    }

    mutating func corner(with track: Track) {
        if Set([.up, .down]).contains(direction) {
            track == .curveLeft
                ? direction.ccw()
                : direction.cw()
        } else {
            track == .curveLeft
                ? direction.cw()
                : direction.ccw()
        }
    }

    mutating func drive() {
        switch direction {
        case .up:
            position.y -= 1
        case .down:
            position.y += 1
        case .left:
            position.x -= 1
        case .right:
            position.x += 1
        }
    }

    init(position: Position, direction: Direction) {
        self.position = position
        self.direction = direction
    }

}

private func print(map: [[Track]], carts: [Cart]) {
    map.indices.forEach({ i in
        map[i].indices.forEach({ j in
            if let cart = carts.first(where: { $0.position == Position(x: j, y: i) }) {
                print(cart.direction.rawValue, terminator:"")
            } else {
                print(map[i][j].rawValue, terminator:"")
            }
        })
        print()
    })
}

struct Solution_2018_13: Solution {
    var input: Input
    func run() throws {
        //let input = """
        ///->-\\
        //|   |  /----\\
        //| /-+--+-\\  |
        //| | |  | v  |
        //\\-+-/  \\-+--/
        //\\------/
        //"""
        //.components(separatedBy: .newlines)
        let input = try self.input.get(trimmingWhitespace: false)
            .components(separatedBy: .newlines)

        let map = input.map({ $0.map({ Track(String($0)) }) })

        var carts = [Position: Cart]()
        for i in input.indices {
            for (j, elem) in input[i].enumerated() {
                if let direction = Cart.Direction(rawValue: String(elem)) {
                    let pos = Position(x: j, y: i)
                    carts[pos] = Cart(position: pos, direction: direction)
                }
            }
        }

        // returns first crash location if it happened
        func tick(_ map: [[Track]], _ carts: inout [Position: Cart]) -> Position? {

        //    print(map: map, carts: Array(carts.values))

            func move(_ cart: inout Cart) {
                cart.drive()
                let track = map[cart.position.y][cart.position.x]
                switch track {
                case .straight, .side:
                    //no-op
                    break
                case .curveLeft, .curveRight:
                    cart.corner(with: track)
                case .intersection:
                    cart.intersection()
                case .empty:
                    fatalError("Please don't leave the track!")
                }
            }

            let cartPositions = carts.keys.sorted()
            var crashedPosition: Position?
            for position in cartPositions {
                // we might have removed a cart on this tick already
                guard carts[position] != nil else { continue }

                move(&carts[position]!)
                let newPosition = carts[position]!.position
                if carts[newPosition] != nil {
                    carts[newPosition] = nil
                    carts[position] = nil
                    crashedPosition = newPosition
                } else {
                    carts[newPosition] = carts[position]
                    carts[position] = nil
                }
            }

            return crashedPosition
        }

        var crash: Position?
        while crash == nil {
            crash = tick(map, &carts)
        }
        let part1 = "\(crash!.x),\(crash!.y)"
        print(part1)

        while carts.count != 1 {
            _ = tick(map, &carts)
        }
        let lastCart = carts.first!.value
        let part2 = "\(lastCart.position.x),\(lastCart.position.y)"
        print(part2)

        // ------- Test -------

        assert(part1 == "26,99", "WA")
        assert(part2 == "62,48", "WA")
    }
}
