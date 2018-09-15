//
//  ProjectParser.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/30/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//


/**************************************************
 * NOT CURRENTLY USED.
 * The project structure is annoyingly complex and not worth building a parser just for this.
 * If we can find an existing parser, we should use that.
 **************************************************/
import Foundation
class ProjectParser {
    
    static let filesRegex = " Begin PBXFileReference section (.|\\s)* End PBXFileReference section "
    static let storyboardRegex = try! NSRegularExpression(pattern:" (\\w*).storyboard")
    let projectPath: URL
    
    init(with projectPath: URL) {
        self.projectPath = projectPath
    }
    
    func loadData() -> Data? {
        let data = try? Data(contentsOf: projectPath, options: Data.ReadingOptions.uncached)
        return data
    }
    
    func loadProjectText() -> String? {
        return try? String(contentsOf: projectPath)
    }
    
    func getStoryboardNames() -> [String] {
        guard let projectText = loadProjectText() else {
            return []
        }
        if let startRange = projectText.range(of: "/* Begin PBXFileReference section */"), let endRange = projectText.range(of: "/* End PBXFileReference section */") {
            let upperIndex = projectText.index(after: startRange.upperBound)
            let lowerIndex = projectText.index(before: endRange.lowerBound)
            let foundString = String(projectText[upperIndex..<lowerIndex])
            let storyboardNames = ProjectParser.storyboardRegex.stringMatches(in: foundString, range: NSRange(foundString.startIndex..., in: foundString))
            return storyboardNames
        }
        
        
//        let matches = ProjectParser.resourcesRegex.stringMatches(in: projectText, range: NSRange(projectText.startIndex..., in: projectText))

        return []
    }
}

extension NSRegularExpression {
    func stringMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange) -> [String] {
        let foundMatches = matches(in: string, options: options, range: range)
        let results = foundMatches.map { (result) -> String in
            let lower = string.index(string.startIndex, offsetBy: result.range.lowerBound)
            let upper = string.index(string.startIndex, offsetBy: result.range.upperBound)
            return String(string[lower...upper])
        }
        return results
    }

}
