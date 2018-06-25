

archive_directory="archive"
archive_extension=".xcarchive"
tool_dir=$archive_directory$archive_extension"/Products/usr/local/bin/SwiftyIBTool"
output_dir=false
output_file_name="SwiftyIB"


BASEDIR=$(dirname "$0")

while test $# -gt 0; do
        case "$1" in
                -h|--help)
                        echo "Builds and exports SwiftyIB"
                        echo " "
                        echo "Example usage:"
                        echo "SwiftyIBExport.sh -o ../project/files -n SwiftyIB"
                        echo " "
                        echo "options:"
                        echo "-h, --help                        show brief help"
                        echo "-o, --output-dir=DIR              The directory where the generated executable should be sent"
                        echo "-n, --file-name=NAME              An optional file name "
                        echo "-v, --version                     Returns the current info.plist version number of SwiftyIBTool"
                        exit 0
                        ;;
                -v|--version)

                        cd $BASEDIR
                        buildPlist=SwiftyIBTool/Info.plist
                        CFBundleShortVersionString=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $buildPlist)
                        echo $CFBundleShortVersionString
                        exit 0
                        cd - 
                        ;;
                -o|--output-dir)
                        shift
                        if test $# -gt 0; then
                                output_dir=$1
                                echo "Output directory: $output_dir
                            "
                        else
                                echo "Output directory required for operation. Execute with -h for usage information"
                                exit 1
                        fi
                        shift
                        ;;
                -n|--file-name)
                        shift
                        if test $# -gt 0; then
                                output_file_name=$1
                                echo "Output name: $output_file_name"
                        fi
                        shift
                        ;;
                *)
                        break
                        ;;
        esac
done

if [ "$output_dir" = false ] ; then
    echo "Incorrect arguments. Run with -h to see usage information."
    exit 3
fi

filepath=$output_dir/$output_file_name
cd $BASEDIR
xcodebuild -scheme SwiftyIBTool archive -archivePath $archive_directory
cd -
mkdir -p $output_dir
cp $BASEDIR/$tool_dir $filepath
rm -r $BASEDIR/$archive_directory$archive_extension


