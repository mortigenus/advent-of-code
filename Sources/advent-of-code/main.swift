import Foundation
import ArgumentParser

struct AdventOfCode: ParsableCommand {
    @Argument(
        help: "For which day to run a solution",
        completion: .list((1...31).map(String.init)))
    var day: Int

    @Argument(
        help: "From which year to run a solution",
        completion: .list(["2020", "2019", "2018"]))
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
        runFromXcode()
    } else {
        AdventOfCode.main()
    }
}

func hardcodedRun() {
    AdventOfCode.main(["17"])
}

func runFromXcode() {
    let day: String?
    let year: String?
    print("Day: ", terminator: "")
    day = readLine()
    print("Year [\(currentYear())]: ", terminator: "")
    year = readLine()
    let input = [day, year].compactMap { $0 }.filter { !$0.isEmpty }
    AdventOfCode.main(input)
}

func isRunningFromXcode() -> Bool {
    ProcessInfo.processInfo.environment["OS_ACTIVITY_DT_MODE"] == "YES"
}

func currentYear() -> Int {
    Calendar.current.component(.year, from: Date())
}
