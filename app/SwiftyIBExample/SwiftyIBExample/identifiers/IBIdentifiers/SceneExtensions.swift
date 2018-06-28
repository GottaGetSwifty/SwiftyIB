/// Automatically generated from SwiftyIB
import UIKit        
        
extension AssetGroupsViewController {
                        
    var Scene: _Scene { return _Scene(_viewController: self) }
    struct _Scene: IBScene {
        
        fileprivate let _viewController: AssetGroupsViewController
        var viewController: UIViewController { return _viewController }
        static let storyboardIdentifier: StoryboardIdentifier = .Assets
        static let sceneIdentifier: SceneIdentifier = .AssetGroupsViewController        
        
        var Segues: _Segues { return _Segues(_viewController: _viewController) }
        struct _Segues {
            fileprivate let _viewController: AssetGroupsViewController
            var viewController: UIViewController { return _viewController }    
            var AssetGroupsCollectionViewController: IBSegue { return IBSegue(segueIdentifier: .AssetGroupsCollectionViewController, viewController: viewController)}
        }     
    }        
}
                
        
extension AssetsSplitViewController {
                        
    var Scene: _Scene { return _Scene(_viewController: self) }
    struct _Scene: IBScene {
        
        fileprivate let _viewController: AssetsSplitViewController
        var viewController: UIViewController { return _viewController }
        static let storyboardIdentifier: StoryboardIdentifier = .Assets
        static let sceneIdentifier: SceneIdentifier = .SplitView     
    }        
}
                
        
extension AssetViewerViewController {
                        
    var Scene: _Scene { return _Scene(_viewController: self) }
    struct _Scene: IBScene {
        
        fileprivate let _viewController: AssetViewerViewController
        var viewController: UIViewController { return _viewController }
        static let storyboardIdentifier: StoryboardIdentifier = .Assets
        static let sceneIdentifier: SceneIdentifier = .AssetViewerViewController     
    }        
}
                
        
extension FileListViewController {
                    
}
                
        
extension AssetGroupsCollectionViewController {
                        
    var Scene: _Scene { return _Scene(_viewController: self) }
    struct _Scene: IBScene {
        
        fileprivate let _viewController: AssetGroupsCollectionViewController
        var viewController: UIViewController { return _viewController }
        static let storyboardIdentifier: StoryboardIdentifier = .Assets
        static let sceneIdentifier: SceneIdentifier = .AssetGroupsCollectionViewController        
        
        var Segues: _Segues { return _Segues(_viewController: _viewController) }
        struct _Segues {
            fileprivate let _viewController: AssetGroupsCollectionViewController
            var viewController: UIViewController { return _viewController }    
            var AssetsSplitVC: IBSegue { return IBSegue(segueIdentifier: .AssetsSplitVC, viewController: viewController)}
        }     
    }        
}
                
        
extension MainTabBarController {
                        
    var Scene: _Scene { return _Scene(_viewController: self) }
    struct _Scene: IBScene {
        
        fileprivate let _viewController: MainTabBarController
        var viewController: UIViewController { return _viewController }
        static let storyboardIdentifier: StoryboardIdentifier = .MainScreen
        static let sceneIdentifier: SceneIdentifier = .MainTabBarController     
    }        
}
                
        
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
                var EmbeddedVC: IBSegue { return IBSegue(segueIdentifier: .EmbeddedVC, viewController: viewController)}
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
                var EmbeddedVC: IBSegue { return IBSegue(segueIdentifier: .EmbeddedVC, viewController: viewController)}
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
                
        
extension PDFAssetViewController {
                        
    var Scene: _Scene { return _Scene(_viewController: self) }
    struct _Scene: IBScene {
        
        fileprivate let _viewController: PDFAssetViewController
        var viewController: UIViewController { return _viewController }
        static let storyboardIdentifier: StoryboardIdentifier = .Assets
        static let sceneIdentifier: SceneIdentifier = .PDFAssetViewController     
    }        
}
        