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
    
    static let storboardEnumDocumentation =     """
                                                /// Automatically generated from SwiftyIB
                                                /// Each case represents a distinct Storyboard file
                                                """
    static let storyboardEnumName = "StoryboardIdentifier"
    static func makeStoryboardNameEnum(from storyboards: [IBStoryboard]) -> String? {
        let identifierAction = { storyboards.map{ $0.name } }
        return makeEnum(with: storyboardEnumName, and: storboardEnumDocumentation, from: storyboards, using: identifierAction) 
    }
    
    static let sceneEnumDocumentation =     """
                                            /// Automatically generated from SwiftyIB
                                            /// Each case represents a distinct scene from a storyboard
                                            """
    static let scenesEnumName = "SceneIdentifier"
    static func makeSceneNameEnum(from storyboards: [IBStoryboard]) -> String? {
        let identifierAction = { storyboards.flatMap{ $0.scenes }.flatMap{$0.viewController.storyboardIdentifier} }
        return makeEnum(with: scenesEnumName, and: sceneEnumDocumentation, from: storyboards, using: identifierAction) 
    }
    
    static let segueEnumDocumentation =     """
                                            /// Automatically generated from SwiftyIB
                                            /// Each case represents a segue from a storyboard
                                            """
    static let segueEnumName = "SegueIdentifier"
    static func makeSegueNameEnum(from storyboards: [IBStoryboard]) -> String? {
        let identifierAction = { storyboards.flatMap{ $0.scenes }.flatMap{$0.viewController.segues}.flatMap{$0.identifier} }
        return makeEnum(with: segueEnumName, and: segueEnumDocumentation, from: storyboards, using: identifierAction) 
    }
}
