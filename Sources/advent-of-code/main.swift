import Foundation
import ArgumentParser

struct AdventOfCode: ParsableCommand {
    @Argument(
        help: "For which day to run a solution",
        completion: .list((1...31).map(String.init)))
    var day: Int = currentDay()

    @Argument(
        help: "From which year to run a solution",
        completion: .list(["2021", "2020", "2019", "2018"]))
    var year: Int = currentYear()

    mutating func run() throws {
        try SolutionRegistry
            .solution(
                year: year,
                day: day,
                input: Input(year: year, day: day))
            .run()
    }
}

run()

func run() {
//    hardcodedRun()
//    return
//
    if isRunningFromXcode() {
        hardcodedRun(today: true)
//        runFromXcode()
    } else {
        AdventOfCode.main()
    }
}

func hardcodedRun(today: Bool) {
    if today {
        AdventOfCode.main(["\(currentDay())", "\(currentYear())"])
    } else {
        AdventOfCode.main(["25"])
    }
}

func runFromXcode() {
    let day: String?
    let year: String?
    print("Day [\(currentDay())]: ", terminator: "")
    day = readLine()
    print("Year [\(currentYear())]: ", terminator: "")
    year = readLine()
    let input = [day, year].compactMap { $0 }.filter { !$0.isEmpty }
    AdventOfCode.main(input)
}

func isRunningFromXcode() -> Bool {
    ProcessInfo.processInfo.environment["OS_ACTIVITY_DT_MODE"] == "YES"
}

func currentDay() -> Int {
    Calendar.current.component(.day, from: Date())
}

func currentYear() -> Int {
    Calendar.current.component(.year, from: Date())
}
