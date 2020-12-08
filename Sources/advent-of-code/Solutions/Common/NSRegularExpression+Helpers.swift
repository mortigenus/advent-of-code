import Foundation
import Prelude

extension NSRegularExpression {
    public func captureGroupToInt(in string: String) -> (String) -> Int? {
        captureGroupToString(in: string) >=> Int.init
    }

    public func captureGroupToString(in string: String) -> (String) -> String? {
        return { captureGroupName in
            return self.firstMatch(in: string, range: NSMakeRange(0, string.count))
                .flatMap({ Range($0.range(withName: captureGroupName), in:string) })
                .flatMap({ String(string[$0]) })
        }
    }

    public func captureGroupToInts(in string: String) -> (String) -> [Int] {
        captureGroupToStrings(in: string) >>> mapOptional(Int.init)
    }

    public func captureGroupToStrings(in string: String) -> (String) -> [String] {
        return { captureGroupName in
            return self.matches(in: string, range: NSMakeRange(0, string.count))
                .compactMap({ Range($0.range(withName: captureGroupName), in:string) })
                .map({ String(string[$0]) })
        }
    }
}
