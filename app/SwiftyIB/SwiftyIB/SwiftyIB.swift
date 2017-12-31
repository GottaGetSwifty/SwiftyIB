//
//  SwiftyIB.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/31/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//

import Foundation
class SwiftyIB {
    let containingURL: URL
    
    init?(containingURL: URL) {
        guard containingURL.hasDirectoryPath else{
            return nil
        }
        self.containingURL = containingURL
    }
    
    func findAllStorboardURLs() -> [URL] {
        let allURLs = FilesFinder.getAllStoryboardFiles(in: self.containingURL) ?? []
        allURLs.forEach{print($0.absoluteString)}
        return allURLs
    }
    
    func buildStoryboards() -> [IBStoryboard] {
        let allStoryboards = findAllStorboardURLs().map(StoryboardParser.init).flatMap{ $0.parse() }
        
        return allStoryboards
    } 
}
