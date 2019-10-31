//
//  AssetModels.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 9/15/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//

import Foundation

public struct AssetsContainer {
    let imageNames: Set<String>
    let colorNames: Set<String>
    let dataNames: Set<String>
    let textureNames: Set<String>
    let cubeTextureNames: Set<String>
    
    var isEmpty: Bool {
        let result = imageNames.isEmpty && colorNames.isEmpty && dataNames.isEmpty && textureNames.isEmpty && cubeTextureNames.isEmpty
        return result
    }
    
    func values(for type: AssetType) -> Set<String> {
        switch type {
        case .imageset: return imageNames
        case .colorset: return colorNames
        case .dataset: return dataNames
        case .textureset: return textureNames
        case .cubetextureset: return cubeTextureNames
        }
    } 
    
    static func +(_ left: AssetsContainer, _ right: AssetsContainer) -> AssetsContainer {
        return AssetsContainer(
            imageNames: left.imageNames.union(right.imageNames), 
            colorNames: left.colorNames.union(right.colorNames), 
            dataNames: left.dataNames.union(right.dataNames), 
            textureNames: left.textureNames.union(right.textureNames), 
            cubeTextureNames: left.cubeTextureNames.union(right.cubeTextureNames))
    }
    
    static let emptyValue = AssetsContainer(imageNames: [], colorNames: [], dataNames: [], textureNames: [], cubeTextureNames: [])
}

extension AssetsContainer {
    enum AssetType: String {
        case imageset
        case colorset
        case dataset
        case textureset
        case cubetextureset
        
        var identifierEnumName: String {
            switch self {
            case .imageset:
                return "AssetImageIdentifier"
            case .colorset:
                return "AssetColorIdentifier"
            case .dataset:
                return "AssetDataIdentifier"
            case .textureset:
                return "AssetTextureIdentifier"
            case .cubetextureset:
                return "AssetCubeTextureIdentifier"
            }
        }
        
        static var allValues: [AssetType] {
            return [.imageset, .colorset, .dataset, .textureset, .cubetextureset]
        }
    }
}
