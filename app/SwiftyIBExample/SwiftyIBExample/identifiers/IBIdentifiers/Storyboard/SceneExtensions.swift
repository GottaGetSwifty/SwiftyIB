/// Automatically generated from SwiftyIB
import UIKit           
        
private protocol SecondViewControllerSceneContainer: SceneContainer { }
        
extension SecondViewController: SecondViewControllerSceneContainer {             
    typealias SceneType = SecondViewControllerScene
    struct SecondViewControllerScene: IBScene {
        init(_viewController: SecondViewController) { self._viewController = _viewController }
        fileprivate let _viewController: SecondViewController
        var viewController: UIViewController { return _viewController }
        static let storyboardIdentifier: StoryboardIdentifier = .SecondMain
        static let sceneIdentifier: SceneIdentifier = .SecondVC        
        
        var Segues: _Segues { return _Segues(_viewController: _viewController) }
        struct _Segues {
            fileprivate let _viewController: SecondViewController
            var viewController: UIViewController { return _viewController }    
            var GoToDetail: IBSegue { return IBSegue(segueIdentifier: .GoToDetail, viewController: viewController)}
        }     
    }
}           
        
extension ViewController {        
    var Scenes: _Scenes { return _Scenes(_viewController: self) }
    struct _Scenes {
    
        fileprivate let _viewController: ViewController
        var viewController: UIViewController { return _viewController }
                    
        var SecondMainSecondMainVCScene: _SecondMainSecondMainVCScene { return _SecondMainSecondMainVCScene(_viewController: _viewController) }
        struct _SecondMainSecondMainVCScene: IBScene {
            init(_viewController: ViewController) { self._viewController = _viewController }
            fileprivate let _viewController: ViewController
            var viewController: UIViewController { return _viewController }
            static let storyboardIdentifier: StoryboardIdentifier = .SecondMain
            static let sceneIdentifier: SceneIdentifier = .SecondMainVCScene        

            var Segues: _Segues { return _Segues(_viewController: _viewController) }
            struct _Segues {
                fileprivate let _viewController: ViewController
                var viewController: UIViewController { return _viewController }        
                var ViewControllerSegue: IBSegue { return IBSegue(segueIdentifier: .ViewControllerSegue, viewController: viewController)}        
                var EmbeddedVC: IBSegue { return IBSegue(segueIdentifier: .EmbeddedVC, viewController: viewController)}
            }     
        }
                
        var SecondMainEmbededVC: _SecondMainEmbededVC { return _SecondMainEmbededVC(_viewController: _viewController) }
        struct _SecondMainEmbededVC: IBScene {
            init(_viewController: ViewController) { self._viewController = _viewController }
            fileprivate let _viewController: ViewController
            var viewController: UIViewController { return _viewController }
            static let storyboardIdentifier: StoryboardIdentifier = .SecondMain
            static let sceneIdentifier: SceneIdentifier = .EmbededVC     
        }
                
        var MainMainVCScene: _MainMainVCScene { return _MainMainVCScene(_viewController: _viewController) }
        struct _MainMainVCScene: IBScene {
            init(_viewController: ViewController) { self._viewController = _viewController }
            fileprivate let _viewController: ViewController
            var viewController: UIViewController { return _viewController }
            static let storyboardIdentifier: StoryboardIdentifier = .Main
            static let sceneIdentifier: SceneIdentifier = .MainVCScene        

            var Segues: _Segues { return _Segues(_viewController: _viewController) }
            struct _Segues {
                fileprivate let _viewController: ViewController
                var viewController: UIViewController { return _viewController }        
                var ViewControllerSegue: IBSegue { return IBSegue(segueIdentifier: .ViewControllerSegue, viewController: viewController)}        
                var EmbeddedVC: IBSegue { return IBSegue(segueIdentifier: .EmbeddedVC, viewController: viewController)}
            }     
        }
                
        var MainEmbededVC: _MainEmbededVC { return _MainEmbededVC(_viewController: _viewController) }
        struct _MainEmbededVC: IBScene {
            init(_viewController: ViewController) { self._viewController = _viewController }
            fileprivate let _viewController: ViewController
            var viewController: UIViewController { return _viewController }
            static let storyboardIdentifier: StoryboardIdentifier = .Main
            static let sceneIdentifier: SceneIdentifier = .EmbededVC     
        }
     
        
        var scenes: [AnyIBScene] { return [SecondMainSecondMainVCScene, SecondMainEmbededVC, MainMainVCScene, MainEmbededVC, ] }
        
        var currentSceneFromRestorationID: AnyIBScene? {
            guard let restorationID = viewController.restorationIdentifier else {
                return nil
            }
            return scenes.first { $0.sceneIdentifier.rawValue == restorationID }
        }
    }
}           
        
private protocol ChildSecondViewControllerSceneContainer: SceneContainer { }
        
extension ChildSecondViewController: ChildSecondViewControllerSceneContainer {             
    typealias SceneType = ChildSecondViewControllerScene
    struct ChildSecondViewControllerScene: IBScene {
        init(_viewController: ChildSecondViewController) { self._viewController = _viewController }
        fileprivate let _viewController: ChildSecondViewController
        var viewController: UIViewController { return _viewController }
        static let storyboardIdentifier: StoryboardIdentifier = .SecondMain
        static let sceneIdentifier: SceneIdentifier = .ChildSecondViewController        
        
        var Segues: _Segues { return _Segues(_viewController: _viewController) }
        struct _Segues {
            fileprivate let _viewController: ChildSecondViewController
            var viewController: UIViewController { return _viewController }    
            var GoToDetail: IBSegue { return IBSegue(segueIdentifier: .GoToDetail, viewController: viewController)}
        }     
    }
}