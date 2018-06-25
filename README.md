# SwiftyIB

Generate a static, protocol-oriented structure to greatly simplify the usage of InterfaceBuilder, and turn (most) run-time failures from InterfaceBuilder into compile-time failures.


## Usage
A few quick examples:

```

// Easily make the initial viewController for a storyboard
let initialVC = StoryboardIdentifier.Main.makeInitialVC()

// Build ViewControllers programatically with no hassel.
let secondViewController = SecondViewController._Scene.makeFromStoryboard()

// Easily perform a segue WITH code completion! 
func startDetailScreen() {
    Scenes.GoToDetail.perform()
}

// Easily get the segue identifier in prepare(for segue:)
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.getSegueIdentifier() {
    case .GoToDetail: break //do what you gotta do
    default: break
    }
}

```

## Getting Started

See the SwiftyIBExample project to see how the tooling is generally intended to work. (More tooling info at the bottom of the page)

The quickest way to get going is to download the executable.
https://github.com/PeeJWeeJ/SwiftyIB/blob/master/app/SwiftyIBExample/SwiftyIBGenerator/SwiftyIBGenerator

And in your project, add a `run script` build phase _before_ `compile sources` with this script:

```
#!/bin/bash

# vars for building the generator. Should only be used if the full project is available to build.
buildscript_path=../SwiftyIB/SwiftyIBBuild.sh
generator_path=SwiftyIBGenerator
generator_file_name=SwiftyIBGenerator
generator_file_path=$generator_path/$generator_file_name

#vars for generation
IB_search_directory=SwiftyIBExample # This directory is searched recurssively for all IB files. 
IB_files_export_path=SwiftyIBExample/identifiers

#Uncomment to remove the generator and rebuild it from source
#rm -r $generator_file_path
if ! [ -e "$generator_file_path" ]; then

#Builds the generator. This should only happen once. Delete the generator if you want to re-build
echo "Will build generator"
sh $buildscript_path -o $generator_path -n $generator_file_name

fi

latest_version="$(sh $buildscript_path -v)"
build_version="$(./$generator_file_path -v)"

echo "latest version: $(echo $latest_version)"
echo "build version: $(echo $build_version)"

function version { printf "%03d%03d%03d%03d" $(echo "$1" | tr '.' ' '); }

if [ "$(version "$latest_version")" -gt "$(version "$build_version")" ]; then
echo "There is an updated version, so will rebuild"
sh $buildscript_path -o $generator_path -n $generator_file_name

else
echo "Generator already built. and updated"
fi


# This should be the only line that runs every time.
./$generator_file_path -s $IB_search_directory -o $IB_files_export_path
```

 After the first build, simply add the files to your project located in the `IB_files_export_path`. Subsequent builds should update the files automatically.

Anecdotally the generation is pretty fast. (~20 milliseconds for a simple storyboard on a 3 year old MBP). The goal is to keep it fast enough to run during every build.

## Nerdy details / what's actually generated

See the example project to see full examples of what is generated and available.

### enum  Identifiers

String-backed enums that match the file names and identifiers:

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

A Typed structur to generated from Interface Builder to give compile-time guarentees for scene/storyboard information and segues:

```
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
```

This structure gives propper access from both a static/class context and an instance context. The static identifiers are always available, but the Segues are only available from within an instance of the ViewController subclass.

```
// works
SecondViewController._Scene.storyboardIdentifier

// works through an extension
secondViewControllerInstance.Scene.storyboardIdentifier

// Doesn't work. Segues aren't usable from a static context
SecondViewController._Scene.storyboardIdentifier

// works
secondViewControllerInstance.Scene.Segues.GoToDetail
```

Although it's not recommended (reduces the compile-time guarentees), ViewControllers used in multiple scenes will be generated with the additional scenes.

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

## Extensability 
### Types
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
```

### Built in Extensions

For now the included extensions are focussed around simplifying creation and navigation. More complex structures and integrations should be optional and only added piecemeal or through other external frameworks.


## Planned Improvements

* `xib` parsing and generation. This should be pretty simple, but was less of a priority compared to storyboards.
* `UITableViewCell` and `UICollectionViewCell` parsing and generation. Make working with cell registring as easy and Type safe as possible
* Type-safe view controllers in Segues.
* Look into adding support for strings and colors. Although not a stability issue, it's the other most annoying thing about Interface Builder. It's possible this should be it's own project.
* Improved tooling. Once everything's set up it works well, but any setup process beyond a few clicks is annyoing.
* The IB parser could be moved to it's own project/framework for easy re-use for other things.

## Even nerdier details

https://github.com/drmohundro/SWXMLHash is used to parse the IB files and generate a Typed structure. This _should_ be done in a way that's easily maintainable and extendable.

The current intended tooling is focussed on project build-time performance and project integration simplicity. The example project can be used as a guide. Since we are using a basic executable, the recommended approach is to have the actual project (preferable as a git-submodule) available to an application project so the executable can be built and run locally with 100% code transparency.

### Current build process:

A `run script` is added to the project as a build phase before the files are compiled.

If the generator executable exists, it runs the generator with the input/output directories and then exits.

Otherwise it first runs the SwiftyIBBuild.sh script located in the SwiftIB project.

This script builds the SwiftIBTool project and copies the executable to the provided path.

