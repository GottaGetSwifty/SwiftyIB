//
//  StringExporter.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 1/1/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//
import Foundation

class StoryboardExporter {
    
    static let storyboardIDFileName = "IBIdentifiers/StorboardIdentifier.swift"
    static let sceneseIDFileName = "IBIdentifiers/ScenesIdentifier.swift"
    static let segueIDFileName = "IBIdentifiers/SegueIdentifier.swift"
    static func export(storboards: [IBStoryboard], to destination: URL, absoluteURL: Bool) throws {
        
        if let storyboardEnum = StoryboardConverter.makeStoryboardNameEnum(from: storboards) {
            let result = export(fileText: storyboardEnum, to: destination.appendingPathComponent(storyboardIDFileName), absoluteURL: absoluteURL)
            print("Exporting storboard enum result: \(result)")
        }
        else {
            print("Did not find any storyboard identifiers")
        }
        if let scenesEnum = StoryboardConverter.makeSceneNameEnum(from: storboards) {
            let result = export(fileText: scenesEnum, to: destination.appendingPathComponent(sceneseIDFileName), absoluteURL: absoluteURL)
            print("Exporting scene enum result: \(result)")
        }
        else {
            print("Did not find any scene identifiers")
        }
        if let seguesEnum = StoryboardConverter.makeSegueNameEnum(from: storboards) {
            let result = export(fileText: seguesEnum, to: destination.appendingPathComponent(segueIDFileName), absoluteURL: absoluteURL)
            print("Exporting segues enum result: \(result)")
        }
        else {
            print("Did not find any segue identifiers")
        }
    }
    
    static func export(fileText: String, to url: URL, absoluteURL: Bool) -> Bool {
        let filePath = absoluteURL ? url.deletingLastPathComponent().absoluteString : url.deletingLastPathComponent().relativeString 
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
