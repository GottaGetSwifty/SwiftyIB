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

class StoryboardParserTests: QuickSpec {
    override func spec() {
        describe("StoryboardParserTests") {
            describe("loads storyboard successfully") {
                it("Loads the test storyboard") {
                    expect(StoryboardParser.getTestStoryboard()).toNot(beNil())
                }
                
                let parser = StoryboardParser(with: StoryboardParser.getTestStoryboard()!)
                it("translates into data") {
                    expect(parser.loadData()).toNot(beNil())
                }
                it("Loads the xml") {
                    expect(parser.loadXML()).toNot(beNil())
                }
                it("Parses Storyboard") {
                    expect(parser.parse()).toNot(beNil())
                }
            }
        }
    }
}
