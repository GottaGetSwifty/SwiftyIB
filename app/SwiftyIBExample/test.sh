buildscript_path=../SwiftyIB/SwiftyIBBuild.sh
generator_path=SwiftyIBGenerator
generator_file_name=SwiftyIBGenerator
generator_file_path=$generator_path/$generator_file_name
if [ -e "$generator_file_path" ]
then echo "Generator already built."
else
echo "Will build generator"
sh $buildscript_path -o $generator_path -n $generator_file_name
fi
./$generator_file_path -s SwiftyIBExample -o SwiftyIBExample/identifiers