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
        let jsonApi = ExampleReader.dataToJson(jsonApiData)
        let dicts = try! JsonApiParser.unbox(jsonApiInput: jsonApi)
        print(ExampleReader.prettyPrintJson(data: dicts))

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

