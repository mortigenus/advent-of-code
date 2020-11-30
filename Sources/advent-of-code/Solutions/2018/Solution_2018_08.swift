import Foundation

private func countMetadata(_ tree: inout [Int]) -> Int {
    guard tree.count != 0 else { return 0 }

    let childrenCount = tree.removeFirst()
    let metadataCount = tree.removeFirst()

    let childrenSum = (0..<childrenCount)
        .map({ _ in countMetadata(&tree) })
        .reduce(0, +)
    let metadataSum = (0..<metadataCount)
        .map({ _ in tree.removeFirst() })
        .reduce(0, +)

    return childrenSum + metadataSum
}

private struct Node {
    let children: [Node]?
    let metadata: [Int]?
}

private func build(_ tree: inout [Int]) -> Node? {
    guard tree.count != 0 else { return nil }

    let childrenCount = tree.removeFirst()
    let metadataCount = tree.removeFirst()

    let children = (0..<childrenCount).compactMap({ _ in build(&tree) })
    let metadata = (0..<metadataCount).map({ _ in tree.removeFirst() })

    return Node(children: children, metadata: metadata)
}

private func countMetadata(_ tree: Node) -> Int {
    guard let children = tree.children, children.count != 0 else {
        return tree.metadata?.reduce(0, +) ?? 0
    }

    return (tree.metadata ?? [])
        .map({ children.indices.contains($0 - 1) ? countMetadata(children[$0 - 1]) : 0 })
        .reduce(0, +)
}

struct Solution_2018_08: Solution {
    var input: Input
    func run() throws {
        let input = try self.input.get()
            .components(separatedBy: .whitespaces)
            .compactMap({ Int($0) })

        var tree = input
        let part1 = countMetadata(&tree)
        print(part1)

        tree = input
        let part2 = countMetadata(build(&tree)!)
        print(part2)

        // ------- Test -------

        assert(part1 == 47112, "WA")
        assert(part2 == 28237, "WA")
    }
}
