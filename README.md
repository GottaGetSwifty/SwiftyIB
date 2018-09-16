# SwiftyIB

Generate a static, protocol-oriented structure to greatly simplify the usage of InterfaceBuilder, and turn (most) run-time failures from InterfaceBuilder into compile-time failures.


## Usage

Once everything's setup, all this functionality should be enabled for free.

### Segues
Before

```
func goToNextScreen() {
    performSegue(withIdentifier: "MySegueID", sender: nil)
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
        return
    }
    switch identifier {
    case "MySegueIdentifier:
        guard let destination = segue.destination as? MyNextViewController else {
            return
        }
        //Set up your new screen, assuming the identifier ACTUALLY matches
    default:
        break
    }
    
```
After 

```
func goToNextScreen() {
    performSegue(with: .MyNextSegue)
}

// or

func goToNextScreen() {
    Scene.Segues.MyNextSegue.perform()
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.getSegueIdentifier() {
        case Scene.Segues.MyNextSegue.segueIdentifier:
            //You can be sure this is the right Segue now, and you'll get a build error if you change the segue ID
        default:
            break
        }
    }
```


### Storyboard finding and creation
Before

```
func buildInitialVC() -> UIViewController? {
    return UIStoryboard(name: "hopefullyRealStoryboardName", bundle: nil).instantiateInitialViewController()
}

func buildMyVC() -> MyRealViewControllerClass? {
    return UIStoryboard(name: "hopefullyRealStoryboardName", bundle: nil).instantiateViewController(withIdentifier: "HopefullyRightIdentifier") as? MyRealViewControllerClass
}
    
```
After 

```
func buildInitialVC() -> UIViewController? {
    return StoryboardIdentifier.MyRealStoryboardName.makeInitialVC()
}

func buildMyVC() -> MyRealViewControllerClass {
    return MyRealViewControllerClass._Scene.makeFromStoryboard()
}

```

### Cell management
Before

```
func registerCells() {
    tableView.register(UINib(nibName: "hopefulyRealNibName", bundle: nil), forCellReuseIdentifier: "HopefullyRightReuseIdentifier")
    tableView.register(UINib(nibName: "hopefulyRealNibName", bundle: nil), forHeaderFooterViewReuseIdentifier: "HopefullyRightReuseIdentifier")
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HopefullyRealIdentifier", for: indexPath)
    // Might not have worked, no way to guarentee the class of the Cell
}

override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HopefullyRightIdentifier")
    //Hopefully this worked. No way to tell till you run it.
}
```
After 

```
func registerCells() {
    tableView.register(cellType: ActualCellClass.self)
    tableView.register(viewType: ActualHeaderFooterClass.self)
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    guard let cell: RealCellClass = tableView.dequeueTyped(with: .RealCellClass, for: indexPath)  as? else {
        return UITableViewCell()
    }
    // Not only is this cleaner, but now if the class name or identifier changes, you'll get a compile error
}

override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let view: ActualHeaderFooterClass = tableView.dequeueTypedHeaderFooter(for: ActualHeaderFooterClass.self) else {
        return nil
    }
    // Now if the class name or identifier changes, you'll get a compile error
}
```

### Assets 
Before

```

func setupView() {
    let image = UIImage(named: "HopefullyRealName")
    let color = UIColor(named: "HopefullyRealName")
}
    
```
After 

```
func setupView() {
    let image = UIImage(identifier: .realImageIdentifier)
    let color = UIColor(identifier: .realColorIdentifier)
}
```

## Getting Started

See the SwiftyIBExample project to see how the tooling is generally intended to work. (More tooling info at the bottom of the page)

The best way to get thigns setup is to have the SwiftyIB project in a sub-folder if your project. (ideally as a git-submodule)

Then, in your project, add a `run script` build phase _before_ `compile sources` with this script:

```
#!/bin/bash

echo "Will run SwiftyIB"
# Path variables

# Build script from SwiftyIB. This is used in case we need to re-build the parser
buildscript_path=../../SubModules/SwiftyIB/app/SwiftyIB/SwiftyIBBuild.sh

generator_path=SwiftyIBGenerator # The export path for the executable parser
generator_file_name=SwiftyIBGenerator # The name to use for the executable parser
generator_file_path=$generator_path/$generator_file_name # Full path for the parser

IB_search_directory=MyTestApp/AllFiles # The directory from which the parse will start the recursive search
IB_files_export_path=MyTestApp/SwiftyIBGenerated # The path to export the generated files to add to your project
# Ideally the above variables are the only things that will need to be changed for a given project.

# Uncomment the following line to remove the generator and fully rebuild it from source.
#rm -r $generator_file_path
if ! [ -e "$generator_file_path" ]; then

# Builds the generater executable. Should not be necessary every build.
echo "Will build generator"
sh $buildscript_path -o $generator_path -n $generator_file_name

fi

#This section checks if there is a new version available since the executable was built.

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

# This is the line that actually generates the files.
./$generator_file_path -s $IB_search_directory -o $IB_files_export_path
```

 After the first build, simply add the files/folders to your project located in the `IB_files_export_path`. Subsequent builds should update the files automatically and automatically update the generater if the SwiftyIB project has been updated with a new version.

Anecdotally the generation is pretty fast. (~20 milliseconds for a simple storyboard on a 3 year old MBP). The goal is to keep this fast enough to run during every build, which is why an executable is used.

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

* Type-safe view controllers in Segues.
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

