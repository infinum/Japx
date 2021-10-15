//
//  DecoderTester.swift
//  Japx_Example
//
//  Created by Vlaho Poluta on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Japx
import XCTest

class DecoderTests: XCTestCase {

    func testSimpleJSONAPIDecoding_ArticlePerson() throws {
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "ArticlePerson-JsonApi", containsEverythingFrom: "ArticlePerson-Json") {
            return try! JapxKit.Decoder.jsonObject(with: $0)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Parses JSON:API Example (http://jsonapi.org/examples/) - Article person"
        )
    }

    func testSimpleJSONAPIDecoding_MissingRelationship() throws {
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "MissingRelationship-JsonApi", containsEverythingFrom: "MissingRelationship-Json") {
            return try! JapxKit.Decoder.jsonObject(with: $0)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Parses JSON:API Example (http://jsonapi.org/examples/) - Missing relationship"
        )
    }

    func testSimpleJSONAPIDecoding_ArticleExample() throws {
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "ArticleExample-JsonApi", containsEverythingFrom: "ArticleExample-Json") {
            return try! JapxKit.Decoder.jsonObject(with: $0)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Parses JSON:API Example (http://jsonapi.org/) - Article example"
        )
    }

    func testJSONAPIDecodingWithIncludeList_RecursiveSample() throws {
        let includeList = "author.article.author"
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "RecursiveSample-JsonApi", containsEverythingFrom: "RecursiveSample-Json") {
            return try! JapxKit.Decoder.jsonObject(with: $0, includeList: includeList)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Should succesfully parse recursive sample with include list"
        )
    }

    func testJSONAPIDecodingWithEmptyRelationshipList_RecursiveSample() throws {
        let includeList = "author.article.author,author.categories"
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "EmptyRelationship-JsonApi", containsEverythingFrom: "EmptyRelationship-Json") {
            return try! JapxKit.Decoder.jsonObject(with: $0, includeList: includeList)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Should succesfully parse recursive sample with empty relationship list"
        )
    }

    func testJSONAPIDecodingWithEmptyRelationshipList_RecursiveSampleDeep() throws {
        let includeList = "author.article.author.categories,author.categories"
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "EmptyRelationship-JsonApi", containsEverythingFrom: "EmptyRelationshipDeep-Json") {
            return try! JapxKit.Decoder.jsonObject(with: $0, includeList: includeList)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Should succesfully parse recursive sample with empty relationship list - deep"
        )
    }

    func testJSONAPIDecodingWithEmptyRelationshipList_MissingInclude() throws {
        let includeList = "author.article.author,author.categories"
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "RelationshipNoInclude-JsonApi", containsEverythingFrom: "RelationshipNoInclude-Json") {
            return try! JapxKit.Decoder.jsonObject(with: $0, includeList: includeList)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Should succesfully parse recursive sample with missing relationship include object"
        )
    }

    func testJSONAPIDecodingWithParseNotIncludedRelationshipsProperty_MissingRelationshipObject() throws {
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "MissingRelationshipObject-JsonApi", containsEverythingFrom: "MissingRelationshipObject-Json") {
            return try! JapxKit.Decoder.jsonObject(with: $0, options: .notIncludedRelationships)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Should succesfully parse missing relationship object as type-id pair"
        )
    }

    func testJSONAPIDecodingWithParseNotIncludedRelationshipsProperty_MissingRelationshipObjects() throws {
        let includeList = "user"
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "MissingRelationshipObjects-JsonApi", containsEverythingFrom: "MissingRelationshipObjects-Json") {
            return try! JapxKit.Decoder.jsonObject(with: $0, includeList: includeList, options: .notIncludedRelationships)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Should succesfully parse missing relationship with include list as array of type-id pairs"
        )
    }

    func testJSONAPIDecodingWithParseNotIncludedRelationshipsProperty_MissingRelationshipObjectNull() throws {
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "MissingRelationshipObject-JsonApi", containsEverythingFrom: "MissingRelationshipObjectNull-Json") {
            return try! JapxKit.Decoder.jsonObject(with: $0)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Should succesfully parse missing relationship object as nil"
        )
    }

    func testJSONAPIDecodingWithParseNotIncludedRelationshipsProperty_MissingRelationshipObjectsEmpty() throws {
        let includeList = "user,policy"
        let correctlyParsed = AdditionalFunctions.does(jsonFromFileNamed: "MissingRelationshipObjects-JsonApi", containsEverythingFrom: "MissingRelationshipObjectsEmpty-Json") {
            return try! JapxKit.Decoder.jsonObject(with: $0, includeList: includeList)
        }
        XCTAssertTrue(
            correctlyParsed,
            "Should succesfully parse missing relationship with include list as empty array"
        )
    }
}

extension JapxKit.Decoder.Options {
    
    static var notIncludedRelationships: Self { .init(parseNotIncludedRelationships: true) }
    
}
