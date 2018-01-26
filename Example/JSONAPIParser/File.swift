//
//  File.swift
//  JSONAPIParser_Example
//
//  Created by Filip Gulan on 26/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import JSONAPIParser

class User: JSONAPIDecodable, JSONAPIEncodable {
    
    var id: String
    var type: String
    let email: String
    var username: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case username
        case type
    }
}
