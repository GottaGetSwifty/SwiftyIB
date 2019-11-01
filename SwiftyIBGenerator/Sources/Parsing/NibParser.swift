//
//  StoryboardParser.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/27/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//
import Foundation
import SWXMLHash

class NibParser {
    
    enum Errors: Error {
        case noScenesFound
        case noViewControllerFound
    }
    
    let nibPath: URL
    
    init(with nibPath: URL) {
        self.nibPath = nibPath
    }
    
    func loadData() -> Data? {
        let data = try? Data(contentsOf: nibPath, options: Data.ReadingOptions.uncached)
        return data
    }
    
    func loadXML() -> XMLIndexer? {
        guard let data = loadData() else {
            return nil
        }
        
        let xml = SWXMLHash.config({ (config) in
            
        }).parse(data)
        return xml
    }
     
    func parse() -> IBNib? {
        guard let xml = loadXML() else {
            return nil
        }
        
        guard let document = try? xml.byKey(IBNib.ElementKeys.document) else {
            return nil
        }
        let nib = IBNib.deserialize(document, nibName: nibPath.deletingPathExtension().lastPathComponent)
        return nib
    }
}

public struct IBNib: XMLIndexerDeserializable {
    let views: [IBView]?
    let nibName: String
    
    static func deserialize(_ node: XMLIndexer, nibName: String) -> IBNib? {
        do {
            return IBNib(views: try findViews(in: node), nibName: nibName)
        }
        catch let e {
            print(e.localizedDescription)
            return nil
        }
    }
    
    static func findViews(in element: XMLIndexer) throws -> [IBView]  {
        let possibleObjects = element[ElementKeys.objects]
        
        switch possibleObjects {
        case .xmlError(_):
            return []
        default: break
        }
        let objects = possibleObjects.all.flatMap{$0.children}
        let views = objects.compactMap(IBView.findNibView)
        return views
    }
}
