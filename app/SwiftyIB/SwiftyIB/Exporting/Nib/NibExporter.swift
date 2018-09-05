//
//  NibExporter.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 9/4/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//

import Foundation

class NibExporter {
    static let nibIDFileName = "IBIdentifiers/NibIdentifier.swift"
    static let cellIDFileName = "IBIdentifiers/CellIdentifier.swift"
    
    public static func exportIdentifiers(nibs: [IBNib], to destination: URL, isAbsoluteURL: Bool) throws {
        if let nibIDEnum = NibEnumsGenerator.makeNibNameEnum(from: nibs) {
            let result = exportFile(fileText: nibIDEnum, to: destination.appendingPathComponent(nibIDFileName), isAbsoluteURL: isAbsoluteURL)
            print("Exporting nibs enum result: \(result)")
        }
        else {
            print("Did not find any nib file identifiers")
        }
        if let cellIDEnum = NibEnumsGenerator.makeCellIdentifierEnum(from: nibs) {
            let result = exportFile(fileText: cellIDEnum, to: destination.appendingPathComponent(cellIDFileName), isAbsoluteURL: isAbsoluteURL)
            print("Exporting nibs enum result: \(result)")
        }
        else {
            print("Did not find any cell identifiers")
        }
    }
    
    
    static let nibTypesFileName = "IBIdentifiers/IBNibTypes.swift"
    static func exportIBNibTypes(to destination: URL, isAbsoluteURL: Bool) throws {
        
        let fileText = NibTypesAndExtensionsGenerator.makeNibTypesAndExtensions()
        let result = exportFile(fileText: fileText, to: destination.appendingPathComponent(nibTypesFileName), isAbsoluteURL: isAbsoluteURL)
        print("Exporting IBTypes result: \(result)")
        
    }
    
    static let nibExtensionsFileName = "IBIdentifiers/IBStructureNibExtensions.swift"
    static func exportNibExtensions(nibs: [IBNib], to destination: URL, isAbsoluteURL: Bool) throws {
        if let fileText = NibStructureExtensionsGenerator.makeNibExtensions(from: nibs) {
            let result = exportFile(fileText: fileText, to: destination.appendingPathComponent(nibExtensionsFileName), isAbsoluteURL: isAbsoluteURL)
            print("Exporting IBNib Extensions result: \(result)")
        }
    }
    
    static let reuseExtensionsFileName = "IBIdentifiers/IBStructureReuseExtensions.swift"
    static func exportReuseExtensions(nibs: [IBNib], to destination: URL, isAbsoluteURL: Bool) throws {
        if var fileText = NibStructureExtensionsGenerator.makeReuseExtensions(from: nibs) {
            fileText += NibStructureExtensionsGenerator.makeNibReusableExtensions(from: nibs) ?? ""
            let result = exportFile(fileText: fileText, to: destination.appendingPathComponent(reuseExtensionsFileName), isAbsoluteURL: isAbsoluteURL)
            print("Exporting IBNib Extensions result: \(result)")
        }
    }
    
    private static func exportFile(fileText: String, to url: URL, isAbsoluteURL: Bool) -> Bool {
        let filePath = isAbsoluteURL ? url.deletingLastPathComponent().absoluteString : url.deletingLastPathComponent().relativeString 
        do {
            if !FileManager.default.fileExists(atPath: filePath) {
                try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            }
            try fileText.write(to: url, atomically: true, encoding: .utf8)
            return true
        }
        catch let e {
            print(e.localizedDescription)
            return false
        }
    }
}
