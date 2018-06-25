//
//  main.swift
//  SwiftyIBTool
//
//  Created by Paul Fechner on 12/29/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//


import Foundation


let VERSION_NUMBER = 1
enum CommandLineOption: String {
    case help = "--help"
    case source = "--source"
    case destination = "--output-dir"
    case absolute = "--absolute"
    case version = "--version"
    case unknown
    
    init(value: String?) {
        guard let value = value else {
            self = .unknown
            return
        }
        switch value {
        case CommandLineOption.source.rawValue, "--Source", "-s", "-S": 
            self = .source
        case CommandLineOption.destination.rawValue, "--Output-dir", "--Output-Dir", "-o", "-O": 
            self = .destination
        case CommandLineOption.absolute.rawValue, "--Absolute", "-a", "-A":
            self = .absolute
        case CommandLineOption.help.rawValue, "--Help", "-h", "-H":
            self = .help
        case CommandLineOption.version.rawValue, "--Version", "-v", "-V":
            self = .version
        default: self = .unknown
        }
    }
    
    var explanationText: String {
        get {
            switch self {
            case .help:         return "help:          (--help, -h, -H)           Instructions"
            case .source:       return "source:        (--source, -s, -S          The Source directory to recursively search for all IB files"
            case .destination:  return "output dir:    (--output-dir, o, O)       Output directory to put the generated files." 
            case .absolute:     return "absolute:      (--absolute, -a, -A        Boolean flag to indicate whether the passed URLs are absolute."
            case .version:      return "version:       (--version, -v, -V)        If passed, will return the version and end"
            case .unknown: return ""
            }
        }
    }
    
    static let allValues: [CommandLineOption] = [.help, .source, .destination, .absolute, .version, .unknown] 
}

struct LaunchOptions {
    let source: URL
    let destination: URL
    let isAbsoluteURL: Bool
    let isHelp: Bool
    let isVersion: Bool
    
    static func makeFromArguments() -> LaunchOptions? {
        var source: String? = nil
        var destination: String? = nil
        var isAbsoluteURL = false
        var isHelp = false
        var isVersion = false
        var i = 1
        while  i < CommandLine.argc { 
            let argument = CommandLine.arguments[i]
            let option = CommandLineOption(value: argument)
            switch(option) {
            case .source: i += 1; source = CommandLine.arguments[i]
            case .destination: i += 1; destination = CommandLine.arguments[i]
            case .absolute: isAbsoluteURL = true
            case .help: isHelp = true
            case .version: isVersion = true
            default: return nil
            }
            i += 1
        }
        if isHelp || isVersion {
            // We don't want to run, so we only need values for isHelp and isVersion
            return LaunchOptions(source: URL(string: CommandLine.arguments[0])!, destination: URL(string: CommandLine.arguments[0])!, isAbsoluteURL: false, isHelp: isHelp, isVersion: isVersion)
        }
        
        guard let realSource = source, let realDestination = destination else {
            return nil
        }
        
        var relativeURL: URL? = nil
        if isAbsoluteURL {
            relativeURL = URL(string: FileManager.default.currentDirectoryPath)
        }
        let sourceURL = URL(fileURLWithPath: realSource, isDirectory: true, relativeTo: relativeURL)
        let destinationURL = URL(fileURLWithPath: realDestination, isDirectory: true, relativeTo: relativeURL)
        return LaunchOptions(source: sourceURL, destination: destinationURL, isAbsoluteURL: isAbsoluteURL, isHelp: isHelp, isVersion: isVersion)
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
        try SwiftyIB.export(storboards: foundStoryboards, to: launchOptions.destination, isAbsoluteURL: launchOptions.isAbsoluteURL)
    }
    catch let e {
        print(e.localizedDescription)
    }
}

guard let launchOptions = LaunchOptions.makeFromArguments() else {
    print("Incorrect arguments")
    exit(1)
}

if launchOptions.isHelp || launchOptions.isVersion {
    if(launchOptions.isHelp) {
        let helpString = """
        Swift IB Tool is a command line tool that generates Type safe code from Interface Builder files.

        Usage:
        """
        print(helpString)
        CommandLineOption.allValues.forEach{print("\($0.explanationText)")}
    }
    if launchOptions.isVersion {
        print((Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "No Version Found");
    }

    exit(0)
}

exportIBInfo(with: launchOptions)




