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
