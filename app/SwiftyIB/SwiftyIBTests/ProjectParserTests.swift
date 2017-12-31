//
//  ProjectParserTests.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/31/17.
//Copyright © 2017 peejweej.inc. All rights reserved.
//
@testable import SwiftyIB

import Quick
import Nimble

extension ProjectParser {
    static var testProjectURL: URL? {
        let path = Bundle.main.path(forResource: "TestProject", ofType: "txt")!
        let url = URL(fileURLWithPath: path)
        return url
    }
    
    static var emptyFileURL: URL? {
        let path = Bundle.main.path(forResource: "EmptyFile", ofType: "txt")!
        let url = URL(fileURLWithPath: path)
        return url
    }
}

class ProjectParserTests: QuickSpec {
    override func spec() {
        
        describe(String(describing:ProjectParser.self)) {
            
            describe("handles bad URLs") {
                let junkURLString = "http://www.google.com/"
                let parser = ProjectParser(with: URL(string: junkURLString)!)
                it("Doesn't get data") {
                    expect(parser.loadData()).to(beNil())
                }
                it("Doesn't load text") {
                    expect(parser.loadProjectText()).to(beNil())
                }
            }
            describe("handlesEmptyFile") {
                expect(ProjectParser.emptyFileURL).toNot(beNil())
                let parser = ProjectParser(with: ProjectParser.emptyFileURL!)
                it("translates into data") {
                    expect(parser.loadData()).toNot(beNil())
                }
                it("Doesn't make IBStoryboard") {
                    expect(parser.loadProjectText()).toNot(beNil())
                }
                
                describe("Doesn't load when empty") {
                    
                    it("Doesn't load StoryboardNames") {
                        let storyboards = parser.getStoryboardNames()
                        expect(storyboards).to(beEmpty())
//                    }
//                    it("Doesn't load IBScene") {
//                        let scene = try? IBScene.deserialize(xml)
//                        expect(scene).to(beNil())
//                    }
//                    it("Doesn't load IBViewController") {
//                        let viewController = try? IBViewController.deserialize(xml)
//                        expect(viewController).to(beNil())
//                    }
//                    it("Doesn't load IBSegue") {
//                        let segue = try? IBSegue.deserialize(xml)
//                        expect(segue).to(beNil())
                    }
                }
            }
            describe("loads storyboard successfully") {
                expect(ProjectParser.testProjectURL).toNot(beNil())
                
                let parser = ProjectParser(with: ProjectParser.testProjectURL!)
                it("translates into data") {
                    expect(parser.loadData()).toNot(beNil())
                }
                it("Loads the file") {
                    expect(parser.loadProjectText()).toNot(beNil())
                }
                it("Loads Storyboards") {
                    expect(parser.getStoryboardNames()).toNot(beEmpty())
                }
//                it("Parses IBStoryboard") {
//                    expect(parser.parse()).toNot(beNil())
//                }
            }
        }
    }
}
