//
//  StringExporter.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 1/1/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//
import Foundation

public class StoryboardExporter: Exporter {
    
    private static let storyboardPath = "IBIdentifiers/Storyboard/"
    
    private static let storyboardIDFileName = "\(storyboardPath)StoryboardIdentifier.swift"
    private static let sceneseIDFileName = "\(storyboardPath)ScenesIdentifier.swift"
    private static let segueIDFileName = "\(storyboardPath)SegueIdentifier.swift"
    
    private static let sceneExtensionsFileName = "\(storyboardPath)SceneExtensions.swift"
    private static let ibTypesFileName = "\(storyboardPath)IBTypes.swift"
    private static let ibTypeExtensionsFileName = "\(storyboardPath)IBTypeExtensions.swift"
    
    public static func exportIdentifiers(storyboards: [IBStoryboard], to destination: URL, isAbsoluteURL: Bool) throws {
        
        if let storyboardEnum = StoryboardEnumsGenerator.makeStoryboardNameEnum(from: storyboards) {
            let result = exportFile(fileText: storyboardEnum, to: destination.appendingPathComponent(storyboardIDFileName), isAbsoluteURL: isAbsoluteURL)
            print("Exporting storyboard enum result: \(result)")
        }
        else {
            print("Did not find any storyboard identifiers")
        }
        if let scenesEnum = StoryboardEnumsGenerator.makeSceneNameEnum(from: storyboards) {
            let result = exportFile(fileText: scenesEnum, to: destination.appendingPathComponent(sceneseIDFileName), isAbsoluteURL: isAbsoluteURL)
            print("Exporting scene enum result: \(result)")
        }
        else {
            print("Did not find any scene identifiers")
        }
        if let seguesEnum = StoryboardEnumsGenerator.makeSegueNameEnum(from: storyboards) {
            let result = exportFile(fileText: seguesEnum, to: destination.appendingPathComponent(segueIDFileName), isAbsoluteURL: isAbsoluteURL)
            print("Exporting segues enum result: \(result)")
        }
        else {
            print("Did not find any segue identifiers")
        }
    }
    
    static func exportExtensions(storyboards: [IBStoryboard], to destination: URL, isAbsoluteURL: Bool) throws { 
        if let sceneExtensions = StoryboardStructureExtensionGenerator.makeScenesStructExtensions(from: storyboards) {
            let result = exportFile(fileText: sceneExtensions, to: destination.appendingPathComponent(sceneExtensionsFileName), isAbsoluteURL: isAbsoluteURL)
            print("Exporting Scene extensions result: \(result)")
        }
    }
    
//    static func exportIBTypes(storyboards: [IBStoryboard], to destination: URL, isAbsoluteURL: Bool) throws {
//        let ibTypes = StoryboardTypesGenerator.makeIBTypes()
//        let result = exportFile(fileText: ibTypes, to: destination.appendingPathComponent(ibTypesFileName), isAbsoluteURL: isAbsoluteURL)
//        print("Exporting IBTypes result: \(result)")
        
//    }
    
//    static func exportIBTypeExtensions(storyboards: [IBStoryboard], to destination: URL, isAbsoluteURL: Bool) throws { 
//        let ibTypeExtensions = StoryboardExtensionsGenerator.makeIBTypeExtensions()
//        let result = exportFile(fileText: ibTypeExtensions, to: destination.appendingPathComponent(ibTypeExtensionsFileName), isAbsoluteURL: isAbsoluteURL)
//        print("Exporting IBType Extensions result: \(result)")
//        
//    }
}
