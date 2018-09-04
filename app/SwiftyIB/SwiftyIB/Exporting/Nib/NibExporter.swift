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
    
    
//    static let sceneExtensionsFileName = "IBIdentifiers/SceneExtensions.swift"
//    static func exportExtensions(storyboards: [IBStoryboard], to destination: URL, isAbsoluteURL: Bool) throws { 
//        if let sceneExtensions = StoryboardStructureExtensionGenerator.makeScenesStructExtensions(from: storyboards) {
//            let result = exportFile(fileText: sceneExtensions, to: destination.appendingPathComponent(sceneExtensionsFileName), isAbsoluteURL: isAbsoluteURL)
//            print("Exporting Scene extensions result: \(result)")
//        }
//    }
//    
//    static let ibTypesFileName = "IBIdentifiers/IBTypes.swift"
//    static func exportIBTypes(storyboards: [IBStoryboard], to destination: URL, isAbsoluteURL: Bool) throws { 
//        let ibTypes = StoryboardTypesGenerator.makeIBTypes() 
//        let result = exportFile(fileText: ibTypes, to: destination.appendingPathComponent(ibTypesFileName), isAbsoluteURL: isAbsoluteURL)
//        print("Exporting IBTypes result: \(result)")
//        
//    }
//    
//    static let ibTypeExtensionsFileName = "IBIdentifiers/IBTypeExtensions.swift"
//    static func exportIBTypeExtensions(storyboards: [IBStoryboard], to destination: URL, isAbsoluteURL: Bool) throws { 
//        let ibTypeExtensions = StoryboardExtensionsGenerator.makeIBTypeExtensions()
//        let result = exportFile(fileText: ibTypeExtensions, to: destination.appendingPathComponent(ibTypeExtensionsFileName), isAbsoluteURL: isAbsoluteURL)
//        print("Exporting IBType Extensions result: \(result)")
//        
//    }
    
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
