//
//  FileFinder.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/31/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//

import Foundation


/// Class to find all the files of a type
class FilesFinder {
    
    /// The extension for the desired files
    let fileExtension: String
    ///The url from which to start the search
    let baseFolderURL: URL
    
    
    /// Primary initializer
    ///
    /// - Parameters:
    ///   - fileExtension: The extension for the desired files
    ///   - baseFolderURL: The url from which to start the search
    init(fileExtension: String, baseFolderURL: URL) {
        self.fileExtension = fileExtension
        self.baseFolderURL = baseFolderURL
    }
    
    
    /// Primary find method for all contained files
    ///
    /// - Returns: All URLs with the fileExtension, or nil if the baseFolderURL is not a directory
    func findAllContained() -> [URL]? {
        guard baseFolderURL.hasDirectoryPath else {
            return nil
        }
        return FilesFinder.findAllFiles(in: baseFolderURL, for: fileExtension)
    }
    
    /// Find method for only the passed directory
    ///
    /// - Returns: All URLs with the fileExtension, or nil if the baseFolderURL is not a directory
    func findOnlyInDirectory() -> [URL]? {
        guard baseFolderURL.hasDirectoryPath else {
            return nil
        }
        return FilesFinder.findFilesInSingleDir(with: baseFolderURL, for: fileExtension)
    }
    
    /// Finds the desired files in the passed directory URL
    ///
    /// - Parameters:
    ///   - url: the start for your search
    ///   - fileExtension: The file extension to find
    /// - Returns: All the URLS with files matching the passed extension
    static private func findFilesInSingleDir(with url: URL, for fileExtension: String) -> [URL] {
        guard let files = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
            return []
        }
        return files.filter { return $0.pathExtension == fileExtension }
    }
    
    /// Finds all desired files, recursively running through the dir structure from passed directory URL
    ///
    /// - Parameters:
    ///   - url: the start for your search
    ///   - fileExtension: The file extension to find
    /// - Returns: All the URLS with files matching the passed extension
    static private func findAllFiles(in url: URL, for fileExtension: String) -> [URL] {
        guard let files = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
            return []
        }
        let foundFiles = files.filter { return $0.pathExtension == fileExtension }
        
        let foundDirs = files.filter { $0.hasDirectoryPath }
        let allOtherFiles = foundDirs.flatMap { findAllFiles(in: $0, for: fileExtension) } 
        return foundFiles + allOtherFiles
    }
    
    
    /// Convenience method for finding all storyboard files
    ///
    /// - Parameter url: The url to search (should be a directory) 
    /// - Returns: An array of any found URLs, or nil if the url was not a directory 
    static func getAllStoryboardFiles(in url: URL) -> [URL]? {
        return FilesFinder(fileExtension: "storyboard", baseFolderURL: url).findAllContained()
    }
    
    /// Convenience method for finding all nib files
    ///
    /// - Parameter url: The url to search (should be a directory) 
    /// - Returns: An array of any found URLs, or nil if the url was not a directory
    static func getAllNibFiles(in url: URL) -> [URL]? {
        return FilesFinder(fileExtension: "xib", baseFolderURL: url).findAllContained()
    }
}
