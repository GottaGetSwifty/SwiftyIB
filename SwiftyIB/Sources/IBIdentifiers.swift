//
//  File.swift
//  
//
//  Created by Paul Fechner on 10/31/19.
//

import Foundation

// MARK: - IBIdentifier
public protocol IBIdentifier: Hashable {
    var name: String { get }
    init(name: String)
}
extension IBIdentifier {
    public static var none: Self {Self(name: "")}
}

public protocol IBIdentifierMakeable {
    associatedtype IdentifierType: IBIdentifier
    static func make(with identifier: IdentifierType, in bundle: Bundle?) -> Self?
}
public extension IBIdentifierMakeable {
    static func make(with identifier: IdentifierType) -> Self? {
        self.make(with: identifier, in: nil)
    }
}

#if canImport(UIKit)
import UIKit
public protocol IBIdentifierWithTraitsMakeable {
    associatedtype IdentifierType: IBIdentifier
    static func make(with identifier: IdentifierType, in bundle: Bundle?, compatableWith traits: UITraitCollection?) -> Self?
}

public extension IBIdentifierWithTraitsMakeable {
    static func make(with identifier: IdentifierType, in bundle: Bundle?) -> Self? {
        self.make(with: identifier, in: bundle, compatableWith: nil)
    }
}

extension StoryboardIdentifier {
    public func makeStoryboard(bundle: Bundle? = nil) -> UIStoryboard? {
        guard self != Self.none else {
            return nil
        }
        return UIStoryboard.make(with: self, in: bundle)
    }
}
#endif

// MARK: - Storyboard

public struct StoryboardIdentifier: IBIdentifier {
    public let name: String
    public init(name: String) { self.name = name}
}



public struct SceneIdentifier: IBIdentifier {
    public let name: String
    public init(name: String) { self.name = name}
}

public struct SegueIdentifier: IBIdentifier {
    public let name: String
    public init(name: String) { self.name = name}
}

// MARK: - NIBs
public struct NibIdentifier: IBIdentifier {
    public let name: String
    public init(name: String) { self.name = name}
}

// MARK: Cells
public struct ReuseIdentifier: IBIdentifier {
    public let name: String
    public init(name: String) { self.name = name}
}

// MARK: - Assets

public struct AssetImageIdentifier: IBIdentifier {
    public let name: String
    public init(name: String) { self.name = name}
}
public struct AssetColorIdentifier: IBIdentifier {
    public let name: String
    public init(name: String) { self.name = name}
}
public struct AssetDataIdentifier: IBIdentifier {
    public let name: String
    public init(name: String) { self.name = name}
}

public struct AssetTextureIdentifier: IBIdentifier {
    public let name: String
    public init(name: String) { self.name = name}
}

public struct AssetCubeTextureIdentifier: IBIdentifier {
    public let name: String
    public init(name: String) { self.name = name}
}
