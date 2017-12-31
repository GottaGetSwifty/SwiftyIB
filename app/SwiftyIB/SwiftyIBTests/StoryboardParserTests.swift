//
//  StoryboardParserTests.swift
//  SwiftyIBTests
//
//  Created by Paul Fechner on 12/27/17.
//  Copyright © 2017 peejweej.inc. All rights reserved.
//


@testable import SwiftyIB
import Quick
import Nimble

extension StoryboardParser {
    static var testStoryboardURL: URL? {
        let path = Bundle.main.path(forResource: "iOSTestStoryboard", ofType: "xml")!
        let url = URL(fileURLWithPath: path)
        return url
    }
    
    static var emptyStoryboardURL: URL? {
        let path = Bundle.main.path(forResource: "EmptyStoryboard", ofType: "xml")!
        let url = URL(fileURLWithPath: path)
        return url
    }
}

class StoryboardParserTests: QuickSpec {
    override func spec() {
        describe(String(describing:StoryboardParser.self)) {
            describe("handles bad URLs") {
                let parser = StoryboardParser(with: URL(string: "http://www.google.com/")!)
                it("Doesn't get data") {
                    expect(parser.loadData()).to(beNil())
                }
                it("Doesn't load xml") {
                    expect(parser.loadXML()).to(beNil())
                }
                it("Doesn't generate IBStoryboard") {
                    expect(parser.parse()).to(beNil())
                }
            }
            describe("handlesEmptyXML") {
                expect(StoryboardParser.emptyStoryboardURL).toNot(beNil())
                let parser = StoryboardParser(with: StoryboardParser.emptyStoryboardURL!)
                it("translates into data") {
                    expect(parser.loadData()).toNot(beNil())
                }
                it("Loads the xml") {
                    expect(parser.loadXML()).toNot(beNil())
                }
                it("Doesn't make IBStoryboard") {
                    expect(parser.parse()).to(beNil())
                }
                
                describe("Doesn't load when empty") {
                    let xml = parser.loadXML()!
                    it("Doesn't load IBStoryboard") {
                        let storyboard = try? IBStoryboard.deserialize(xml)
                        expect(storyboard).to(beNil())
                    }
                    it("Doesn't load IBScene") {
                        let scene = try? IBScene.deserialize(xml)
                        expect(scene).to(beNil())
                    }
                    it("Doesn't load IBViewController") {
                        let viewController = try? IBViewController.deserialize(xml)
                        expect(viewController).to(beNil())
                    }
                    it("Doesn't load IBSegue") {
                        let segue = try? IBSegue.deserialize(xml)
                        expect(segue).to(beNil())
                    }
                }
            }
            describe("loads storyboard successfully") {
                it("Loads the test storyboard") {
                    expect(StoryboardParser.testStoryboardURL).toNot(beNil())
                }
                
                let parser = StoryboardParser(with: StoryboardParser.testStoryboardURL!)
                it("translates into data") {
                    expect(parser.loadData()).toNot(beNil())
                }
                it("Loads the xml") {
                    expect(parser.loadXML()).toNot(beNil())
                }
                it("Parses IBStoryboard") {
                    expect(parser.parse()).toNot(beNil())
                }
            }
        }
    }
}
