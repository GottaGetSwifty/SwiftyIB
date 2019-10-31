//
//  IBIdentifiersConverter.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/29/17.
//  Copyright © 2019 peejweej.inc. All rights reserved.
//

public struct IBIdentifiersConverter {
    
    public static func makeIdentifiersExtension(with name: String, and documentation: String, from strings: [String], addHeader: Bool = false) -> String? {
        guard !name.isEmpty else {
            return nil
        }
        let preparedCases = Set(strings).sorted()
        
        let result = "\(makeTypeStart(from: name, and: documentation, addHeader: addHeader))\(preparedCases.map({makeEntry(from: $0, type: name)}).reduce("", +))\(typeEnd)"
        return result
    }
    
    static func makeIdentifiersExtension(with name: String, and documentation: String, using identifierFinder: (() -> ([String])) ) -> String? {
        
        guard !name.isEmpty else {
            return nil
        }
       
        let results = identifierFinder()
        let resultEnum = makeIdentifiersExtension(with: name, and: documentation, from: results)
        return resultEnum
    }
    
    private static func makeEntry(from name: String, type: String) -> String {
        return "\n\tstatic var \(name): \(type) {\(type)(name: \"\(name)\")}"
    }

    private static func makeTypeStart(from name: String, and documentation: String, addHeader: Bool = false) -> String{
        return "\(addHeader ? makeHeader(for: name) : "")\n\n\(documentation)\nextension \(name) {"
    }
    
    private static let typeEnd = "\n}"
    
    private static func makeHeader(for name: String) -> String {
        return  """
                // \(name).swift
                //
                // Automatically Generated by SwiftyIB from the available IB files
                //
                // **DO NOT EDIT**
                // 
                // Any changes will be overwritten when next generated
                import SwiftyIB
                """
    }
}