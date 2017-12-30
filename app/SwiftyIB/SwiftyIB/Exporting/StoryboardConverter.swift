//
//  StoryboardExporter.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/29/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//


struct StoryboardConverter {
    
    private static func makeEnum(with name: String, from storyboards: [IBStoryboard], using identifierFinder: () -> ([String])) -> String? {
        guard !name.isEmpty, !storyboards.isEmpty else {
            return nil
        }
        let resultEnum = StringEnumConverter.makeEnum(with: name, from: identifierFinder())
        return resultEnum
    }
    
    static let storyboardEnumName = "StoryboardIdentifier"
    static func makeStoryboardNameEnum(from storyboards: [IBStoryboard]) -> String? {
        let identifierAction = { storyboards.map{ $0.name } }
        return makeEnum(with: storyboardEnumName, from: storyboards, using: identifierAction) 
    }
    
    static let scenesEnumName = "SceneIdentifier"
    static func makeSceneNameEnum(from storyboards: [IBStoryboard]) -> String? {
        let identifierAction = { storyboards.flatMap{ $0.scenes }.flatMap{$0.viewController.storyboardIdentifier} }
        return makeEnum(with: scenesEnumName, from: storyboards, using: identifierAction) 
    }
    
    static let segueEnumName = "SegueIdentifier"
    static func makeSegueNameEnum(from storyboards: [IBStoryboard]) -> String? {
        let identifierAction = { storyboards.flatMap{ $0.scenes }.flatMap{$0.viewController.segues}.flatMap{$0.identifier} }
        return makeEnum(with: segueEnumName, from: storyboards, using: identifierAction) 
    }
}
