///IBTypeExtensions.swift
/// Automatically generated by SwiftIB. **DO NOT EDIT**

import Foundation
#if canImport(UIKit)
import UIKit


// MARK: - UIViewController

/// Perform segue with identifiers and/or string representables
extension UIViewController {

    public func perform(segue segueIdentifier: SegueIdentifier,
        sender: Any? = nil) {
        guard segueIdentifier != .none else {
            assertionFailure("Attempted to segue to .none, this should never happen!")
            return
        }
        performSegue(withIdentifier: segueIdentifier.name, sender: sender)
    }
}

// MARK: - Segues

/// Conversions of the segue.identifier to SegueIdentifier and/or a String RawRepresentable
extension UIStoryboardSegue {

    public func getSegueIdentifier() -> SegueIdentifier {

        if let identifier = self.identifier {
            return SegueIdentifier(name: identifier)
        }
        else{
            return .none
        }
    }
}

/// Simplified Segue performance
extension IBSegue {
    public func perform(sender: Any? = nil) {
        viewController.perform(segue: segueIdentifier, sender: sender)
    }
}

// MARK: - Storyboards

//// Builds a storyboard from the storyboardIdentifier
extension StoryboardIdentifiable {
    static public func storyboard(bundle: Bundle? = nil) -> UIStoryboard? {
        return UIStoryboard.make(with: storyboardIdentifier, in: bundle)
    }
}

// Convenience methods for instantiating scenes/ViewControllers from identifiers
extension UIStoryboard: IBIdentifierMakeable {

    func makeViewController<T: UIViewController>(with name: SceneIdentifier) -> T? {
        return instantiateViewController(withIdentifier: name.name) as? T
    }

    public static func make(with identifier: StoryboardIdentifier, in bundle: Bundle?) -> Self? {
        Self(name: identifier.name, bundle: bundle)
    }

    public static func makeViewController<T: UIViewController>(storyboard: StoryboardIdentifier, scene: SceneIdentifier, bundle: Bundle? = nil) -> T? {
        make(with: storyboard, in: bundle)?.makeViewController(with: scene) as? T
    }
}


//MARK: - Scene

/// builds the scene from the identifiers.
extension SceneIdentifiable where Self: StoryboardIdentifiable {
    public static func makeFromStoryboard<T: UIViewController>(bundle: Bundle? = nil) -> T {
        return storyboard(bundle: bundle)?.makeViewController(with: sceneIdentifier) as! T
    }
}

/// Convenience accessor
extension SceneContainer {
    public static var _Scene: SceneType.Type {
        return SceneType.self
    }
}

/// Convenience accessor/initializer
extension SceneContainer where Self: UIViewController, Self == SceneType.ViewControllerType {
    public var Scene: SceneType { return SceneType.init(_viewController: self) }
}

#endif