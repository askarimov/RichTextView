//
//  StringExtensionSpec.swift
//  RichTextView
//
//  Created by Ahmed Elkady on 2018-11-19.
//  Copyright © 2018 Top Hat. All rights reserved.
//

import Quick
import Nimble

@testable import RichTextView

class StringExtensionSpec: QuickSpec {
    override func spec() {
        describe("String Extension") {
            context("Get Substring In Between Tags") {
                it("gets string between two tags if it exists") {
                    let input = "[math]x^n[/math]"
                    let output = input.getSubstring(inBetween: "[math]", and: "[/math]")
                    expect(output).to(equal("x^n"))
                }
                it("returns nil if only the beginning tag exists") {
                    let input = "[math]x^n"
                    let output = input.getSubstring(inBetween: "[math]", and: "[/math]")
                    expect(output).to(beNil())
                }
                it("returns nil if only the end tag exists") {
                    let input = "x^n[/math]"
                    let output = input.getSubstring(inBetween: "[math]", and: "[/math]")
                    expect(output).to(beNil())
                }
                it("returns nil if one of the tags is an empty string") {
                    let input = "[math]x^n"
                    let output = input.getSubstring(inBetween: "[math]", and: "")
                    expect(output).to(beNil())
                }
            }
            context("Get Components Separated by Regex") {
                it("returns components correctly split if regex is in middle of string") {
                    let input = "Test youtube[123] wow"
                    let output = input.getComponents(separatedBy: RichTextViewConstants.videoTagRegex)
                    expect(output).to(equal(["Test ", "youtube[123]", " wow"]))
                }
                it("returns components correctly split if regex is in beginning of string") {
                    let input = "youtube[123] wow"
                    let output = input.getComponents(separatedBy: RichTextViewConstants.videoTagRegex)
                    expect(output).to(equal(["youtube[123]", " wow"]))
                }
                it("returns components correctly split if regex is in end of string") {
                    let input = "Test youtube[123]"
                    let output = input.getComponents(separatedBy: RichTextViewConstants.videoTagRegex)
                    expect(output).to(equal(["Test ", "youtube[123]"]))
                }
                it("returns entire string in array if regex to split does not exist") {
                    let input = "Test wow"
                    let output = input.getComponents(separatedBy: RichTextViewConstants.videoTagRegex)
                    expect(output).to(equal(["Test wow"]))
                }
            }
            context("Split") {
                it ("splits a string at the correct position") {
                    let initialString = "Text to be split"
                    let index = initialString.index(initialString.startIndex, offsetBy: 5)
                    let splitStrings = initialString.split(atPositions: [index])
                    expect(splitStrings.count).to(equal(2))
                    expect(splitStrings[0]).to(equal("Text "))
                    expect(splitStrings[1]).to(equal("to be split"))
                }
                it ("splits a string at the correct positions") {
                    let initialString = "Text to be split"
                    let indexes = [initialString.index(initialString.startIndex, offsetBy: 5),
                                   initialString.index(initialString.startIndex, offsetBy: 8),
                                   initialString.index(initialString.startIndex, offsetBy: 11)]
                    let splitStrings = initialString.split(atPositions: indexes)
                    expect(splitStrings.count).to(equal(4))
                    expect(splitStrings[0]).to(equal("Text "))
                    expect(splitStrings[1]).to(equal("to "))
                    expect(splitStrings[2]).to(equal("be "))
                    expect(splitStrings[3]).to(equal("split"))
                }
            }
            context("Ranges") {
                it("returns the ranges of given text") {
                    let initialString = "<p>Some text<p>"
                    let ranges = initialString.ranges(of: "<p>")
                    expect(ranges.count).to(equal(2))
                    expect(ranges[0].lowerBound.utf16Offset(in: initialString)).to(equal(0))
                    expect(ranges[0].upperBound.utf16Offset(in: initialString)).to(equal(3))
                    expect(ranges[1].lowerBound.utf16Offset(in: initialString)).to(equal(12))
                    expect(ranges[1].upperBound.utf16Offset(in: initialString)).to(equal(15))
                }
                it("returns the ranges of given text as a regular expression") {
                    let initialString = "[math]Some text[/math] different text [math]more text[/math]"
                    let ranges = initialString.ranges(of: "\\[math\\](.*?)\\[\\/math\\]", options: .regularExpression)
                    expect(ranges.count).to(equal(2))
                    expect(ranges[0].lowerBound.utf16Offset(in: initialString)).to(equal(0))
                    expect(ranges[0].upperBound.utf16Offset(in: initialString)).to(equal(22))
                    expect(ranges[1].lowerBound.utf16Offset(in: initialString)).to(equal(38))
                    expect(ranges[1].upperBound.utf16Offset(in: initialString)).to(equal(60))
                }
                it("returns the ranges of given text with multiple interactive elements.") {
                    let initialString = """
                        [interactive-element id=1]Some interactive element text[/interactive-element] different text
                        [interactive-element id=1]more interactive element text[/interactive-element]
                    """
                    let ranges = initialString.ranges(of: "\\[interactive-element\\sid=.+?\\].*?\\[\\/interactive-element\\]", options: .regularExpression)
                    expect(ranges.count).to(equal(2))
                    expect(ranges[0].lowerBound.utf16Offset(in: initialString)).to(equal(4))
                    expect(ranges[0].upperBound.utf16Offset(in: initialString)).to(equal(81))
                    expect(ranges[1].lowerBound.utf16Offset(in: initialString)).to(equal(101))
                    expect(ranges[1].upperBound.utf16Offset(in: initialString)).to(equal(178))
                }
            }
            context("Subscripts") {
                it("correctly subscripts a closed range of type Int") {
                    let initialString = "Wow I love RichTextView!"
                    let substring = initialString[1...3]
                    expect(substring).to(equal("ow "))
                }
                it("correctly subscripts an open range of type Int") {
                    let initialString = "Wow I love RichTextView!"
                    let substring = initialString[5..<8]
                    expect(substring).to(equal(" lo"))
                }
                it("correctly subscripts when it is just a single Int") {
                    let initialString = "Wow I love RichTextView!"
                    let substring = initialString[6]
                    expect(substring).to(equal("l"))
                }
            }
        }
    }
}
