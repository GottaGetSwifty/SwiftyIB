//
//  StoryboardExporter.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/29/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//


public class StoryboardEnumsGenerator {
    
    private static func makeEnum(with name: String, and documentation: String, from storyboards: [IBStoryboard], using identifierFinder: () -> ([String])) -> String? {
        guard !name.isEmpty, !storyboards.isEmpty else {
            return nil
        }
        let resultEnum = StringEnumConverter.makeEnum(with: name, and: documentation, from: identifierFinder())
        return resultEnum
    }
    
    
    //MARK: Storboards enum
    
    
    private static let storboardEnumDocumentation =     """
                                                /// Automatically generated from SwiftyIB
                                                /// Each case represents a distinct Storyboard file
                                                """
    
    private static let storyboardEnumName = "StoryboardIdentifier"
    
    public static func makeStoryboardNameEnum(from storyboards: [IBStoryboard]) -> String? {
        let identifierAction = { storyboards.map{ $0.name } }
        return makeEnum(with: storyboardEnumName, and: storboardEnumDocumentation, from: storyboards, using: identifierAction)
    }
    
    
    //MARK: Scenes enum
    
    
    private static let sceneEnumDocumentation =     """
                                            /// Automatically generated from SwiftyIB
                                            /// Each case represents a distinct scene from a storyboard
                                            """
    
    private static let scenesEnumName = "SceneIdentifier"
    
    public static func makeSceneNameEnum(from storyboards: [IBStoryboard]) -> String? {
        let identifierAction = { storyboards.flatMap{ $0.scenes }.compactMap{$0.viewController.storyboardIdentifier} }
        return makeEnum(with: scenesEnumName, and: sceneEnumDocumentation, from: storyboards, using: identifierAction) 
    }
    
    
    //MARK: Segues enum
    
    
    private static let segueEnumDocumentation =     """
                                            /// Automatically generated from SwiftyIB
                                            /// Each case represents a segue from a storyboard
                                            """
    private static let segueEnumName = "SegueIdentifier"
    public static func makeSegueNameEnum(from storyboards: [IBStoryboard]) -> String? {
        let identifierAction = { storyboards.flatMap{ $0.scenes }.flatMap{$0.viewController.allSegues}.compactMap{$0.identifier} }
        return makeEnum(with: segueEnumName, and: segueEnumDocumentation, from: storyboards, using: identifierAction) 
    }
}
