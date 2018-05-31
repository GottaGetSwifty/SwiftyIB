//
//  StringExporter.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 1/1/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//
import Foundation

class StoryboardExporter {
    
    static let storyboardIDFileName = "IBIdentifiers/StoryboardIdentifier.swift"
    static let sceneseIDFileName = "IBIdentifiers/ScenesIdentifier.swift"
    static let segueIDFileName = "IBIdentifiers/SegueIdentifier.swift"
    
    static func exportIdentifiers(storyboards: [IBStoryboard], to destination: URL, isAbsoluteURL: Bool) throws {
        
        if let storyboardEnum = StoryboardConverter.makeStoryboardNameEnum(from: storyboards) {
            let result = exportFile(fileText: storyboardEnum, to: destination.appendingPathComponent(storyboardIDFileName), isAbsoluteURL: isAbsoluteURL)
            print("Exporting storyboard enum result: \(result)")
        }
        else {
            print("Did not find any storyboard identifiers")
        }
        if let scenesEnum = StoryboardConverter.makeSceneNameEnum(from: storyboards) {
            let result = exportFile(fileText: scenesEnum, to: destination.appendingPathComponent(sceneseIDFileName), isAbsoluteURL: isAbsoluteURL)
            print("Exporting scene enum result: \(result)")
        }
        else {
            print("Did not find any scene identifiers")
        }
        if let seguesEnum = StoryboardConverter.makeSegueNameEnum(from: storyboards) {
            let result = exportFile(fileText: seguesEnum, to: destination.appendingPathComponent(segueIDFileName), isAbsoluteURL: isAbsoluteURL)
            print("Exporting segues enum result: \(result)")
        }
        else {
            print("Did not find any segue identifiers")
        }
    }
    
    
    static let sceneExtensionsFileName = "IBIdentifiers/SceneExtensions.swift"
    static func exportExtensions(storyboards: [IBStoryboard], to destination: URL, isAbsoluteURL: Bool) throws { 
        if let sceneExtensions = StoryboardConverter.makeScenesStructExtensions(from: storyboards) {
            let result = exportFile(fileText: sceneExtensions, to: destination.appendingPathComponent(sceneExtensionsFileName), isAbsoluteURL: isAbsoluteURL)
            print("Exporting Scene extensions result: \(result)")
        }
    }
    
    static let ibTypesFileName = "IBIdentifiers/IBTypes.swift"
    static func exportIBTypes(storyboards: [IBStoryboard], to destination: URL, isAbsoluteURL: Bool) throws { 
        let ibTypes = StoryboardConverter.makeIBTypes() 
        let result = exportFile(fileText: ibTypes, to: destination.appendingPathComponent(ibTypesFileName), isAbsoluteURL: isAbsoluteURL)
        print("Exporting IBTypes result: \(result)")
        
    }
    
    static let ibTypeExtensionsFileName = "IBIdentifiers/IBTypeExtensions.swift"
    static func exportIBTypeExtensions(storyboards: [IBStoryboard], to destination: URL, isAbsoluteURL: Bool) throws { 
        let ibTypeExtensions = StoryboardConverter.makeIBTypeExtensions()
        let result = exportFile(fileText: ibTypeExtensions, to: destination.appendingPathComponent(ibTypeExtensionsFileName), isAbsoluteURL: isAbsoluteURL)
        print("Exporting IBTypes result: \(result)")
        
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
