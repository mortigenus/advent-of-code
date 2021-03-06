import Foundation

private struct LogRecord {
    let id: Int
    var sumMinutesSlept: Int = 0
    var ranges: [Range<Int>] = []

    init(id: Int) {
        self.id = id
    }
}

struct Solution_2018_04: Solution {
    var input: Input
    func run() throws {
        let log = try input.get()
            .components(separatedBy: .newlines)
            .sorted()

        var parsedLog = [LogRecord]()
        var currentRecord: LogRecord?
        var currentFellAsleepTime: Int?
        log.forEach { record in
            if (record.contains("Guard")) {
                if let currentRecord = currentRecord {
                    parsedLog.append(currentRecord)
                }

                currentRecord = record.firstIndex(of: "#")
                    .flatMap { record.index(after: $0) }
                    .flatMap { Scanner(string: String(record[$0...])) }
                    .flatMap { scanner in
                        var id: Int = 0
                        scanner.scanInt(&id)
                        return id
                    }
                    .flatMap { LogRecord(id: $0) }
            } else {
                let minutesStart = record.index(record.startIndex, offsetBy: 15)
                let minutesEnd = record.index(record.startIndex, offsetBy: 17)
                let minutesRange = minutesStart..<minutesEnd


                if (record.contains("falls")) {
                    currentFellAsleepTime = Int(String(record[minutesRange]))
                } else if (record.contains("wakes")) {
                    if let wokeUpTime = Int(String(record[minutesRange])),
                        let fellAsleepTime = currentFellAsleepTime {
                        currentRecord?.sumMinutesSlept += (wokeUpTime - fellAsleepTime)
                        currentRecord?.ranges.append(fellAsleepTime..<wokeUpTime)
                    }
                } else {
                    fatalError("Wrong Input Format")
                }
            }
        }
        //append the last guard
        currentRecord.flatMap { parsedLog.append($0) }

        struct AccumulatedLog: Hashable {
            var sumMinutesSlept = 0
            var countedMinutes = NSCountedSet()
        }

        let map = parsedLog.reduce(into: [Int:AccumulatedLog]()) { acc, val in
            if acc[val.id] == nil {
                acc[val.id] = AccumulatedLog()
            }
            acc[val.id]!.sumMinutesSlept += val.sumMinutesSlept
            val.ranges.forEach { range in
                range.forEach {
                    acc[val.id]!.countedMinutes.add($0)
                }
            }
        }

        // who slept the most? -> at what minute they slept the most? ->
        // -> multiply id and minute
        let part1 = map
            .max(by: { $0.value.sumMinutesSlept < $1.value.sumMinutesSlept })
            .flatMap { kv_pair -> (Int, Int) in
                let (id, log) = kv_pair
                return (
                    id,
                    log.countedMinutes.max(by: {
                        log.countedMinutes.count(for: $0) < log.countedMinutes.count(for: $1)
                    }) as! Int
                )
            }
            .flatMap {
                $0.0 * $0.1
            }
        print(part1!)

        // who slept the most times on the same minute?
        var bestCount = 0
        var currentBestId: Int? = nil
        var bestMinute: Int? = nil
        map.forEach { (k, v) in
            let set = v.countedMinutes
            set.forEach { minute in
                if set.count(for: minute) > bestCount {
                    bestCount = set.count(for: minute)
                    bestMinute = minute as? Int
                    currentBestId = k
                }
            }
        }

        let part2 = bestMinute! * currentBestId!
        print(part2)

        // ------- Test -------

        assert(part1 == 12169, "WA")
        assert(part2 == 16164, "WA")
    }
}
