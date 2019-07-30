//
//  DecoderTester.swift
//  Japx_Example
//
//  Created by Vlaho Poluta on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Japx

class DecoderTesterSpec: QuickSpec {
    
    override func spec() {
        
        describe("Testing simple json api decoding") {
            
            it("Parses json api exmple (http://jsonapi.org/examples/) - Article person") {
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "ArticlePerson-JsonApi", containsEverethingFrom: "ArticlePerson-Json") {
                    return try! Japx.Decoder.jsonObject(with: $0)
                }
                expect(correctlyParsed) == true
            }
            
            it("Parses json api exmple (http://jsonapi.org/examples/) - Missing reloationship") {
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "MissingRelationship-JsonApi", containsEverethingFrom: "MissingRelationship-Json") {
                    return try! Japx.Decoder.jsonObject(with: $0)
                }
                expect(correctlyParsed) == true
            }
            
            it("Parses json api intro exmple (http://jsonapi.org/) - Article example") {
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "ArticleExample-JsonApi", containsEverethingFrom: "ArticleExample-Json") {
                    return try! Japx.Decoder.jsonObject(with: $0)
                }
                expect(correctlyParsed) == true
            }
        }
        
        describe("Testing json api with includes decoding") {
            
            it("Should succesfully parse recursiv sample with include list") {
                let includeList = "author.article.author"
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "RecursivSample-JsonApi", containsEverethingFrom: "RecursivSample-Json") {
                    return try! Japx.Decoder.jsonObject(with: $0, includeList: includeList)
                }
                expect(correctlyParsed) == true
            }
            
        }
        
        describe("Testing json api with empty relationship list") {
            
            it("Should succesfully parse recursive sample with empty relationship list") {
                let includeList = "author.article.author,author.categories"
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "EmptyRelationship-JsonApi", containsEverethingFrom: "EmptyRelationship-Json") {
                    return try! Japx.Decoder.jsonObject(with: $0, includeList: includeList)
                }
                expect(correctlyParsed) == true
            }
            
            it("Should succesfully parse recursive sample with empty relationship list - deep") {
                let includeList = "author.article.author.categories,author.categories"
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "EmptyRelationship-JsonApi", containsEverethingFrom: "EmptyRelationshipDeep-Json") {
                    return try! Japx.Decoder.jsonObject(with: $0, includeList: includeList)
                }
                expect(correctlyParsed) == true
            }
            
            it("Should succesfully parse recursive sample with missing relationship include object") {
                let includeList = "author.article.author,author.categories"
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "RelationshipNoInclude-JsonApi", containsEverethingFrom: "RelationshipNoInclude-Json") {
                    return try! Japx.Decoder.jsonObject(with: $0, includeList: includeList)
                }
                expect(correctlyParsed) == true
            }
        }

    }
}
