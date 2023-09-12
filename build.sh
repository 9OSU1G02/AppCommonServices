#!/usr/bin/env bash
# 1
xcodebuild archive -scheme AppCommonServices \
-configuration Release \
-archivePath "AppCommonServices.xcarchive"

# 2
xcodebuild -exportArchive \
-archivePath "AppCommonServices.xcarchive" \
-exportOptionsPlist "ExportOptions.plist" \
-exportPath .