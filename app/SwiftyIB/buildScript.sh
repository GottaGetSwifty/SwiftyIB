
ArchiveDir="archive"
ArchiveExtension=".xcarchive"
ToolDir=$ArchiveDir$ArchiveExtension"/Products/usr/local/bin/SwiftyIBTool"
FinalFileDir="SwiftyIBToolRunnable"
echo $ToolDir

xcodebuild -scheme SwiftyIBTool archive -archivePath $ArchiveDir
cp $ToolDir $FinalFileDir
rm -r $ArchiveDir$ArchiveExtension
