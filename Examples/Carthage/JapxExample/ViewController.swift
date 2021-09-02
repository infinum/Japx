//
//  ViewController.swift
//  JapxExample
//
//  Created by Filip Gulan on 30.08.2021..
//

import UIKit

import Japx
// or
import JapxAlamofire
// or
import JapxRxAlamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let jsonApiObject: [String: Any] = [
            "data": [
                "id": "1",
                "type": "users",
                "attributes": [
                    "email": "john@infinum.co",
                    "username": "john"
                ]
            ]
        ]
        let simpleObject: [String: Any]

        do {
            simpleObject = try JapxKit.Decoder.jsonObject(withJSONAPIObject: jsonApiObject)
            print(simpleObject)
        } catch {
            print(error)
        }
    }
}
