//
//  Solution_2021_18.swift
//
//
//  Created by Ivan Chalov on 18.12.21.
//

import Foundation

struct Solution_2021_18: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .split(whereSeparator: \.isNewline)
            .map(buildTree)

        // ------- Part 1 -------
        let part1 = input.scan { Node(left: $0, right: $1).reduced() }.magnitude
        print(part1)

        // ------- Part 2 -------
        let part2 = input
            .combinations(ofCount: 2)
            .map {
                max(
                    Node(left: $0[0], right: $0[1]).reduced().magnitude,
                    Node(left: $0[1], right: $0[0]).reduced().magnitude
                )
            }
            .max()!
        print(part2)

        // ------- Test -------
        assert(part1 == 4417, "WA")
        assert(part2 == 4796, "WA")
    }

}

private func buildTree<S: StringProtocol>(_ string: S) -> Node {
    guard string.starts(with: "[") else {
        return Node(element: Int(string)!)
    }

    let s = string.dropFirst().dropLast()
    var parensBalance = 0
    var separatorIndex = s.startIndex
    for i in s.indices {
        if s[i] == "[" { parensBalance += 1 }
        else if s[i] == "]" { parensBalance -= 1 }
        else if s[i] == ",", parensBalance == 0 { separatorIndex = i; break }
    }

    return Node(
        left: buildTree(s[..<separatorIndex]),
        right: buildTree(s[s.index(after: separatorIndex)...])
    )
}

private class Node: CustomStringConvertible {
    var element: Int?
    var left: Node?
    var right: Node?
    weak var parent: Node?

    init(element: Int? = nil, left: Node? = nil, right: Node? = nil, parent: Node? = nil) {
        self.element = element
        self.left = left
        self.right = right
        self.parent = parent
        self.left?.parent = self
        self.right?.parent = self
    }

    var description: String {
        if let element = element {
            return String(element)
        } else if let left = left, let right = right {
            return "[\(String(describing: left)),\(String(describing: right))]"
        }
        preconditionFailure("invalid tree")
    }

    func reduced() -> Node {
        let newNode = self.copy()

        func reduce1() -> Bool {
            return newNode.explode() ? true : newNode.split()
        }

        while reduce1() { }
        return newNode
    }

    private func explode(_ depth: Int = 0) -> Bool {
        guard element == nil else { return false }
        guard depth < 5 else { preconditionFailure("should never reach this depth") }

        if depth == 4 {
            var search: Node? = self
            var newSearch = search

            while (newSearch = search?.parent, newSearch).1?.left === search {
                search = newSearch
            }
            search = newSearch?.left
            while search?.right != nil {
                search = search?.right
            }

            if let search = search {
                search.element! += left!.element!
            }

            search = self
            newSearch = search

            while (newSearch = search?.parent, newSearch).1?.right === search {
                search = newSearch
            }
            search = newSearch?.right
            while search?.left != nil {
                search = search?.left
            }

            if let search = search {
                search.element! += right!.element!
            }

            left = nil
            right = nil
            element = 0

            return true
        }

        return left?.explode(depth + 1) == true
        ? true
        : right?.explode(depth + 1) == true
    }

    private func split() -> Bool {
        if let element = element, element > 9 {
            self.element = nil
            left = Node(element: element / 2, parent: self)
            right = Node(element: (element + 1) / 2, parent: self)
            return true
        } else {
            return left?.split() == true
            ? true
            : right?.split() == true
        }
    }

    var magnitude: Int {
        if let element = element {
            return element
        }

        if let left = left, let right = right {
            return 3 * left.magnitude + 2 * right.magnitude
        }

        preconditionFailure("invalid tree")
    }

    func copy() -> Node {
        Node(
            element: element,
            left: left?.copy(),
            right: right?.copy()
        )
    }
}
