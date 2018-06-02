/// Automatically generated from SwiftyIB
import UIKit        
        
extension SecondViewController {
                        
    var Scene: _Scene { return _Scene(_viewController: self) }
    struct _Scene: IBScene {
        
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
        
            fileprivate let _viewController: ViewController
            var viewController: UIViewController { return _viewController }
            static let storyboardIdentifier: StoryboardIdentifier = .SecondMain
            static let sceneIdentifier: SceneIdentifier = .SecondMainVCScene        

            var Segues: _Segues { return _Segues(_viewController: _viewController) }
            struct _Segues {
                fileprivate let _viewController: ViewController
                var viewController: UIViewController { return _viewController }        
                var ViewControllerSegue: IBSegue { return IBSegue(segueIdentifier: .ViewControllerSegue, viewController: viewController)}
            }     
        }
                
        var SecondMainEmbededVC: _SecondMainEmbededVC { return _SecondMainEmbededVC(_viewController: _viewController) }
        struct _SecondMainEmbededVC: IBScene {
        
            fileprivate let _viewController: ViewController
            var viewController: UIViewController { return _viewController }
            static let storyboardIdentifier: StoryboardIdentifier = .SecondMain
            static let sceneIdentifier: SceneIdentifier = .EmbededVC     
        }
                
        var MainMainVCScene: _MainMainVCScene { return _MainMainVCScene(_viewController: _viewController) }
        struct _MainMainVCScene: IBScene {
        
            fileprivate let _viewController: ViewController
            var viewController: UIViewController { return _viewController }
            static let storyboardIdentifier: StoryboardIdentifier = .Main
            static let sceneIdentifier: SceneIdentifier = .MainVCScene        

            var Segues: _Segues { return _Segues(_viewController: _viewController) }
            struct _Segues {
                fileprivate let _viewController: ViewController
                var viewController: UIViewController { return _viewController }        
                var ViewControllerSegue: IBSegue { return IBSegue(segueIdentifier: .ViewControllerSegue, viewController: viewController)}
            }     
        }
                
        var MainEmbededVC: _MainEmbededVC { return _MainEmbededVC(_viewController: _viewController) }
        struct _MainEmbededVC: IBScene {
        
            fileprivate let _viewController: ViewController
            var viewController: UIViewController { return _viewController }
            static let storyboardIdentifier: StoryboardIdentifier = .Main
            static let sceneIdentifier: SceneIdentifier = .EmbededVC     
        }
     
        
        var scenes: [IBScene] { return [SecondMainSecondMainVCScene, SecondMainEmbededVC, MainMainVCScene, MainEmbededVC, ] }
        
        var currentSceneFromRestorationID: IBScene? {
            guard let restorationID = viewController.restorationIdentifier else {
                return nil
            }
            return scenes.first { $0.sceneIdentifier.rawValue == restorationID }
        }
    }        
}
        