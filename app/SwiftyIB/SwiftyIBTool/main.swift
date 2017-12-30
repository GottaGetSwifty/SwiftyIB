//
//  main.swift
//  SwiftyIBTool
//
//  Created by Paul Fechner on 12/29/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//


import Foundation

enum CommandLineOption: String {
    case xcodeProject = "-xcodeProject"

    case unknown
    
    init(value: String?) {
        guard let value = value else {
            self = .unknown
            return
        }
        switch value {
        case CommandLineOption.xcodeProject.rawValue, "-xcp": 
            self = .xcodeProject
        default: self = .unknown
        }
    }
}


guard CommandLine.argc > 2 else {
    print("Please add your .xcodeproj path using the argument -xcodeProject flag")
    exit(1)
}
let firstArgument = CommandLine.arguments[1]

let option = CommandLineOption(value: firstArgument)
switch option {
    case .xcodeProject:
        print("xcode project Arugment was:\(CommandLine.arguments[2])")
        exit(0)
    default:
        print("Please add your .xcodeproj path using the argument -xcodeProject flag")
        exit(1)
}


