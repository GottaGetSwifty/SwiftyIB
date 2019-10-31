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
//
//public struct IBViewController: XMLIndexerDeserializable {
//    let id: String
//    let storyboardIdentifier: String?
//    let restorationIdentifier: String?
//    let customClass: String?
//    private let segues: [IBSegue]
//    let view: IBView?
//    
//    var allSegues: [IBSegue] {
//        return segues + (view?.allSegues ?? [])
//    }
//    
//    public static func deserialize(_ node: XMLIndexer) throws -> IBViewController {
//        return try IBViewController(id: node.value(of: AttributeKeys.id), 
//                                    storyboardIdentifier: node.value(of: AttributeKeys.storyboardIdentifier), 
//                                    restorationIdentifier: node.value(of: AttributeKeys.restorationIdentifier),
//                                    customClass: node.value(of: AttributeKeys.customClass), 
//                                    segues: getSegues(from: node), 
//                                    view: findView(in: node))
//    }
//    
//    static func findView(in element: XMLIndexer)  -> IBView?  {
//        let views = ElementKeys.viewTypes.compactMap{ try? IBView.deserialize(element[$0])} 
//        return views.first
//    }
//    
//    static func getSegues(from element: XMLIndexer) -> [IBSegue] {
//        let segues = element[ElementKeys.connections][ElementKeys.segue].all
//        do {
//            return try segues.map(IBSegue.deserialize) 
//        }
//        catch let e {
//            print(e.localizedDescription)
//            return []
//        }
//    }
//}
//
//public struct IBView: XMLIndexerDeserializable {
//    let id: String
//    let customClass: String?
//    let userLabel: String?
//    let connections: [IBConnection]
//    let subViews: [IBView]
//    
//    var allSegues: [IBSegue] {
//        return connections.flatMap {$0.segues} + subViews.flatMap{$0.allSegues}
//    }
//    
//    public static func deserialize(_ node: XMLIndexer) throws -> IBView {
//        return try IBView(id: node.value(of: AttributeKeys.id),
//                          customClass: try? node.value(of: AttributeKeys.customClass), 
//                          userLabel: try? node.value(of: AttributeKeys.customClass), 
//                          connections: (try? node[ElementKeys.connections].all.map(IBConnection.deserialize)) ?? [], 
//                          subViews: findSubviews(in: node)) 
//    }
//    
//    static func findSubviews(in element: XMLIndexer) -> [IBView]  {
//        let subviews = element[ElementKeys.subviews]
//        
//        switch subviews {
//        case .xmlError(_):
//            return []
//        default: break
//        }
//        
//        let foundViews = ElementKeys.viewTypes.flatMap{subviews[$0].all }
//        let parsedViews = foundViews.compactMap{ try? IBView.deserialize($0)}
//        return parsedViews
//    }
//}
//
