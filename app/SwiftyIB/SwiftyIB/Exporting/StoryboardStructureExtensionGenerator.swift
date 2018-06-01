//
//  StoryboardStructuerExtensionGenerator.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 6/1/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//

import Foundation

public class StoryboardStructureExtensionGenerator {
   
    //MARK: Scenes Struct 
    
    private static let scenesStructDocumentation = """
                                            /// Automatically generated from SwiftyIB
                                            """
    public static func makeScenesStructExtensions(from storyboards: [IBStoryboard]) -> String? {
        let scenesDictionary = makeScenesDictionary(from: storyboards)
        return  makeScenesStructs(from: scenesDictionary)
    }
    
    private static func makeScenesDictionary(from storyboards: [IBStoryboard]) -> [String : [IBScene]] {
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
        return scenesDictionary
    }
    
    private static func makeScenesStructs(from scenesDictionary: [String : [IBScene]]) -> String? {
        let scenesStructExtensions: String = scenesDictionary.map(makeSecenesStructExtension).reduce(scenesStructDocumentation, +)
        return scenesStructExtensions
    }
    
    private static func makeSecenesStructExtension(className: String, scenes: [IBScene]) -> String {
        
        guard  !scenes.isEmpty else {
            return "" 
        }
        
        let extensionText = """
        
        
extension \(className) {
            
    var scenes: _Scenes { return _Scenes(viewController: self) }
    struct _Scenes {
            
        fileprivate let viewController: \(className)
"""         + (scenes.count > 1 ? buildMultipleScenesStruct(scenes: scenes, viewControllerClass: className) : buildSingleSceneStruct(scene: scenes[0], viewControllerClass: className))
            + """
        
    }
}
        
"""
        return extensionText
    }
    
    private static func buildMultipleScenesStruct(scenes: [IBScene], viewControllerClass: String) -> String {
        
        return """
        \(scenes.map {
            guard let storyboardID = $0.viewController.storyboardIdentifier else {
                return ""
            }
            let sceneName = $0.storyboardName + storyboardID
            return """
            
            var \(sceneName): _\(sceneName) { return _\(sceneName)(viewController: viewController) }
            struct _\(sceneName): IBScene {
                fileprivate let viewController: \(viewControllerClass)
                static let storyboardIdentifier: StoryboardIdentifier = .\($0.storyboardName)
                static let sceneIdentifier: SceneIdentifier = .\(storyboardID)\(makeSegueExtensionText(segues: $0.viewController.segues, viewControllerClassName: viewControllerClass) )     
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
"""
    }
    
    private static func buildSingleSceneStruct(scene: IBScene, viewControllerClass: String) -> String {
        guard let sceneName = scene.viewController.storyboardIdentifier else {
            return ""
        }
        return """
            
        
        var \(sceneName): _\(sceneName) { return _\(sceneName)(viewController: viewController) }
        struct _\(sceneName): IBScene {
            fileprivate let viewController: \(viewControllerClass)
            static let storyboardIdentifier: StoryboardIdentifier = .\(scene.storyboardName)
            static let sceneIdentifier: SceneIdentifier = .\(sceneName)\(makeSegueExtensionText(segues: scene.viewController.segues, viewControllerClassName: viewControllerClass) )     
        }
    
        var currentScene: _\(sceneName) { return \(sceneName) }
"""
    }
    
    private static func makeSegueExtensionText(segues: [IBSegue], viewControllerClassName: String) -> String  {
        guard !segues.isEmpty else {
            return ""
        }
        return """
        
        
            var Segues: _Segues { return _Segues(viewController: viewController) }
            struct _Segues {
                fileprivate let viewController: \(viewControllerClassName)\( segues.compactMap {
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
}
