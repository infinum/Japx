//
//  ExampleReader.swift
//  JsonApiParser
//
//  Created by Vlaho Poluta on 17/01/2018.
//  Copyright © 2018 Vlaho Poluta. All rights reserved.
//

import UIKit

class ExampleReader {
    
    static func importData() -> Data {
        let path = Bundle.main.path(forResource: "example", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    }
    
    static func importSimpleData() -> Data {
        let path = Bundle.main.path(forResource: "simple", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    }
    
    static func dataToJson(_ data: Data) -> Parameters {
        return try! JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as! Parameters
    }

    static func jsonToData(_ data: Parameters) -> Data {
        return try! JSONSerialization.data(withJSONObject: data, options: .init(rawValue: 0))
    }
    
    static func decode(data: Data) -> DataModel<[Article]> {
        return try! JSONDecoder().decode(DataModel<[Article]>.self, from: data)
    }
    
    static func prettyPrintJson(data: NSDictionary) -> String {
        let dataData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        return String(data: dataData, encoding: .utf8)!
    }
    
}
