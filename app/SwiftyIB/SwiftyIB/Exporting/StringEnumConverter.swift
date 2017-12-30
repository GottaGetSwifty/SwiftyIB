//
//  StringEnumConverter.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/29/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//

struct StringEnumConverter {
    
    static func makeEnum(with name: String, from strings: [String]) -> String? {
        guard !name.isEmpty else {
            return nil
        }
        let result = "\(makeEnumStart(from: name))\(strings.map(makeCase).reduce("", +))\(enumEnd)"
        return result
    }
    
    private static func makeCase(from name: String) -> String {
        return "\n\tcase \(name)"
    }

    private static func makeEnumStart(from name: String) -> String{
        return "enum \(name): String {"
    }
    
    private static let enumEnd = "\n}"
}
