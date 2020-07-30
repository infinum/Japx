//
//  EncoderTester.swift
//  Japx_Example
//
//  Created by Vlaho Poluta on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Japx

class EncoderTesterSpec: QuickSpec {
    
    override func spec() {
        
        describe("Testing json to json:api encoding") {
            
            it("Transforms simple json to json:api - Simple encoding") {
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "SimpleEncoding-Json", containsEverethingFrom: "SimpleEncoding-JsonApi") {
                    return try! Japx.Encoder.encode(data: $0)
                }
                expect(correctlyParsed) == true
            }
            
            it("Transforms json to json:api with recursiv relationships - Recursiv relationships") {
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "RecursivRelationships-Json", containsEverethingFrom: "RecursivRelationships-JsonApi") {
                    return try! Japx.Encoder.encode(data: $0)
                }
                expect(correctlyParsed) == true
            }
            
            it("Transforms json to json:api and adds extra params - Article person") {
                let extraParams: Parameters = ["links": ["self": "http://example.com/articles"]]
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "ExtraParams-Json", containsEverethingFrom: "ExtraParams-JsonApi") {
                    return try! Japx.Encoder.encode(data: $0, additionalParams: extraParams)
                }
                expect(correctlyParsed) == true
            }
        }
        
        describe("Testing inclusion of meta") {
            
            it("Transforms json to json:api with while including meta") {
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "Meta-Json", containsEverethingFrom: "Meta-Added-JsonApi") {
                    return try! Japx.Encoder.encode(data: $0, options: .init(includeMetaToCommonNamespce: true))
                }
                expect(correctlyParsed) == true
            }
            
            it("Transforms json to json:api while not including meta") {
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "Meta-Json", containsEverethingFrom: "Meta-NotAdded-JsonApi") {
                    return try! Japx.Encoder.encode(data: $0)
                }
                expect(correctlyParsed) == true
            }
            
        }
        
        describe("Testing relationship list") {
         
            it("Should auto infer relationships without the list") {
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "RelationshipList-Json", containsEverethingFrom: "RelationshipList-Not-Relationship-JsonApi") {
                    return try! Japx.Encoder.encode(data: $0)
                }
                expect(correctlyParsed) == true
            }
            
            it("Should decode likes as attributes") {
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "RelationshipList-Json", containsEverethingFrom: "RelationshipList-Not-Relationship-JsonApi") {
                    return try! Japx.Encoder.encode(data: $0, options: .init(relationshipList: "author"))
                }
                expect(correctlyParsed) == true
            }
            
            it("Should decode likes and author as attributes") {
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "RelationshipList-Json", containsEverethingFrom: "RelationshipList-Broken-JsonApi") {
                    return try! Japx.Encoder.encode(data: $0, options: .init(relationshipList: ""))
                }
                expect(correctlyParsed) == true
            }
            
            it("Should decode likes as relationships") {
                let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "RelationshipList-Json", containsEverethingFrom: "RelationshipList-Is-Relationship-JsonApi") {
                    return try! Japx.Encoder.encode(data: $0, options: .init(relationshipList: "author,likes"))
                }
                expect(correctlyParsed) == true
            }
        }
    }
}
