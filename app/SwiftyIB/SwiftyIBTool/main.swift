//
//  main.swift
//  SwiftyIBTool
//
//  Created by Paul Fechner on 12/29/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//


import Foundation

enum CommandLineOption: String {
    case help = "--help"
    case source = "--source"
    case destination = "--output-dir"
    case absolute = "--absolute"

    case unknown
    
    init(value: String?) {
        guard let value = value else {
            self = .unknown
            return
        }
        switch value {
        case CommandLineOption.source.rawValue, "-s", "-S": 
            self = .source
        case CommandLineOption.destination.rawValue, "-o", "-O": 
            self = .destination
        case CommandLineOption.absolute.rawValue, "-a", "-A":
            self = .absolute
        case CommandLineOption.help.rawValue, "-h", "-H":
            self = .help
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
            case .unknown: return ""
            }
        }
    }
    
    static let allValues: [CommandLineOption] = [.help, .source, .destination, .absolute, .unknown] 
}

struct LaunchOptions {
    let source: URL
    let destination: URL
    let isAbsoluteURL: Bool
    let isHelp: Bool
    
    static func makeFromArguments() -> LaunchOptions? {
        var source: String? = nil
        var destination: String? = nil
        var isAbsoluteURL = false
        var isHelp = false
        var i = 1
        while  i < CommandLine.argc { 
            let argument = CommandLine.arguments[i]
            let option = CommandLineOption(value: argument)
            switch(option) {
            case .source: i += 1; source = CommandLine.arguments[i]
            case .destination: i += 1; destination = CommandLine.arguments[i]
            case .absolute: isAbsoluteURL = true
            case .help: isHelp = true
            default: return nil
            }
            i += 1
        }
        if isHelp {
            return LaunchOptions(source: URL(string: CommandLine.arguments[0])!, destination: URL(string: CommandLine.arguments[0])!, isAbsoluteURL: false, isHelp: true)
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
        return LaunchOptions(source: sourceURL, destination: destinationURL, isAbsoluteURL: isAbsoluteURL, isHelp: isHelp)
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

if(launchOptions.isHelp) {
    let helpString = """
        Swift IB Tool is a command line tool that generates Type safe code from Interface Builder files.

        Usage:
        """
    print(helpString)
    CommandLineOption.allValues.forEach{print("\($0.explanationText)")}

    exit(0)
}

exportIBInfo(with: launchOptions)




