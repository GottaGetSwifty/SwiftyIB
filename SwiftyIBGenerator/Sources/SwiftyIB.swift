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
    
    enum Error: LocalizedError {
        case noResult(text: String)
        
        var localizedDescription: String {
            switch self {
            case .noResult(let text):
                return "No result found for \(text)"
            }
        }
    }
    
    let searchURL: URL
    
    public init?(searchURL: URL) {
        guard searchURL.hasDirectoryPath else{
            return nil
        }
        self.searchURL = searchURL
    }
    
    private func findAllStorboardURLs() -> [URL] {
        let allURLs = FilesFinder.getAllStoryboardFiles(in: self.searchURL) ?? []
        return allURLs
    }
    
    private func findAllNibs() -> [URL] {
        let allURLs = FilesFinder.getAllNibFiles(in: self.searchURL) ?? []
        return allURLs
    }
    
    private func findAllAssetFolders() -> [URL] {
        let allURLs = FilesFinder.getAllAssetFolders(in: self.searchURL) ?? []
        return allURLs
    }
    
    public func buildStoryboards() -> [IBStoryboard] {
        let allStoryboards = findAllStorboardURLs().map(StoryboardParser.init).compactMap{ $0.parse() }
        return allStoryboards
    }
    
    public func buildNibs() -> [IBNib] {
        let allNibs = findAllNibs().map(NibParser.init).compactMap { $0.parse() }
        return allNibs
    }
    
    public func buildAssetFolders() -> AssetsContainer {
        let result: AssetsContainer = findAllAssetFolders()
            .map{AssetCatalogueParser(assetsURL: $0).parse()}
            .reduce(AssetsContainer.emptyValue, +)
        return result
    }
    
    public static func export(storboards: [IBStoryboard], to destination: URL, isAbsoluteURL: Bool) throws {
        try StoryboardExporter.exportIdentifiers(storyboards: storboards, to: destination, isAbsoluteURL: isAbsoluteURL)
        try StoryboardExporter.exportExtensions(storyboards: storboards, to: destination, isAbsoluteURL: isAbsoluteURL)
    }
    
    public static func export(nibs: [IBNib], to destination: URL, isAbsoluteURL: Bool) throws {
        try NibExporter.exportIBNibTypes(to: destination, isAbsoluteURL: isAbsoluteURL)
        try NibExporter.exportIdentifiers(nibs: nibs, to: destination, isAbsoluteURL: isAbsoluteURL)
        try NibExporter.exportNibExtensions(nibs: nibs, to: destination, isAbsoluteURL: isAbsoluteURL)
        try NibExporter.exportReuseExtensions(nibs: nibs, to: destination, isAbsoluteURL: isAbsoluteURL)
    }
    
    public static func export(assets: AssetsContainer, to destination: URL, isAbsoluteURL: Bool) throws {
        if assets.isEmpty {
            throw SwiftyIB.Error.noResult(text: "Assets")
        }
        try AssetExporter.exportIdentifiers(assets: assets, to: destination, isAbsoluteURL: isAbsoluteURL)
    }
}



