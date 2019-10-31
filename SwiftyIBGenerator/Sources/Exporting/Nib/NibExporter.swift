//
//  NibExporter.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 9/4/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//

import Foundation

class NibExporter: Exporter {
    private static let nibPath = "IBIdentifiers/Nibs/"
    
    private static let nibIDFileName = "\(nibPath)NibIdentifier.swift"
    private static let cellIDFileName = "\(nibPath)CellIdentifier.swift"
    
    private static let nibTypesFileName = "\(nibPath)IBNibTypes.swift"
    private static let nibExtensionsFileName = "\(nibPath)IBStructureNibExtensions.swift"
    private static let reuseExtensionsFileName = "\(nibPath)IBStructureReuseExtensions.swift"
    
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
    
    static func exportIBNibTypes(to destination: URL, isAbsoluteURL: Bool) throws {
        
//        let fileText = NibTypesAndExtensionsGenerator.makeNibTypesAndExtensions()
//        let result = exportFile(fileText: fileText, to: destination.appendingPathComponent(nibTypesFileName), isAbsoluteURL: isAbsoluteURL)
//        print("Exporting IBTypes result: \(result)")
        
    }
    
    static func exportNibExtensions(nibs: [IBNib], to destination: URL, isAbsoluteURL: Bool) throws {
        if let fileText = NibStructureExtensionsGenerator.makeNibExtensions(from: nibs) {
            let result = exportFile(fileText: fileText, to: destination.appendingPathComponent(nibExtensionsFileName), isAbsoluteURL: isAbsoluteURL)
            print("Exporting IBNib Extensions result: \(result)")
        }
    }
    
    static func exportReuseExtensions(nibs: [IBNib], to destination: URL, isAbsoluteURL: Bool) throws {
        if var fileText = NibStructureExtensionsGenerator.makeReuseExtensions(from: nibs) {
//            fileText += NibStructureExtensionsGenerator.makeNibReusableExtensions(from: nibs) ?? ""
            let result = exportFile(fileText: fileText, to: destination.appendingPathComponent(reuseExtensionsFileName), isAbsoluteURL: isAbsoluteURL)
            print("Exporting IBNib Extensions result: \(result)")
        }
    }
}
