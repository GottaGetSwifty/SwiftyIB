//
//  main.swift
//  SwiftyIBTool
//
//  Created by Paul Fechner on 12/29/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//


import Foundation

enum CommandLineOption: String {
    case directory = "-directory"
    case absolute = "-absolute"

    case unknown
    
    init(value: String?) {
        guard let value = value else {
            self = .unknown
            return
        }
        switch value {
        case CommandLineOption.directory.rawValue, "-d": 
            self = .directory
        case CommandLineOption.absolute.rawValue, "-a":
            self = .absolute
        default: self = .unknown
        }
    }
}

struct LaunchOptions {
    let directory: URL
    let absoluteURL: Bool
    
    static func makeFromArguments() -> LaunchOptions? {
        guard CommandLine.argc >= 3, CommandLineOption(value: CommandLine.arguments[1]) == .directory else {
            return nil
        }
        var usesAbsoluteURL = false
        var relativeURL: URL? = nil
        if CommandLine.argc > 3 {
            usesAbsoluteURL = CommandLineOption(value: CommandLine.arguments[3]) == .absolute
        }
        if usesAbsoluteURL {
            relativeURL = URL(string: FileManager.default.currentDirectoryPath)
        }
        let url = URL(fileURLWithPath: CommandLine.arguments[2], isDirectory: true, relativeTo: relativeURL)
        
        return LaunchOptions(directory: url, absoluteURL: usesAbsoluteURL)
    }
}

func findAllStorboards(from url: URL) {
    guard let foundStoryboards = SwiftyIB(containingURL: url)?.buildStoryboards() else {
        return
    }
    let storyboardEnum = StoryboardConverter.makeStoryboardNameEnum(from: foundStoryboards)
    let scenesEnum = StoryboardConverter.makeSceneNameEnum(from: foundStoryboards)
    let seguesEnum = StoryboardConverter.makeSegueNameEnum(from: foundStoryboards)
    print("storboards:\n\n\(storyboardEnum!)\n")
    print("scenes:\n\n\(scenesEnum!)\n")
    print("segue:\n\n\(seguesEnum!)\n")
}

guard let launchOptions = LaunchOptions.makeFromArguments() else {
    print("Please add your .xcodeproj path using the argument -xcodeProject flag")
    exit(1)
}
findAllStorboards(from: launchOptions.directory)




