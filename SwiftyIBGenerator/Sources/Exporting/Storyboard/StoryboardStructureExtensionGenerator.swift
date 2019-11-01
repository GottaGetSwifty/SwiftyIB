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
                                            import UIKit
                                            import SwiftyIB
                                            """
    public static func makeScenesStructExtensions(from storyboards: [IBStoryboard]) -> String? {
        let scenesDictionary = makeScenesDictionary(from: storyboards)
        return  makeScenesStructs(from: scenesDictionary)
    }
    
    private static func makeScenesDictionary(from storyboards: [IBStoryboard]) -> [String : [IBScene]] {
        var scenesDictionary: [String : [IBScene]] = [:]
        storyboards.map{$0.scenes}.joined().forEach {
            if let viewControllerClass = $0.viewController?.customClass {
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
        
        let hasMultipleScenes = scenes.count > 1
        
        let extensionText = """
   
""" + (hasMultipleScenes ? buildMultipleScenesStruct(scenes: scenes, viewControllerClassName: className) : buildSingleSceneStruct(scene: scenes[0], viewControllerClassName: className))

        return extensionText
    }
    
    private static func buildMultipleScenesStruct(scenes: [IBScene], viewControllerClassName: String) -> String {
        
        return """


extension \(viewControllerClassName) {        
    var Scenes: _Scenes { return _Scenes(_viewController: self) }
    struct _Scenes {
    
        fileprivate let _viewController: \(viewControllerClassName)
        var viewController: UIViewController { return _viewController }
        \(scenes.map {
            guard let storyboardID = $0.viewController?.storyboardIdentifier else {
                return ""
            }
            let sceneName = $0.storyboardName + storyboardID
            return """
            
        var \(sceneName): _\(sceneName) { return _\(sceneName)(_viewController: _viewController) }
        struct _\(sceneName): IBScene {
            init(_viewController: \(viewControllerClassName)) { self._viewController = _viewController }
            fileprivate let _viewController: \(viewControllerClassName)
            var viewController: UIViewController { return _viewController }
            static let storyboardIdentifier: StoryboardIdentifier = .\($0.storyboardName)
            static let sceneIdentifier: SceneIdentifier = .\(storyboardID)\(makeSegueExtensionText(segues: $0.viewController?.allSegues ?? [], viewControllerClassName: viewControllerClassName) )     
        }

"""
        }.reduce("", +)) 

        var scenes: [AnyIBScene] { 
             [\(scenes.map {
                guard let storyboardID = $0.viewController?.storyboardIdentifier else {
                    return ""
                }
                return "\($0.storyboardName + storyboardID), "
            }.reduce("", +))] }
        
        var currentSceneFromRestorationID: AnyIBScene? {
            guard let restorationID = viewController.restorationIdentifier else {
                return nil
            }
            return scenes.first { type(of: $0).sceneIdentifier.name == restorationID }
        }
    }
}
"""
    }

    private static func buildSingleSceneStruct(scene: IBScene, viewControllerClassName: String) -> String {
        guard let sceneName = scene.viewController?.storyboardIdentifier else {
            return ""
        }
        return """


private protocol \(viewControllerClassName)SceneContainer: SceneContainer { }

extension \(viewControllerClassName): \(viewControllerClassName)SceneContainer {             
    typealias SceneType = \(viewControllerClassName)Scene
    struct \(viewControllerClassName)Scene: IBScene {
        init(_viewController: \(viewControllerClassName)) { self._viewController = _viewController }
        fileprivate let _viewController: \(viewControllerClassName)
        var viewController: UIViewController { return _viewController }
        static let storyboardIdentifier: StoryboardIdentifier = .\(scene.storyboardName)
        static let sceneIdentifier: SceneIdentifier = .\(sceneName)\(makeSingleSceneSegueExtensionText(segues: scene.viewController?.allSegues ?? [], viewControllerClassName: viewControllerClassName) )     
    }
}
"""
    }
    
    private static func makeSegueExtensionText(segues: [IBSegue], viewControllerClassName: String) -> String  {
        let validSegues = segues.filter { $0.identifier != nil}
        guard !validSegues.isEmpty else {
            return ""
        }
        return """


            var Segues: _Segues { return _Segues(_viewController: _viewController) }
            struct _Segues {
                fileprivate let _viewController: \(viewControllerClassName)
                var viewController: UIViewController { return _viewController }\( validSegues.compactMap {
                    guard let identifier = $0.identifier else {
                        return nil
                    }
                    return """

                var \(identifier): IBSegue { return IBSegue(segueIdentifier: .\(identifier), viewController: viewController)}
"""
                    }.reduce("", +))
            }
"""
    }
    
    private static func makeSingleSceneSegueExtensionText(segues: [IBSegue], viewControllerClassName: String) -> String  {
        let validSegues = segues.filter { $0.identifier != nil}
        guard !validSegues.isEmpty else {
            return ""
        }
        return """


        var Segues: _Segues { return _Segues(_viewController: _viewController) }
        struct _Segues {
            fileprivate let _viewController: \(viewControllerClassName)
            var viewController: UIViewController { return _viewController }\( validSegues.compactMap {
                guard let identifier = $0.identifier else {
                    return nil
                }
                return """

            var \(identifier): IBSegue { return IBSegue(segueIdentifier: .\(identifier), viewController: viewController)}
"""
                }.reduce("", +))
        }
"""
    }
}
