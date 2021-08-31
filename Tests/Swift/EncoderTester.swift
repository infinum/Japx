//
//  EncoderTester.swift
//  Japx_Example
//
//  Created by Vlaho Poluta on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Japx
import XCTest

class EncoderTests: XCTestCase {

    func testJSONAPIEncoding_SimpleEncoding() throws {
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "SimpleEncoding-Json", containsEverythingFrom: "SimpleEncoding-JsonApi") {
            return try! JapxKit.Encoder.encode(data: $0)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Transforms simple JSON to JSON:API"
        )
    }

    func testJSONAPIEncoding_RecursiveRelationships() throws {
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "RecursiveRelationships-Json", containsEverythingFrom: "RecursiveRelationships-JsonApi") {
            return try! JapxKit.Encoder.encode(data: $0)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Transforms JSON to JSON:API with recursive relationships"
        )
    }

    func testJSONAPIEncoding_ExtraParameters() throws {
        let extraParams: Parameters = ["links": ["self": "http://example.com/articles"]]
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "ExtraParams-Json", containsEverythingFrom: "ExtraParams-JsonApi") {
            return try! JapxKit.Encoder.encode(data: $0, additionalParams: extraParams)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Transforms JSON to JSON:API and adds extra params - Article person"
        )
    }

    func testJSONAPIEncoding_MetaIncluded() throws {
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "Meta-Json", containsEverythingFrom: "Meta-Added-JsonApi") {
            return try! JapxKit.Encoder.encode(data: $0, options: .init(includeMetaToCommonNamespce: true))
        }
        XCTAssertTrue(
            correctlyParsed,
            "Transforms JSON to JSON:API while including meta"
        )
    }

    func testJSONAPIEncoding_MetaNotIncluded() throws {
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "Meta-Json", containsEverythingFrom: "Meta-NotAdded-JsonApi") {
            return try! JapxKit.Encoder.encode(data: $0)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Transforms JSON to JSON:API without including meta"
        )
    }

    func testJSONAPIEncodingRelationshipList_NoList() throws {
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "RelationshipList-Json", containsEverythingFrom: "RelationshipList-Not-Relationship-JsonApi") {
            return try! JapxKit.Encoder.encode(data: $0)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Should auto infer relationships without the list"
        )
    }

    func testJSONAPIEncodingRelationshipList_ListAvailable() throws {
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "RelationshipList-Json", containsEverythingFrom: "RelationshipList-Not-Relationship-JsonApi") {
            return try! JapxKit.Encoder.encode(data: $0, options: .init(relationshipList: "author"))
        }
        XCTAssertTrue(
            correctlyParsed,
            "Should decode likes as attributes"
        )
    }

    func testJSONAPIEncodingRelationshipList_ListEmpty() throws {
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "RelationshipList-Json", containsEverythingFrom: "RelationshipList-Broken-JsonApi") {
            return try! JapxKit.Encoder.encode(data: $0, options: .init(relationshipList: ""))
        }
        XCTAssertTrue(
            correctlyParsed,
            "Should decode likes and author as attributes"
        )
    }

    func testJSONAPIEncodingRelationshipList_ListWithMoreThanOneParam() throws {
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "RelationshipList-Json", containsEverythingFrom: "RelationshipList-Is-Relationship-JsonApi") {
            return try! JapxKit.Encoder.encode(data: $0, options: .init(relationshipList: "author,likes"))
        }
        XCTAssertTrue(
            correctlyParsed,
            "Should decode likes as relationships"
        )
    }


}
