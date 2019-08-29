//
//  AssetCatalogueParser.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 9/15/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//

import Foundation

class AssetCatalogueParser {
    
    
    let assetsURL: URL
    
    init(assetsURL: URL) {
        self.assetsURL = assetsURL
    }
    
    func parse() -> AssetsContainer {
        let container = AssetsContainer(
            imageNames: findNames(for: .imageset), 
            colorNames: findNames(for: .colorset), 
            dataNames: findNames(for: .dataset), 
            textureNames: findNames(for: .textureset), 
            cubeTextureNames: findNames(for: .cubetextureset))
        return container
    }
    
    
    private func findNames(for type: AssetsContainer.AssetType) -> Set<String> {
        // using findOnlyInDirectory because sub-folders aren't supported
        guard let foundFiles = FilesFinder(fileExtension: type.rawValue, baseFolderURL: assetsURL).findOnlyInDirectory() else {
            return []
        } 
        return Set(foundFiles.map { 
            let value = $0.deletingPathExtension().lastPathComponent
            return value
        })
    }
}
