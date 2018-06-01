# SwiftyIB

A tool that builds a declarative, protocol-oriented structure that greatly simplifies the usage of InterfaceBuilder, and forces (most) run-time InterfaceBuilder failures into compile-time failures

## What it generates

### enum  Identifiers

The tool generates String-backed enums that match the file names and identifiers:

```
enum StoryboardIdentifier: String {
	case LaunchScreen
	case MainScreen
	case DetailScreen
	case none
}

enum SceneIdentifier: String {
	case CollectionVC
	case EmbededVC
	case MainVCScene
	case SecondMainVCScene
	case SecondVC
	case SplitChildVC
	case SplitNav
	case SplitNavTable
	case SplitVC
	case TableVC
	case none
}

enum SegueIdentifier: String {
	case GoToDetail
	case ViewControllerSegue
	case none
}
````

### Typed Extensions

The tool builds a structure to Typed-elements from Interface Builder to give compile-time guarentees for scene/storyboard information as well as well as segues:

```
extension SecondViewController {
            
    var Scenes: _Scenes { return _Scenes(_viewController: self) }
    struct _Scenes {
            
        fileprivate let _viewController: SecondViewController
        var viewController: UIViewController { return _viewController }            
        
        var SecondVC: _SecondVC { return _SecondVC(_viewController: _viewController) }
        struct _SecondVC: IBScene {
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
    
        var currentScene: _SecondVC { return SecondVC }        
    }
}
```

The used approach gives the available access from both a static/class context, as well as an instance context. The static identifiers are always available, but the Segues are only available from within an instance of the ViewController subclass.

```
// works
SecondViewController._Scenes._SecondVC.storyboardIdentifier

// works through an extension
secondViewControllerInstance.Scenes.SecondVC.storyboardIdentifier

// Doesn't work. Segues aren't usable from a static context
SecondViewController._Scenes._SecondVC._Segues.GoToDetail

// works
secondViewControllerInstance.Scenes.SecondVC.Segues.GoToDetail
```

Although it's not recommended (as it reduces the compile-time guarentees), ViewControllers used im multiple scenes will be generated with the additional scenes.

```
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
        
        
        var scenes: [IBScene] { return [SecondMainSecondMainVCScene, SecondMainEmbededVC] }
        
        var currentSceneFromRestorationID: IBScene? {
            guard let restorationID = viewController.restorationIdentifier else {
                return nil
            }
            return scenes.first {$0.sceneIdentifier.rawValue == restorationID}
        }        
    }
}
```

`currentSceneFromRestorationID` can be used to dynamically guess the correct Scene for the current viewController instance. To use this, ensure the Scene's `Restoration ID` matches the `Storyboard ID`, or check `Use Storyboard ID`

### Extensability 
To make things easily extendable, we use a set of protocols and Types:

```
protocol IBScene: StoryboardIdentifiable, SceneIdentifiable { }

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: StoryboardIdentifier { get }   
    var viewController: UIViewController { get }
}

protocol SceneIdentifiable {
    static var sceneIdentifier: SceneIdentifier { get }
    var viewController: UIViewController { get }
}

protocol SegueIdentifiable {
    var segueIdentifier: SegueIdentifier { get }
    var viewController: UIViewController { get }
}

struct IBSegue: SegueIdentifiable {
    let segueIdentifier: SegueIdentifier
    let viewController: UIViewController
}
````

### Built in Extensions

There are a lot of possibilities depending on the usage and setup, but that should/will be separated into it's own separate framework. For now there are some automatically generated ones. 

A few examples:

```

// Easily make the initial viewController for a storyboard
let initialVC = StoryboardIdentifier.Main.makeInitialVC()

// Build ViewControllers programatically with no hassel.
let secondViewController = SecondViewController._Scenes._SecondVC.makeFromStoryboard()

// Easily perform a segue WITH code completion! 
func startDetailScreen() {
    Scenes.SecondVC.Segues.GoToDetail.perform()
}

// Easily get the segue identifier in prepare(for segue:)
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.getSegueIdentifier() {
    case .GoToDetail: //do what you gotta do
    default: break
    }
}

```

