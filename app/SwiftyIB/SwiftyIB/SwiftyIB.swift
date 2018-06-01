//
//  SwiftyIB.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/31/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//

import Foundation
import AppKit

public class SwiftyIB {
    let containingURL: URL
    
    public init?(containingURL: URL) {
        guard containingURL.hasDirectoryPath else{
            return nil
        }
        self.containingURL = containingURL
    }
    
    public func findAllStorboardURLs() -> [URL] {
        let allURLs = FilesFinder.getAllStoryboardFiles(in: self.containingURL) ?? []
        return allURLs
    }
    
    public func buildStoryboards() -> [IBStoryboard] {
        let allStoryboards = findAllStorboardURLs().map(StoryboardParser.init).compactMap{ $0.parse() }
        
        return allStoryboards
    }
    
    public static func export(storboards: [IBStoryboard], to destination: URL, isAbsoluteURL: Bool) throws {
        try StoryboardExporter.exportIdentifiers(storyboards: storboards, to: destination, isAbsoluteURL: isAbsoluteURL)
        try StoryboardExporter.exportExtensions(storyboards: storboards, to: destination, isAbsoluteURL: isAbsoluteURL)
        try StoryboardExporter.exportIBTypes(storyboards: storboards, to: destination, isAbsoluteURL: isAbsoluteURL)
        try StoryboardExporter.exportIBTypeExtensions(storyboards: storboards, to: destination, isAbsoluteURL: isAbsoluteURL)
        
    }
}



