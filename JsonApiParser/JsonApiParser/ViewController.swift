//
//  ViewController.swift
//  JsonApiParser
//
//  Created by Vlaho Poluta on 15/01/2018.
//  Copyright © 2018 Vlaho Poluta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let N = 200_000
        
        //Simple
//        let simpleData = ExampleReader.importSimpleData()
        
//        let dateSimple = Date()
//        for _ in (0 ..< N) {
//            _ = ExampleReader.decode(data: simpleData)
//        }
//        print(Date().timeIntervalSince(dateSimple))
//        
        //Json api
        let jsonApiData = ExampleReader.importData()
        
        let date = Date()
        let jsonApi = ExampleReader.dataToJson(jsonApiData)
        for _ in (0 ..< N) {
            let dicts = try! JsonApiParser.unbox(jsonApiInput: jsonApi)
//        let normalData = ExampleReader.jsonToData(dicts)
//        _ = ExampleReader.decode(data: normalData)
        }
        print(Date().timeIntervalSince(date))

    }

    func unboxTest() {
//        let resp1 = try! JsonApiParser.unbox(jsonApiInput: unboxTest)
//        debugPrint(resp1 as NSDictionary)
//        print("\n\n")
    }
    
    func wrapTest() {
//        let resp2 = try! JsonApiParser.wrap(json: wrapTest)
//        debugPrint(resp2 as NSDictionary)
//        print("\n\n")
    }

}

