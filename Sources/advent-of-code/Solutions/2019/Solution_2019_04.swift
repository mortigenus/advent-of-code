import Foundation

private extension Int {
    var digits: [Int] {
        return String(describing: self).compactMap { Int(String($0)) }
    }
}

struct Solution_2019_04: Solution {
    var input: Input
    func run() {
        let range = 402328...864247

        // ------- Part 1 -------

        func validPassword(pass:Int) -> Bool {
            let state = (
                increasing: true,
                containsDuplicate: false,
                previousValue: Int.min
            )
            let check = pass.digits.reduce(state) { acc, x in
                (
                    increasing: acc.increasing && x >= acc.previousValue,
                    containsDuplicate: acc.containsDuplicate || x == acc.previousValue,
                    previousValue: x
                )
            }
            return check.increasing && check.containsDuplicate
        }
        let part1 = range.filter(validPassword).count
        print(part1)

        // ------- Part 2 -------

        func validPassword2(pass:Int) -> Bool {
            let check = pass.digits.reduce(into: (
                increasing: true,
                duplicates: [Int](),
                currentDuplicateCount: 0,
                previousValue: Int.min
            )) { acc, x in
                acc.increasing = acc.increasing && x >= acc.previousValue
                if x == acc.previousValue {
                    acc.currentDuplicateCount += 1
                } else {
                    acc.duplicates.append(acc.currentDuplicateCount)
                    acc.currentDuplicateCount = 0
                }
                acc.previousValue = x
            }
            return check.increasing && (check.duplicates.contains(1) || check.currentDuplicateCount == 1)
        }
        let part2 = range.filter(validPassword2).count
        print(part2)

        // ------- Test -------

        assert(part1 == 454, "WA")
        assert(part2 == 288, "WA")
    }
}
