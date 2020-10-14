//
//  AdditionalFunctions.swift
//  Japx_Example
//
//  Created by Vlaho Poluta on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
#if COCOAPODS
import Japx
#else
import JapxCore
#endif

public typealias ParsingPipelineCallback = (_ json: Data) -> (Any)

@objc public class AdditionalFunctions: NSObject {

    @objc public static func does(jsonFromFileNamed: String, containsEverethingFrom otherJsonFromFile: String, afterParsingBlock block: ParsingPipelineCallback) -> Bool {
        let path = Bundle.main.path(forResource: jsonFromFileNamed, ofType: "json")!
        let pathOther = Bundle.main.path(forResource: otherJsonFromFile, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let dataOther = try! Data(contentsOf: URL(fileURLWithPath: pathOther), options: .mappedIfSafe)

        let json = block(data)
        let jsonOther = try! JSONSerialization.jsonObject(with: dataOther)

        if let json = json as? Parameters, let jsonOther = jsonOther as? Parameters {
            return does(jsonParameter: json, containsEverethingFrom: jsonOther)
        }

        if let json = json as? Parameters, let jsonOther = jsonOther as? [Parameters] {
            return does(jsonParameter: json, containsEverethingFrom: ["data": jsonOther])
        }

        if let json = json as? [Parameters], let jsonOther = jsonOther as? Parameters {
            return does(jsonParameter: ["data": json], containsEverethingFrom: jsonOther)
        }

        if let json = json as? [Parameters], let jsonOther = jsonOther as? [Parameters] {
            return does(jsonParameters: json, containsEverethingFrom: jsonOther)
        }

        assert(false, "You should not end up here")
    }

    @objc public static func does(jsonParameters: [Parameters], containsEverethingFrom otherJson: [Parameters]) -> Bool {
        guard otherJson.count == jsonParameters.count else { return false }
        return zip(jsonParameters, otherJson).reduce(true) { (value, jsons) -> Bool in
            return value && does(jsonParameter: jsons.0, containsEverethingFrom: jsons.1)
        }
    }

    @objc public static func does(jsonParameter: Parameters, containsEverethingFrom otherJson: Parameters) -> Bool {
        return otherJson.reduce(true) { (boolCollectedSoFar, entry) -> Bool in

            if !boolCollectedSoFar { return false }

            if let arrayOther = entry.value as? [Parameters] {
                guard let array = jsonParameter[entry.key] as? [Parameters] else { return false }
                return does(jsonParameters: array, containsEverethingFrom: arrayOther)
            }

            if let innerJsonOther = entry.value as? Parameters {
                guard let innerJson = jsonParameter[entry.key] as? Parameters else { return false }
                return does(jsonParameter: innerJson, containsEverethingFrom: innerJsonOther)
            }

            if let stringOther = entry.value as? String {
                guard let string = jsonParameter[entry.key] as? String else { return false }
                return string == stringOther
            }

            if let numberOther = entry.value as? NSNumber {
                guard let number = jsonParameter[entry.key] as? NSNumber else { return false }
                return number == numberOther
            }

            if entry.value is NSNull {
                return (jsonParameter[entry.key] == nil || jsonParameter[entry.key] is NSNull)
            }

            assert(false, "You should not end up here")
        }
    }
}

