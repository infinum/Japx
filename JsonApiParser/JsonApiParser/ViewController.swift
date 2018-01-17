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
        let date = Date()
        for i in (0..<200_000) {
            let resp1 = try! JsonApiParser.unbox(jsonApiInput: unboxTest)
        }
        print(Date().timeIntervalSince(date))
//        debugPrint(resp1 as NSDictionary)
//        print("\n\n")
        
//        let resp2 = try! JsonApiParser.wrap(json: wrapTest)
//        debugPrint(resp2 as NSDictionary)
//        print("\n\n")
    }


}

