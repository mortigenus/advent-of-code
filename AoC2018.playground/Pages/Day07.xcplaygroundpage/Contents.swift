//: [Previous](@previous)

import Foundation

guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else {
    fatalError("Put input for the task into \"input.txt\" file")
}

let input = try String(contentsOfFile:path)
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: .newlines)
    .map {
        return (
            dependency: $0[$0.index($0.startIndex, offsetBy: 5)],
            step: $0[$0.index($0.startIndex, offsetBy: 36)]
        )
    }

let nextSteps: [Character:[Character]] = input
    .reduce(into: [Character:[Character]]()) { acc, instruction in
        acc[instruction.dependency, default: []].append(instruction.step)
    }

let requirements: [Character:[Character]] = input
    .reduce(into: [Character:[Character]]()) { acc, instruction in
        acc[instruction.step, default: []].append(instruction.dependency)
}

let roots = nextSteps.keys
    .filter { requirements[$0] == nil }
    .sorted()

func solvePart1() -> String {
    // NSOrderedSet might be better but it doesn't have a "swifty" interface :(
    var available = roots
    var result = [Character]()
    var done = Set<Character>()

    while available.count != 0 {
        let step = available.removeFirst()
        guard !done.contains(step) else { continue }

        result.append(step)
        done.insert(step)

        let newSteps = nextSteps[step, default:[]]
            .filter {
                !done.contains($0)
            }
            .filter {
                requirements[$0, default: []].allSatisfy { done.contains($0) }
        }

        available.append(contentsOf: newSteps)
        available.sort()
    }

    return result.reduce(into: String()) { $0.append($1) }
}

let part1 = solvePart1()

func solvePart2() -> Int {

    var workers = [Int](repeating: 0, count: 5)
    var scheduledTasks = [Character?](repeating: nil, count: 5)

    var available = roots
    var result = [Character]()
    var done = Set<Character>()

    var seconds = 0
    while !workers.allSatisfy({ $0 == 0 })
        || !scheduledTasks.allSatisfy({ $0 == nil })
        || available.count != 0 {

        workers.enumerated().forEach {
            if $0.element == 0 && scheduledTasks[$0.offset] != nil {

                let step = scheduledTasks[$0.offset]!

                result.append(step)
                done.insert(step)

                let newSteps = nextSteps[step, default:[]]
                    .filter {
                        !done.contains($0)
                    }
                    .filter {
                        requirements[$0, default: []].allSatisfy { done.contains($0) }
                    }

                available.append(contentsOf: newSteps)
                available.sort()

                scheduledTasks[$0.offset] = nil
            }
        }

        while let freeWorker = workers.firstIndex(of: 0), available.count != 0 {
            let step = available.removeFirst()
            guard !done.contains(step) else { continue }

            workers[freeWorker] = 60 + Int(step.asciiValue! - 64) // 'A'.asciiValue == 65
            scheduledTasks[freeWorker] = step
        }

        seconds += 1
        workers = workers.enumerated().map {
            (scheduledTasks[$0.offset] != nil ? $0.element - 1 : 0)
        }
    }
    // it's easier to subtract a second then check every time after finishing tasks and break earlier
    return seconds - 1
}

let part2 = solvePart2()

// ------- Test -------

assert(part1 == "BKCJMSDVGHQRXFYZOAULPIEWTN", "WA")
assert(part2 == 1040, "WA")

//: [Next](@next)
