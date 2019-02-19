//: [Previous](@previous)

import Foundation

struct LogRecord {
    let id: Int
    let sumMinutesSlept: Int
    let ranges: [Range<Int>]
}

guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else {
    fatalError("Put input for the task into \"input.txt\" file")
}

let input = try String(contentsOfFile:path)

let log: [String] = input
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: .newlines)
    .sorted()


var parsedLog: [LogRecord] = []
var currentId: Int = 0
var currentFellAsleepTime: Int = 0
var currentWokeUpTime: Int = 0
var currentSleepSum: Int = 0
var currentSleepRanges: [Range<Int>] = []
log.forEach { record in
    let start = record.index(record.startIndex, offsetBy: 15)
    let end = record.index(record.startIndex, offsetBy: 17)
    let range = start..<end

    if (record.contains("Guard")) {
        //save previous guard
        if currentId != 0 {
            let newRecord = LogRecord(
                id: currentId,
                sumMinutesSlept: currentSleepSum,
                ranges: currentSleepRanges
            )
            parsedLog.append(newRecord)
            currentId = 0
            currentSleepSum = 0
            currentSleepRanges = []
            currentFellAsleepTime = 0
            currentWokeUpTime = 0
        }

        let idIndex = record.index(record.firstIndex(of: "#")!, offsetBy:1)
        let scanner = Scanner(string: String(record[idIndex...]))
        scanner.scanInt(&currentId)
    } else if (record.contains("falls")) {
        currentFellAsleepTime = Int(String(record[range]))!
    } else if (record.contains("wakes")) {
        currentWokeUpTime = Int(String(record[range]))!

        currentSleepRanges.append(currentFellAsleepTime..<currentWokeUpTime)
        currentSleepSum += (currentWokeUpTime - currentFellAsleepTime)
        currentFellAsleepTime = 0
    } else {
        fatalError("Wrong Input Format")
    }
}
//save the last guard
let newRecord = LogRecord(
    id: currentId,
    sumMinutesSlept: currentSleepSum,
    ranges: currentSleepRanges
)
parsedLog.append(newRecord)

let map = parsedLog.reduce(into: ([:] as [Int:(Int,NSCountedSet)]), { acc, val in
    if acc[val.id] == nil {
        acc[val.id] = (0, NSCountedSet())
    }
    acc[val.id]?.0 += val.sumMinutesSlept
    val.ranges.flatMap { range in
        range.map {
            acc[val.id]?.1.add($0)
        }
    }
})

var currentMaxId: Int?
map.forEach {
    if let id = currentMaxId {
        if map[id]!.0 < $0.value.0 {
            currentMaxId = $0.key
        }
    } else {
        currentMaxId = $0.key
    }
}

var bestCount: Int = 0
var bestMinute: Int?
let set = map[currentMaxId!]!.1
set.forEach {
    if set.count(for: $0) > bestCount {
        bestCount = set.count(for: $0)
        bestMinute = $0 as? Int
    }
}

let part1 = currentMaxId! * bestMinute!

bestCount = 0
bestMinute = nil
currentMaxId = nil
map.forEach { (k, v) in
    let set = v.1
    set.forEach { minute in
        if set.count(for: minute) > bestCount {
            bestCount = set.count(for: minute)
            bestMinute = minute as? Int
            currentMaxId = k
        }
    }
}

let part2 = bestMinute! * currentMaxId!


// ------- Test -------

assert(part1 == 12169, "WA")
assert(part2 == 16164, "WA")

//: [Next](@next)
