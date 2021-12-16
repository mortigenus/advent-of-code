//
//  Solution_2021_16.swift
//
//
//  Created by Ivan Chalov on 16.12.21.
//

import Foundation
import SortedCollections

struct Solution_2021_16: Solution {
    var input: Input

    func run() throws {
        let input = try self.input.get()
            .map { Int(String($0), radix: 16)! }
            .map { String(String($0, radix: 2).reversed()).padding(toLength: 4, withPad: "0", startingAt: 0).reversed() }
            .joined()
            .map { Int(String($0))! }

        // ------- Part 1 -------
        func parse1(_ packet: ArraySlice<Int>, p: inout Int) -> Int {
            var sum = 0
            let version = packet[p..<(p+3)].fromBinary()
            sum += version
            p += 3
            let typeId = packet[p..<(p+3)].fromBinary()
            p += 3
            if typeId != 4 {
                let lengthTypeId = packet[p]
                p += 1
                if lengthTypeId == 0 {
                    let totalLength = packet[p..<(p+15)].fromBinary()
                    p += 15
                    let curP = p
                    while p < curP + totalLength {
                        sum += parse1(packet, p: &p)
                    }
                } else {
                    let numberOfSubPackets = packet[p..<(p+11)].fromBinary()
                    p += 11
                    (1...numberOfSubPackets).forEach { _ in
                        sum += parse1(packet, p: &p)
                    }
                }
            } else {
                while packet[p] != 0 {
                    p += 5
                }
                p += 5
            }
            return sum
        }

        var p = 0
        let part1 = parse1(input[...], p: &p)
        print(part1)

        // ------- Part 2 -------
        func parse2(_ packet: ArraySlice<Int>, p: inout Int) -> Int {
            var result = 0
            let version = packet[p..<(p+3)].fromBinary()
            p += 3
            let typeId = packet[p..<(p+3)].fromBinary()
            p += 3
            if typeId != 4 {
                let lengthTypeId = packet[p]
                p += 1
                var subPacketResults = [Int]()
                if lengthTypeId == 0 {
                    let totalLength = packet[p..<(p+15)].fromBinary()
                    p += 15
                    let curP = p
                    while p < curP + totalLength {
                        subPacketResults.append(parse2(packet, p: &p))
                    }
                } else {
                    let numberOfSubPackets = packet[p..<(p+11)].fromBinary()
                    p += 11
                    (1...numberOfSubPackets).forEach { _ in
                        subPacketResults.append(parse2(packet, p: &p))
                    }
                }
                switch typeId {
                case 0:
                    result = subPacketResults.reduce(0, +)
                case 1:
                    result = subPacketResults.reduce(1, *)
                case 2:
                    result = subPacketResults.min()!
                case 3:
                    result = subPacketResults.max()!
                case 5:
                    result = subPacketResults[0] > subPacketResults[1] ? 1 : 0
                case 6:
                    result = subPacketResults[0] < subPacketResults[1] ? 1 : 0
                case 7:
                    result = subPacketResults[0] == subPacketResults[1] ? 1 : 0
                default:
                    fatalError("unknown typeId")
                }
            } else {
                var value = [Int]()
                while packet[p] != 0 {
                    value.append(contentsOf: packet[(p+1)..<(p+5)])
                    p += 5
                }
                value.append(contentsOf: packet[(p+1)..<(p+5)])
                p += 5
                result = value.fromBinary()
            }
            return result
        }
        p = 0
        let part2 = parse2(input[...], p: &p)
        print(part2)

        // ------- Test -------
        assert(part1 == 906, "WA")
        assert(part2 == 819324480368, "WA")
    }

}

private extension Collection where Element == Int {
    func fromBinary() -> Int {
        self.reversed().reduce((sum: 0, mult: 1)) { acc, x in (acc.sum + x * acc.mult, acc.mult * 2) }.sum
    }
}
