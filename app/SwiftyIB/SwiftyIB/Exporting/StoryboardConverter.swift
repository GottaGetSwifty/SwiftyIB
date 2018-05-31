//
//  StoryboardExporter.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/29/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//


struct StoryboardConverter {
    
    private static func makeEnum(with name: String, and documentation: String, from storyboards: [IBStoryboard], using identifierFinder: () -> ([String])) -> String? {
        guard !name.isEmpty, !storyboards.isEmpty else {
            return nil
        }
        let resultEnum = StringEnumConverter.makeEnum(with: name, and: documentation, from: identifierFinder())
        return resultEnum
    }
    
    
    //MARK: Storboards enum
    
    
    static let storboardEnumDocumentation =     """
                                                /// Automatically generated from SwiftyIB
                                                /// Each case represents a distinct Storyboard file
                                                """
    
    static let storyboardEnumName = "StoryboardIdentifier"
    
    static func makeStoryboardNameEnum(from storyboards: [IBStoryboard]) -> String? {
        let identifierAction = { storyboards.map{ $0.name } }
        return makeEnum(with: storyboardEnumName, and: storboardEnumDocumentation, from: storyboards, using: identifierAction) 
    }
    
    
    //MARK: Scenes enum
    
    
    static let sceneEnumDocumentation =     """
                                            /// Automatically generated from SwiftyIB
                                            /// Each case represents a distinct scene from a storyboard
                                            """
    
    static let scenesEnumName = "SceneIdentifier"
    
    static func makeSceneNameEnum(from storyboards: [IBStoryboard]) -> String? {
        let identifierAction = { storyboards.flatMap{ $0.scenes }.compactMap{$0.viewController.storyboardIdentifier} }
        return makeEnum(with: scenesEnumName, and: sceneEnumDocumentation, from: storyboards, using: identifierAction) 
    }
    
    
    //MARK: Segues enum
    
    
    static let segueEnumDocumentation =     """
                                            /// Automatically generated from SwiftyIB
                                            /// Each case represents a segue from a storyboard
                                            """
    static let segueEnumName = "SegueIdentifier"
    static func makeSegueNameEnum(from storyboards: [IBStoryboard]) -> String? {
        let identifierAction = { storyboards.flatMap{ $0.scenes }.flatMap{$0.viewController.segues}.compactMap{$0.identifier} }
        return makeEnum(with: segueEnumName, and: segueEnumDocumentation, from: storyboards, using: identifierAction) 
    }


    //MARK: Scenes Struct 
    
    static let scenesStructDocumentation = """
                                            /// Automatically generated from SwiftyIB

                                            """
    static func makeScenesStructExtensions(from storyboards: [IBStoryboard]) -> String? {
        var scenesDictionary: [String : [IBScene]] = [:]
        storyboards.map{$0.scenes}.joined().forEach {
            if let viewControllerClass = $0.viewController.customClass {
                if scenesDictionary.keys.contains(viewControllerClass) {
                    scenesDictionary[viewControllerClass]?.append($0)
                }
                else {
                    scenesDictionary[viewControllerClass] = [$0]
                }
            }
        }
        return  makeScenesStructs(from: scenesDictionary)
    }
    
    private static func makeScenesStructs(from scenesDictionary: [String : [IBScene]]) -> String? {
        
        let scenesStructExtensions = scenesDictionary.reduce("") { (runningValue, nextStartingValue) -> String in
            "\(runningValue)\n\n\(makeSecenesStructExtension(from: nextStartingValue.value, className: nextStartingValue.key))"
        }
        return scenesStructExtensions
    }
    
    private static func makeSecenesStructExtension(from scenes: [IBScene], className: String) -> String {
        
        guard  !scenes.isEmpty else {
            return "" 
        }
        
        let extensionText = """
        \(scenesStructDocumentation)
extension \(className) {
    var scenes: _Scenes { return _Scenes(viewController: self) }
    struct _Scenes {
        fileprivate let viewController: ViewController\(scenes.map {
        guard let storyboardID = $0.viewController.storyboardIdentifier else {
            return ""
        }
        let sceneName = $0.storyboardName + storyboardID
        return """
        
        
        var \(sceneName): _\(sceneName) { return _\(sceneName)(viewController: viewController) }
        struct _\(sceneName): IBScene {
            fileprivate let viewController: ViewController
            static let storyboardIdentifier: StoryboardIdentifier = .\($0.storyboardName)
            static let sceneIdentifier: SceneIdentifier = .\(storyboardID)\(makeSegueExtensionText(segues: $0.viewController.segues) )     
        }
"""
        }.reduce("", +)) 
        
        var scenes: [IBScene] { return [\(scenes.map {
            guard let storyboardID = $0.viewController.storyboardIdentifier else {
                return ""
            }
            return "\($0.storyboardName + storyboardID), "
        }.reduce("", +))] }
        
        var currentSceneFromRestorationID: IBScene? {
            guard let restorationID = viewController.restorationIdentifier else {
                return nil
            }
            return scenes.first {$0.sceneIdentifier.rawValue == restorationID}
        }
    }
}
        
"""
        return extensionText
    }
    
    private static func makeSegueExtensionText(segues: [IBSegue]) -> String  {
        guard !segues.isEmpty else {
            return ""
        }
        return """
        
        
            var Segues: _Segues { return _Segues(viewController: viewController) }
            struct _Segues {
                fileprivate let viewController: ViewController\( segues.compactMap {
                    guard let identifier = $0.identifier else {
                        return nil
                    }
                    return """
        
                var \(identifier): IBSegue { return IBSegue(identifier: .\(identifier), viewController: viewController)}
"""
                    }.reduce("", +))
            }
"""
    }
    
    static func makeIBTypes() -> String {
        return """
///IBTypes.swift
/// Automatically generated by SwiftIB. **DO NOT EDIT**

import UIKit
        
protocol IBScene: StoryboardIdentifiable, SceneIdentifiable {
    static var storyboardIdentifier: StoryboardIdentifier { get }
    static var sceneIdentifier: SceneIdentifier { get }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: StoryboardIdentifier { get }
}

protocol SceneIdentifiable {
    static var sceneIdentifier: SceneIdentifier { get }
}
        
struct IBSegue {
    let identifier: SegueIdentifier
    let viewController: UIViewController
}

"""
    }
    
    static func makeIBTypeExtensions() -> String {
        return """
///IBTypeExtensions.swift
/// Automatically generated by SwiftIB. **DO NOT EDIT**

import UIKit

extension UIViewController {

    func performSegue<E: RawRepresentable>(withStringIdentifier stringIdentifier: E,
        sender: Any?) where E.RawValue == String {
        performSegue(withIdentifier: stringIdentifier.rawValue, sender: sender)
    }
    
    func performSegue(with segueIdentifier: SegueIdentifier,
        sender: Any? = nil) {
    
        if segueIdentifier != .none {
            performSegue(withStringIdentifier: segueIdentifier, sender: sender)
        }
    }
}

extension UIStoryboardSegue {

    func getAsStringRawRepresentable<E: RawRepresentable>() -> E? where E.RawValue == String {
    
        if let identifier = self.identifier, let segueIdentifier = E(rawValue: identifier){
            return segueIdentifier
        }
        else{
            return nil
        }
    }

    func getSegueIdentifier() -> SegueIdentifier {

    if let identifier = self.identifier,
        let segueIdentifier = SegueIdentifier(rawValue: identifier){
            return segueIdentifier
        }
        else{
            return .none
        }
    }
}
        
extension IBSegue {
    func perform(sender: Any? = nil) {
        viewController.performSegue(with: identifier, sender: sender)
    }
}
        
extension IBScene {
    var storyboardIdentifier: StoryboardIdentifier { 
        return Self.storyboardIdentifier
    }

    var sceneIdentifier: SceneIdentifier { 
        return Self.sceneIdentifier
    }
}

extension StoryboardIdentifiable {
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardIdentifier.rawValue, bundle: nil)
    }
}

extension SceneIdentifiable where Self: StoryboardIdentifiable {
    static func makeViewControllerFromStoryboard<T: UIViewController>() -> T {
        return storyboard.makeViewController(with: sceneIdentifier) as! T
    }
}

extension UIStoryboard {

    func makeViewController<T: UIViewController>(with identifier: SceneIdentifier) -> T? {
        return instantiateViewController(withIdentifier: identifier.rawValue) as? T
    }
    
    static func makeViewController<T: UIViewController>(storyboard: StoryboardIdentifier, scene: SceneIdentifier) -> T? {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).makeViewController(with: scene) as? T
    }
}

extension UIStoryboard {
    convenience init(identifier: StoryboardIdentifier, bundle: Bundle?) {
        self.init(name: identifier.rawValue, bundle: bundle )
    }
}

extension StoryboardIdentifier {
    func makeInitialVC() -> UIViewController {
        return UIStoryboard(identifier: self, bundle: nil).instantiateInitialViewController()!
    }
}

"""
    }
    
    
}
