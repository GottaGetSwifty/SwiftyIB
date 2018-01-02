//
//  main.swift
//  SwiftyIBTool
//
//  Created by Paul Fechner on 12/29/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//


import Foundation

enum CommandLineOption: String {
    case source = "-source"
    case destination = "-destination"
    case absolute = "-absolute"

    case unknown
    
    init(value: String?) {
        guard let value = value else {
            self = .unknown
            return
        }
        switch value {
        case CommandLineOption.source.rawValue, "-s", "-S": 
            self = .source
        case CommandLineOption.destination.rawValue, "-d", "-D": 
            self = .destination
        case CommandLineOption.absolute.rawValue, "-a":
            self = .absolute
        default: self = .unknown
        }
    }
}

struct LaunchOptions {
    let source: URL
    let destination: URL
    let isAbsoluteURL: Bool
    
    static func makeFromArguments() -> LaunchOptions? {
        guard CommandLine.argc >= 5, CommandLineOption(value: CommandLine.arguments[1]) == .source, CommandLineOption(value: CommandLine.arguments[3]) == .destination else {
            return nil
        }
        var usesAbsoluteURL = false
        var relativeURL: URL? = nil
        if CommandLine.argc > 5 {
            usesAbsoluteURL = CommandLineOption(value: CommandLine.arguments[5]) == .absolute
        }
        if usesAbsoluteURL {
            relativeURL = URL(string: FileManager.default.currentDirectoryPath)
        }
        let sourceURL = URL(fileURLWithPath: CommandLine.arguments[2], isDirectory: true, relativeTo: relativeURL)
        let destinationURL = URL(fileURLWithPath: CommandLine.arguments[4], isDirectory: true, relativeTo: relativeURL)
        return LaunchOptions(source: sourceURL, destination: destinationURL, isAbsoluteURL: usesAbsoluteURL)
    }
}

func exportIBInfo(with launchOptions: LaunchOptions) {
    print("Launched successfully with\nsource: \(launchOptions.source)\ndestination: \(launchOptions.destination)")
    guard let foundStoryboards = SwiftyIB(containingURL: launchOptions.source)?.buildStoryboards() else {
        print("Did not find/parse storboards")
        return
    }
    do {
        print("Found and parsed storboards, will attempt exporting")
        try StoryboardExporter.export(storboards: foundStoryboards, to: launchOptions.destination, absoluteURL: launchOptions.isAbsoluteURL)
    }
    catch let e {
        print(e.localizedDescription)
    }

}

guard let launchOptions = LaunchOptions.makeFromArguments() else {
    print("Incorrect arguments")
    exit(1)
}
exportIBInfo(with: launchOptions)




