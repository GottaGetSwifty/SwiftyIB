//
//  StoryboardParser.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/27/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//
import Foundation
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
        let storyboard = IBStoryboard.deserialize(document, with: storyboardPath.deletingPathExtension().lastPathComponent)
        Bundle.main.url(forResource: "soundfile.ext", withExtension: "")
        return storyboard
        
    }
}

public struct IBStoryboard: XMLIndexerDeserializable {
    let initialScene: IBScene?
    let scenes: [IBScene]
    let name: String
    
    static func deserialize(_ node: XMLIndexer, with name: String) -> IBStoryboard? {
        let initalVC: String? = node.value(of: AttributeKeys.initialViewController)
        var initalScene: IBScene? = nil
        let sceneNodes = node[ElementKeys.scenes][ElementKeys.scene]
        
        let scenes = sceneNodes.all.compactMap({try? IBScene.deserialize($0, storyboardName: name)})
        
        if !scenes.isEmpty, let realInitial = initalVC {
            initalScene = scenes.first(where: {$0.viewController.id == realInitial}) 
        }
        
        return IBStoryboard(initialScene: initalScene, scenes: scenes, name: name)

    }
}

public struct IBScene: XMLIndexerDeserializable {
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

public struct IBViewController: XMLIndexerDeserializable {
    let id: String
    let storyboardIdentifier: String?
    let restorationIdentifier: String?
    let customClass: String?
    let segues: [IBSegue]
    let view: IBView
    
    var allSegues: [IBSegue] {
        return segues + view.allSegues
    }
    
    public static func deserialize(_ node: XMLIndexer) throws -> IBViewController {
        return try IBViewController(id: node.value(of: AttributeKeys.id), 
                                    storyboardIdentifier: node.value(of: AttributeKeys.storyboardIdentifier), 
                                    restorationIdentifier: node.value(of: AttributeKeys.restorationIdentifier),
                                    customClass: node.value(of: AttributeKeys.customClass), 
                                    segues: node[ElementKeys.connections][ElementKeys.segue].all.map(IBSegue.deserialize), view: IBView.deserialize(node[ElementKeys.view]))
    }
}

public struct IBView: XMLIndexerDeserializable {
    let id: String
    let customClass: String?
    let userLabel: String?
    let connections: [IBConnection]
    let subViews: [IBView]
    
    var allSegues: [IBSegue] {
        return connections.flatMap {$0.segues} + subViews.flatMap{$0.allSegues}
    }
    
    public static func deserialize(_ node: XMLIndexer) throws -> IBView {
        return try IBView(id: node.value(of: AttributeKeys.id),
                          customClass: node.value(of: AttributeKeys.customClass), 
                          userLabel: node.value(of: AttributeKeys.customClass), 
                          connections: node[ElementKeys.connections].all.map(IBConnection.deserialize), 
                          subViews: findSubviews(in: node))
    }
    
    static func findSubviews(in element: XMLIndexer) throws -> [IBView]  {
        return ElementKeys.viewTypes.flatMap{  (try? element[ElementKeys.subviews][$0].all.map(IBView.deserialize)) ?? []}
    }
}

public struct IBConnection: XMLIndexerDeserializable {
    
    let segues: [IBSegue]
    
    public static func deserialize(_ node: XMLIndexer) throws -> IBConnection {
        return try IBConnection(segues: node[ElementKeys.segue].all.map(IBSegue.deserialize))
    }
}

public struct IBSegue: XMLIndexerDeserializable {
    let destination: String
    let identifier: String?
    public static func deserialize(_ node: XMLIndexer) throws -> IBSegue {
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
