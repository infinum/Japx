//
//  DecoderTester.swift
//  JSONAPIParser_Example
//
//  Created by Vlaho Poluta on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import JSONAPIParser

class DecoderTesterSpec: QuickSpec {
    
    override func spec() {
        
        describe("Testing simple json api decoding") {
            
            it("Parses json api exmple (http://jsonapi.org/examples/) - Article person") {
                let correctlyParsed = does(jsonFromFileNamed: "ArticlePerson-JsonApi", containsEverethingFrom: "ArticlePerson-Json") {
                    return try! JSONAPIParser.Decoder.jsonObject(with: $0)
                }
                expect(correctlyParsed) == true
            }
        }
        
        describe("Testing json api with includes decoding") {
            
            it("Should succesfouly parse recursiv sample with include list") {
                let includeList = "author.article.author"
                let correctlyParsed = does(jsonFromFileNamed: "RecursivSample-JsonApi", containsEverethingFrom: "RecursivSample-Json") {
                    return try! JSONAPIParser.Decoder.jsonObject(with: $0, includeList: includeList)
                }
                expect(correctlyParsed) == true
            }
            
        }
        
    }
}
