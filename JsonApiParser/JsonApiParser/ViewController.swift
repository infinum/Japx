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
        let resp1 = try! JsonApiParser.unbox(jsonApiInput: unboxTest)
        debugPrint(resp1 as NSDictionary)
        print("\n\n")
        
        let resp2 = try! JsonApiParser.wrap(json: wrapTest)
        debugPrint(resp2 as NSDictionary)
        print("\n\n")
    }


}

