//
//  AssetExporter.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 9/15/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//

import Foundation

class AssetExporter: Exporter {
    
    private static let enumHeaderDocumentation =     """
                                                /// Automatically generated from SwiftyIB
                                                /// Each case represents a distinct Asset
                                                """
    
    private static let assetsPath = "IBIdentifiers/Assets/"
    private static let assetIDFilePath = "\(assetsPath)XCAssetIdentifiers.swift"
    private static let assetExtensionsPath = "\(assetsPath)XCAssetExtensions.swift"
    
    public static func exportIdentifiers(assets: AssetsContainer, to destination: URL, isAbsoluteURL: Bool) throws {
        var hasMadeHeader = false
        func triggerHeader() -> Bool {
            let value = hasMadeHeader
            hasMadeHeader = true
            return !value
        }
        let enums = AssetsContainer.AssetType.allValues.map{ makeEnum(from: assets, for: $0, addEnumHeader: triggerHeader()) }
        let allEnums = enums.joined()
        if !allEnums.isEmpty {
            let result = exportFile(fileText: allEnums, to: destination.appendingPathComponent(assetIDFilePath), isAbsoluteURL: isAbsoluteURL)
            print("Exporting assets enum result: \(result)")
        }
        else {
            print("Did not find any asset identifiers")
        }
    }
    
    private static func makeEnum(from assets: AssetsContainer, for type: AssetsContainer.AssetType, addEnumHeader: Bool) -> String {
        
        let names = assets.values(for: type)
        guard !names.isEmpty else {
            return ""
        }
    
        return StringEnumConverter.makeEnum(with: type.identifierEnumName, and: enumHeaderDocumentation, from: Array(names), addEnumHeader: addEnumHeader) ?? ""
    }
    
    static func exportAssetExtensions(to destination: URL, isAbsoluteURL: Bool) throws {
        let fileText = AssetTypesAndExtensionsGenerator.makeAssetsTypesAndExtensions() 
        let result = exportFile(fileText: fileText, to: destination.appendingPathComponent(assetExtensionsPath), isAbsoluteURL: isAbsoluteURL)
        print("Exporting XCAsset Extensions result: \(result)")
        
    }
}
