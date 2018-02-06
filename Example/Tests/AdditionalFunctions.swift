//
//  AdditionalFunctions.swift
//  JSONAPIParser_Example
//
//  Created by Vlaho Poluta on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import JSONAPIParser

typealias ParsingPipelineCallback = (_ json: Data)->(Any)

func does(jsonFromFileNamed: String, containsEverethingFrom otherJsonFromFile: String, afterParsingBlock block: ParsingPipelineCallback) -> Bool {
    let path = Bundle.main.path(forResource: jsonFromFileNamed, ofType: "json")!
    let pathOther = Bundle.main.path(forResource: otherJsonFromFile, ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    let dataOther = try! Data(contentsOf: URL(fileURLWithPath: pathOther), options: .mappedIfSafe)
    
    let json = block(data)
    let jsonOther = try! JSONSerialization.jsonObject(with: dataOther, options: .init(rawValue: 0))
    
    if let json = json as? Parameters, let jsonOther = jsonOther as? Parameters {
        return does(json: json, containsEverethingFrom: jsonOther)
    }
    
    if let json = json as? Parameters, let jsonOther = jsonOther as? [Parameters] {
        return does(json: json, containsEverethingFrom: ["data": jsonOther])
    }
    
    if let json = json as? [Parameters], let jsonOther = jsonOther as? Parameters {
        return does(json: ["data": json], containsEverethingFrom: jsonOther)
    }
    
    if let json = json as? [Parameters], let jsonOther = jsonOther as? [Parameters] {
        return does(json: json, containsEverethingFrom: jsonOther)
    }
    
    assert(false, "You should not end up here")
}

func does(json: [Parameters], containsEverethingFrom otherJson: [Parameters]) -> Bool {
    guard otherJson.count == json.count else { return false }
    return zip(json, otherJson).reduce(true) { (value, jsons) -> Bool in
        return value && does(json: jsons.0, containsEverethingFrom: jsons.1)
    }
}

func does(json: Parameters, containsEverethingFrom otherJson: Parameters) -> Bool {
    return otherJson.reduce(true) { (boolCollectedSoFar, entry) -> Bool in
        
        if !boolCollectedSoFar { return false }
        
        if let arrayOther = entry.value as? [Parameters] {
            guard let array = json[entry.key] as? [Parameters] else { return false }
            return does(json: array, containsEverethingFrom: arrayOther)
        }
        
        if let innerJsonOther = entry.value as? Parameters {
            guard let innerJson = json[entry.key] as? Parameters else { return false }
            return does(json: innerJson, containsEverethingFrom: innerJsonOther)
        }
        
        if let stringOther = entry.value as? String {
            guard let string = json[entry.key] as? String else { return false }
            return string == stringOther
        }
        
        if let numberOther = entry.value as? NSNumber {
            guard let number = json[entry.key] as? NSNumber else { return false }
            return number == numberOther
        }
        
        assert(false, "You should not end up here")
    }
}

