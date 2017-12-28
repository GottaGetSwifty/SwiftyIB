//
//  StoryboardParser.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/27/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//

import SWXMLHash
import Cocoa

class StoryboardParser {
    
    let storyboardPath: URL
    
    init(with storyboardPath: URL) {
        self.storyboardPath = storyboardPath
    }
    
    static func getTestStoryboard() ->  URL? {
        let path = Bundle.main.path(forResource: "TestStoryboard", ofType: "xml")!
        let url = URL(fileURLWithPath: path)
        return url
    }
    
    func loadData() -> Data? {
        let data = try? Data.init(contentsOf: storyboardPath, options: Data.ReadingOptions.uncached)
        return data
    }
    
    func loadXML() -> XMLIndexer? {
        guard let data = loadData() else {
            return nil
        }
        let xml = SWXMLHash.config {
            $0.shouldProcessLazily = true
            }.parse(data)
        return xml
    }
}

struct Storyboard: XMLIndexerDeserializable {
    let initialScene: Scene?
    let scenes: [Scene]
    
    static func deserialize(_ node: XMLIndexer) throws -> Storyboard {
        return try Storyboard(
            initialScene: node["title"].value(),
            scenes: node["price"].value(),
        )
    }
}

struct Scene {
    
}
