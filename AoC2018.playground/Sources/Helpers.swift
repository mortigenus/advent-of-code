import Foundation

extension NSRegularExpression {
    public func captureGroupToInt(in string: String) -> (String) -> Int? {
        return { captureGroupName in
            return self.captureGroupToString(in: string)(captureGroupName)
                .flatMap({ Int($0) })
        }
    }
    public func captureGroupToString(in string: String) -> (String) -> String? {
        return { captureGroupName in
            return self.firstMatch(in: string, range: NSMakeRange(0, string.count))
                .flatMap({ Range($0.range(withName: captureGroupName), in:string) })
                .flatMap({ String(string[$0]) })
        }
    }
}

public func readInput() throws -> String {
    let input: String
    if CommandLine.arguments.count == 4 && CommandLine.arguments[2] == "cli" {
        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        var url = URL(fileURLWithPath: CommandLine.arguments[3], relativeTo: currentDirectoryURL)
        url.appendPathComponent("Resources/input.txt")

        input = try String(contentsOf: url)
    } else {
        guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else {
            fatalError("Put input for the task into \"input.txt\" file")
        }

        input = try String(contentsOfFile:path)
    }

    return input.trimmingCharacters(in: .whitespacesAndNewlines)
}
