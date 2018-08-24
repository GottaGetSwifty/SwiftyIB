///IBTypeExtensions.swift
/// Automatically generated by SwiftIB. **DO NOT EDIT**

import UIKit

/// Perform segue with identifiers and/or string representables
extension UIViewController {

    func performSegue<E: RawRepresentable>(withStringIdentifier stringIdentifier: E,
        sender: Any?) where E.RawValue == String {
        performSegue(withIdentifier: stringIdentifier.rawValue, sender: sender)
    }
    
    func performSegue(with segueIdentifier: SegueIdentifier,
        sender: Any? = nil) {
        guard segueIdentifier != .none else {
            assertionFailure("Attempted to segue to .none. This should never happen")
            return
        }
        performSegue(withStringIdentifier: segueIdentifier, sender: sender)
    }
}

/// Conversions of the segue.identifier to SegueIdentifier and/or a String RawRepresentable
extension UIStoryboardSegue {

    func getAsStringRawRepresentable<E: RawRepresentable>() -> E? where E.RawValue == String {
    
        if let identifier = self.identifier, let segueIdentifier = E(rawValue: identifier){
            return segueIdentifier
        }
        else{
            return nil
        }
    }

    func getSegueIdentifier() -> SegueIdentifier {

    if let identifier = self.identifier,
        let segueIdentifier = SegueIdentifier(rawValue: identifier){
            return segueIdentifier
        }
        else{
            return .none
        }
    }
}
        
/// Simplified Segue performance
extension IBSegue {
    func perform(sender: Any? = nil) {
        viewController.performSegue(with: segueIdentifier, sender: sender)
    }
}
        
/// Convenience properties get the identifiers from within an instance. 
extension IBScene {
    var storyboardIdentifier: StoryboardIdentifier { 
        return Self.storyboardIdentifier
    }
}

/// Convenience properties get the identifiers from within an instance.
extension SceneIdentifiable {
    var sceneIdentifier: SceneIdentifier { 
        return Self.sceneIdentifier
    }
}

//// Builds a storyboard from the storyboardIdentifier
extension StoryboardIdentifiable {
    static var storyboard: UIStoryboard {
        return storyboard(bundle: nil)
    }
    
    static func storyboard(bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(identifier: storyboardIdentifier, bundle: bundle)
    }
}

/// builds the scene from the identifiers.
extension SceneIdentifiable where Self: StoryboardIdentifiable {
    static func makeFromStoryboard<T: UIViewController>(bundle: Bundle? = nil) -> T {
        return storyboard(bundle: bundle).makeViewController(with: sceneIdentifier) as! T
    }
}

// Convenience methods for instantiating scenes/ViewControllers from identifiers
extension UIStoryboard {

    func makeViewController<T: UIViewController>(with identifier: SceneIdentifier) -> T? {
        return instantiateViewController(withIdentifier: identifier.rawValue) as? T
    }
    
    static func makeViewController<T: UIViewController>(storyboard: StoryboardIdentifier, scene: SceneIdentifier, bundle: Bundle? = nil) -> T? {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle).makeViewController(with: scene) as? T
    }
}

/// Build a storyboard from a StoryboardIdentifier
extension UIStoryboard {
    convenience init(identifier: StoryboardIdentifier, bundle: Bundle? = nil) {
        self.init(name: identifier.rawValue, bundle: bundle )
    }
}

/// Build the initialVC
extension StoryboardIdentifier {
    func makeInitialVC(bundle: Bundle? = nil) -> UIViewController {
        return UIStoryboard(identifier: self, bundle: bundle).instantiateInitialViewController()!
    }
}

/// Convenience accessor
extension SceneContainer {
    static var _Scene: SceneType.Type {
        return SceneType.self
    }
}

/// Convenience accessor/initializer 
extension SceneContainer where Self: UIViewController, Self == SceneType.ViewControllerType {
    var Scene: SceneType { return SceneType.init(_viewController: self) }
}



