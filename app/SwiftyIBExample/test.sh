package_name=SwiftyIBExample
echo $package_name
build_dir=`xcodebuild -project $package_name.xcodeproj -showBuildSettings | grep -m 1 "BUILD_DIR" | grep -oEi "\/.*"`
echo $build_dir
data_dir=$build_dir/../..
echo $data_dir
swift_ib_dir=$data_dir/SourcePackages/checkouts/SwiftyIB
echo $swift_ib_dir
# vars for building the generator. Should only be used if the full project is available to build.
buildscript_path=$swift_ib_dir/app/SwiftyIB/SwiftyIBBuild.sh



buildscript_path=$swift_ib_dir/app/SwiftyIB/SwiftyIBBuild.sh
echo $buildscript_path
generator_path=SwiftyIBGenerator
generator_file_name=SwiftyIBGenerator
generator_file_path=$generator_path/$generator_file_name
# if [ -e "$generator_file_path" ]
# then echo "Generator already built."
# else
# echo "Will build generator"
sh $buildscript_path -o $generator_path -n $generator_file_name
# fi
#./$generator_file_path -s SwiftyIBExample -o SwiftyIBExample/identifiers