//
//  IBKeys.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/27/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//

extension IBStoryboard {
    enum AttributeKeys: String {
        case initialViewController
    }
    enum ElementKeys: String {
        case document
        case scenes
        case scene
    }
}

extension IBScene {
    enum AttributeKeys: String {
        case sceneID
    }
    
    enum ElementKeys: String {
        case objects
        case viewController
        case tableViewController
        case collectionViewController
        case navigationController
        case splitViewController
        case tabBarController
        
        static let sceneTypes = [.viewController, .tableViewController, collectionViewController, .collectionViewController, .navigationController, .splitViewController, .tabBarController]
    }
}

extension IBViewController {
    enum AttributeKeys: String {
        case id
        case restorationIdentifier
        case storyboardIdentifier
        case customClass
    }
    
    enum ElementKeys: String {
        case view
        case connections
        case segue
    }
}

extension IBView {
    enum AttributeKeys: String {
        case id
        case userLabel
        case customClass
    }
    
    enum ElementKeys: String {
        case subviews
        case segue
        case connections
        
        case view
        case imageView
        case containerView
     
        static let viewTypes: [ElementKeys] = [ .view, .imageView, .containerView ]
    }
}

extension IBConnection {
    enum ElementKeys: String {
        case segue
    }
}

extension IBSegue {
    enum AttributeKeys: String {
        case destination
        case kind
        case identifier
    }
}
