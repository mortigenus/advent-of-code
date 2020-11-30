import Foundation
import ArgumentParser

struct AdventOfCode: ParsableCommand {
    @Argument(help: "For which day to run a solution")
    var day: Int

    @Argument(
        help: "From which year to run a solution",
        completion: .list(["2020, 2019, 2018"]))
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

if isRunningFromXcode() {
    print("Day: ", terminator: "")
    let day = readLine()
    print("Year [\(currentYear())]: ", terminator: "")
    let year = readLine()
    let input = [day, year].compactMap { $0 }.filter { !$0.isEmpty }
    AdventOfCode.main(input)
} else {
    AdventOfCode.main()
}

func isRunningFromXcode() -> Bool {
    ProcessInfo.processInfo.environment["OS_ACTIVITY_DT_MODE"] == "YES"
}

func currentYear() -> Int {
    Calendar.current.component(.year, from: Date())
}
