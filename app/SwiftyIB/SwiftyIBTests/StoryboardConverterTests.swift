//
//  StoryboardConverter.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/29/17.
//Copyright © 2017 peejweej.inc. All rights reserved.
//
@testable import SwiftyIB

import Quick
import Nimble

class StoryboardConverterTests: QuickSpec {
    
    static let expectedStoryboardResult =   """
                                            enum \(StoryboardConverter.storyboardEnumName): String {
                                            \tcase iOSTestStoryboard
                                            }
                                            """
    
    static let expectedSceneResult =    """
                                        enum \(StoryboardConverter.scenesEnumName): String {
                                        \tcase ViewControllerasd
                                        }
                                        """
    
    static let expectedSegueResult =    """
                                        enum \(StoryboardConverter.segueEnumName): String {
                                        \tcase TestSegueID
                                        }
                                        """
    
    override func spec() {
        describe(String(describing:StoryboardConverter.self)) {
            describe("Creates enums") {

                let storyboard = StoryboardParser(with: StoryboardParser.testStoryboardURL!).parse()!
                it("For storyboards") {
                    let result = StoryboardConverter.makeStoryboardNameEnum(from: [storyboard])
                    expect(result).toNot(beNil())
                    expect(result).to(equal(StoryboardConverterTests.expectedStoryboardResult))
                }
                
                it("For scenes") {
                    let result = StoryboardConverter.makeSceneNameEnum(from: [storyboard])
                    expect(result).toNot(beNil())
                    expect(result).to(equal(StoryboardConverterTests.expectedSceneResult))
                }
                it("For Segues") {
                    let result = StoryboardConverter.makeSegueNameEnum(from: [storyboard])
                    expect(result).toNot(beNil())
                    expect(result).to(equal(StoryboardConverterTests.expectedSegueResult))
                }
            }
            describe("Handles bad input") {
                expect(StoryboardConverter.makeStoryboardNameEnum(from: [])).to(beNil())
                expect(StoryboardConverter.makeSceneNameEnum(from: [])).to(beNil())
                expect(StoryboardConverter.makeSegueNameEnum(from: [])).to(beNil())
            }
        }
    }
}
