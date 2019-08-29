//
//  Exporter.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 9/15/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//

import Foundation

public class Exporter {
    static func exportFile(fileText: String, to url: URL, isAbsoluteURL: Bool) -> Bool {
        let filePath = isAbsoluteURL ? url.deletingLastPathComponent().absoluteString : url.deletingLastPathComponent().relativeString 
        do {
            if !FileManager.default.fileExists(atPath: filePath) {
                try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            }
            try fileText.write(to: url, atomically: true, encoding: .utf8)
            return true
        }
        catch let e {
            print(e.localizedDescription)
            return false
        }
    }
}
