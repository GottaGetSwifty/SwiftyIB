//
//  StoryboardParser.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/27/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//

import Cocoa

class StoryboardParser {
    
    enum Errors: Error {
        case noScenesFound
        case noViewControllerFound
    }
    
    let storyboardPath: URL
    
    init(with storyboardPath: URL) {
        self.storyboardPath = storyboardPath
    }
    
    func loadData() -> Data? {
        let data = try? Data(contentsOf: storyboardPath, options: Data.ReadingOptions.uncached)
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
     
    func parse() -> IBStoryboard? {
        guard let xml = loadXML() else {
            return nil
        }
        
        guard let document = try? xml.byKey(IBStoryboard.ElementKeys.document) else {
            return nil
        }
        let storyboard = try? IBStoryboard.deserialize(document, with: storyboardPath.deletingPathExtension().lastPathComponent)
        Bundle.main.url(forResource: "soundfile.ext", withExtension: "")
        return storyboard
        
    }
}

struct IBStoryboard: XMLIndexerDeserializable {
    let initialScene: IBScene?
    let scenes: [IBScene]
    let name: String
    
    static func deserialize(_ node: XMLIndexer, with name: String) throws -> IBStoryboard {
        let initalVC: String? = node.value(of: AttributeKeys.initialViewController)
        var initalScene: IBScene? = nil
        let sceneNodes = node[ElementKeys.scenes][ElementKeys.scene]
        let scenes = try sceneNodes.all.map({try IBScene.deserialize($0, storyboardName: name)})
        
        guard !scenes.isEmpty else {
            throw StoryboardParser.Errors.noScenesFound
        }
        if let realInitial = initalVC {
            initalScene = scenes.first(where: {$0.viewController.id == realInitial}) 
        }
        
        return IBStoryboard(initialScene: initalScene, scenes: scenes, name: name)
    }
}

struct IBScene: XMLIndexerDeserializable {
    let sceneID: String
    let viewController: IBViewController
    let storyboardName: String
    
    static func deserialize(_ node: XMLIndexer, storyboardName: String) throws -> IBScene {
        return try IBScene(sceneID: node.value(of: AttributeKeys.sceneID), viewController: findViewController(in: node), storyboardName: storyboardName)
    }
    
    static func findViewController(in element: XMLIndexer) throws -> IBViewController  {
        for key in ElementKeys.sceneTypes {
            if element[ElementKeys.objects][key].element != nil {
                return try IBViewController.deserialize(element[ElementKeys.objects][key])
            }
        }
        throw StoryboardParser.Errors.noViewControllerFound
    }
}

struct IBViewController: XMLIndexerDeserializable {
    let id: String
    let storyboardIdentifier: String?
    let restorationIdentifier: String?
    let customClass: String?
    let segues: [IBSegue]
    static func deserialize(_ node: XMLIndexer) throws -> IBViewController {
        return try IBViewController(id: node.value(of: AttributeKeys.id), 
                                    storyboardIdentifier: node.value(of: AttributeKeys.storyboardIdentifier), 
                                    restorationIdentifier: node.value(of: AttributeKeys.restorationIdentifier),
                                    customClass: node.value(of: AttributeKeys.customClass), 
                                    segues: node[ElementKeys.connections][ElementKeys.segue].all.map(IBSegue.deserialize))
    }
}

struct IBSegue: XMLIndexerDeserializable{
    let destination: String
    let identifier: String?
    static func deserialize(_ node: XMLIndexer) throws -> IBSegue {
        return try IBSegue(destination: node.value(of: AttributeKeys.destination), identifier: node.value(of: AttributeKeys.identifier))
    }
}

extension XMLIndexer {
    
    func value<T: XMLAttributeDeserializable, U: RawRepresentable>(of attr: U) throws -> T where U.RawValue == String {
        return try value(ofAttribute: attr.rawValue)
    }
    func value<T: XMLAttributeDeserializable, U: RawRepresentable>(of attr: U) -> T? where U.RawValue == String {
        return value(ofAttribute: attr.rawValue)
    }
    
    public subscript<T: RawRepresentable>(key: T) -> XMLIndexer where T.RawValue == String {
        return self[key.rawValue]
    }
    
    public func byKey<T: RawRepresentable>(_ key: T) throws -> XMLIndexer where T.RawValue == String {
        return try byKey(key.rawValue)
    }
}
