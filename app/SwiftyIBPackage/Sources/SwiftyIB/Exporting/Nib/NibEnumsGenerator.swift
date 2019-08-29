//
//  StoryboardExporter.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/29/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//


public class NibEnumsGenerator {
    
    //MARK: Storboards enum
    
    private static let nibIDEnumDocumentation =     """
                                                /// Automatically generated from SwiftyIB
                                                /// Each case represents a distinct Nib file
                                                """
    
    private static let nibIDName = "NibIdentifier"
    
    public static func makeNibNameEnum(from nibs: [IBNib]) -> String? {
        let identifierAction = { nibs.map{ $0.nibName } }
        return StringEnumConverter.makeEnum(with: nibIDName, and: nibIDEnumDocumentation, using: identifierAction)
    }
    
    
    //MARK: Scenes enum
    
    
    private static let cellIDEnumDocumentation =     """
                                            /// Automatically generated from SwiftyIB
                                            /// Each case represents a found reuseIdentifier
                                            """
    
    private static let cellIDEnumName = "ReuseIdentifier"
    
    public static func makeCellIdentifierEnum(from nibs: [IBNib]) -> String? {
        let identifierAction = { nibs.flatMap{ $0.views?.compactMap{$0.reuseIdentifier} ?? [] } }
        return StringEnumConverter.makeEnum(with: cellIDEnumName, and: cellIDEnumDocumentation, using: identifierAction) 
    }
}
