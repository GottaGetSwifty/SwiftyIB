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
        let path = Bundle.main.path(forResource: "iOSTestStoryboard", ofType: "xml")!
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
        
        let xml = SWXMLHash.config({ (config) in
            
        }).parse(data)
        return xml
    }
     
    func parse() -> IBStoryboard? {
        guard let xml = loadXML() else {
            return nil
        }
        
        let storyboard = try? IBStoryboard.deserialize(xml[IBStoryboard.ElementKeys.document])
        return storyboard
    }
}

struct IBStoryboard: XMLIndexerDeserializable {
    let initialScene: IBScene?
    let scenes: [IBScene]
    
    static func deserialize(_ node: XMLIndexer) throws -> IBStoryboard {
        let initalVC: String? = node.value(of: AttributeKeys.initialViewController)
        let initalScene: IBScene?
        let scenes = try node[ElementKeys.scenes][ElementKeys.scene].all.map(IBScene.deserialize)
        if let realInitial = initalVC {
            initalScene = scenes.first(where: {$0.viewController.id == realInitial}) 
        }
        else {
            initalScene = nil
        }
        
        return IBStoryboard(
            initialScene: initalScene,
            scenes: scenes
        )
    }
}

struct IBScene: XMLIndexerDeserializable {
    let sceneID: String
    let viewController: IBViewController
    static func deserialize(_ node: XMLIndexer) throws -> IBScene {
        return try IBScene(sceneID: node.value(of: AttributeKeys.sceneID), viewController: findViewController(in: node))
    }
    
    static func findViewController(in element: XMLIndexer) throws -> IBViewController  {
        for key in ElementKeys.sceneTypes {
            if element[ElementKeys.objects][key].element != nil {
                return try IBViewController.deserialize(element[ElementKeys.objects][key])
            }
        }
        throw NSError.init()
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
    
    public subscript<T: RawRepresentable>(key: T) -> XMLIndexer where T.RawValue == String{
        return self[key.rawValue]
    }
}
