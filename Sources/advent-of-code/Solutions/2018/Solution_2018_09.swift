import Foundation

private class Node {
    let value: Int
    var prev: Node!
    var next: Node!

    init(value: Int, prev: Node? = nil, next: Node? = nil) {
        self.value = value
        self.prev = prev ?? self
        self.next = next ?? self
    }

    func right(_ amount: Int) -> Node {
        return (0..<amount).reduce(self, { acc, _ in acc.next })
    }

    func left(_ amount: Int) -> Node {
        return (0..<amount).reduce(self, { acc, _ in acc.prev })
    }
}

struct Solution_2018_09: Solution {
    var input: Input
    func run() {
        let players = 418
        let marbles = 70769

        func solve(players: Int, marbles: Int) -> Int {
            let root = Node(value: 0)

            var currentPlayer = 0
            var points = [Int](repeating: 0, count: players)
            var currentMarble = root
            for marble in 1...marbles {

                if marble.isMultiple(of: 23) {
                    let marbleToRemove = currentMarble.left(7)
                    marbleToRemove.prev.next = marbleToRemove.next
                    marbleToRemove.next.prev = marbleToRemove.prev

                    points[currentPlayer] += (marble + marbleToRemove.value)

                    currentMarble = marbleToRemove.right(1)
                } else {
                    let insertAfter = currentMarble.right(1)
                    let insertBefore = currentMarble.right(2)

                    let newMarble = Node(value: marble, prev: insertAfter, next: insertBefore)
                    insertAfter.next = newMarble
                    insertBefore.prev = newMarble

                    currentMarble = newMarble
                }

                currentPlayer = (currentPlayer + 1) % players
            }

            return points.max()!
        }

        let part1 = solve(players: players, marbles: marbles)
        print(part1)
        let part2 = solve(players: players, marbles: marbles * 100)
        print(part2)

        // ------- Test -------

        assert(part1 == 402398, "WA")
        assert(part2 == 3426843186, "WA")
    }
}
