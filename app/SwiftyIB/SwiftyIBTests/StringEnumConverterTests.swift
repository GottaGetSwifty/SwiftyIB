//
//  StringEnumConverterTests.swift
//  SwiftyIB
//
//  Created by Paul Fechner on 12/29/17.
//Copyright © 2017 peejweej.inc. All rights reserved.
//
@testable import SwiftyIB

import Quick
import Nimble

class StringEnumConverterTests: QuickSpec {
    
    static let testName = "TestEnumName"
    static let testCases = ["FirstCase", "Second Case", "ThirdCase"]
    
    static let expectedResult = """
                                enum \(testName): String {
                                \tcase \(testCases[0])
                                \tcase \(testCases[1])
                                \tcase \(testCases[2])
                                }
                                """
    
    override func spec() {
        describe(String(describing:StringEnumConverter.self)) {
            describe("Converts strings propperly") {
                let result = StringEnumConverter.makeEnum(with: StringEnumConverterTests.testName, from: StringEnumConverterTests.testCases)
                expect(result).to(equal(StringEnumConverterTests.expectedResult))
            }
            describe("Handles bad input") {
                expect(StringEnumConverter.makeEnum(with: "", from: [])).to(beNil())
            }
        }
    }
}
