//
//  File.swift
//  
//
//  Created by Ivan Chalov on 04.12.20.
//

import Foundation

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

//guard let byr = passport["byr"], byr.matches("^(19[2-9]\\d|200[0-2])$") else {
//    return false
//}
//guard let iyr = passport["iyr"], iyr.matches("^(201\\d|2020)$") else {
//    return false
//}
//guard let eyr = passport["eyr"], eyr.matches("^(202\\d|2030)$") else {
//    return false
//}
//guard let hgt = passport["hgt"], hgt.matches("^((1[5-8]\\d|19[0-3])cm|(59|6\\d|7[0-6])in)$") else {
//    return false
//}
