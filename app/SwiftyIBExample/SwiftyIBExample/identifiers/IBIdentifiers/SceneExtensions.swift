/// Automatically generated from SwiftyIB        
        
extension SecondViewController {
            
    var scenes: _Scenes { return _Scenes(viewController: self) }
    struct _Scenes {
            
        fileprivate let viewController: SecondViewController            
        
        var SecondVC: _SecondVC { return _SecondVC(viewController: viewController) }
        struct _SecondVC: IBScene {
            fileprivate let viewController: SecondViewController
            static let storyboardIdentifier: StoryboardIdentifier = .SecondMain
            static let sceneIdentifier: SceneIdentifier = .SecondVC        
        
            var Segues: _Segues { return _Segues(viewController: viewController) }
            struct _Segues {
                fileprivate let viewController: SecondViewController        
                var GoToDetail: IBSegue { return IBSegue(identifier: .GoToDetail, viewController: viewController)}
            }     
        }
    
        var currentScene: _SecondVC { return SecondVC }        
    }
}
                
        
extension ViewController {
            
    var scenes: _Scenes { return _Scenes(viewController: self) }
    struct _Scenes {
            
        fileprivate let viewController: ViewController                    
            var SecondMainSecondMainVCScene: _SecondMainSecondMainVCScene { return _SecondMainSecondMainVCScene(viewController: viewController) }
            struct _SecondMainSecondMainVCScene: IBScene {
                fileprivate let viewController: ViewController
                static let storyboardIdentifier: StoryboardIdentifier = .SecondMain
                static let sceneIdentifier: SceneIdentifier = .SecondMainVCScene        
        
            var Segues: _Segues { return _Segues(viewController: viewController) }
            struct _Segues {
                fileprivate let viewController: ViewController        
                var ViewControllerSegue: IBSegue { return IBSegue(identifier: .ViewControllerSegue, viewController: viewController)}
            }     
                }            
            var SecondMainEmbededVC: _SecondMainEmbededVC { return _SecondMainEmbededVC(viewController: viewController) }
            struct _SecondMainEmbededVC: IBScene {
                fileprivate let viewController: ViewController
                static let storyboardIdentifier: StoryboardIdentifier = .SecondMain
                static let sceneIdentifier: SceneIdentifier = .EmbededVC     
                }            
            var MainMainVCScene: _MainMainVCScene { return _MainMainVCScene(viewController: viewController) }
            struct _MainMainVCScene: IBScene {
                fileprivate let viewController: ViewController
                static let storyboardIdentifier: StoryboardIdentifier = .Main
                static let sceneIdentifier: SceneIdentifier = .MainVCScene        
        
            var Segues: _Segues { return _Segues(viewController: viewController) }
            struct _Segues {
                fileprivate let viewController: ViewController        
                var ViewControllerSegue: IBSegue { return IBSegue(identifier: .ViewControllerSegue, viewController: viewController)}
            }     
                }            
            var MainEmbededVC: _MainEmbededVC { return _MainEmbededVC(viewController: viewController) }
            struct _MainEmbededVC: IBScene {
                fileprivate let viewController: ViewController
                static let storyboardIdentifier: StoryboardIdentifier = .Main
                static let sceneIdentifier: SceneIdentifier = .EmbededVC     
                } 
        
        var scenes: [IBScene] { return [SecondMainSecondMainVCScene, SecondMainEmbededVC, MainMainVCScene, MainEmbededVC, ] }
        
        var currentSceneFromRestorationID: IBScene? {
            guard let restorationID = viewController.restorationIdentifier else {
                return nil
            }
            return scenes.first {$0.sceneIdentifier.rawValue == restorationID}
        }        
    }
}
        