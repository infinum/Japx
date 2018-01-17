//
//  Models.swift
//  JsonApiParser
//
//  Created by Vlaho Poluta on 17/01/2018.
//  Copyright © 2018 Vlaho Poluta. All rights reserved.
//

import UIKit

struct DataModel<T>: Decodable where T: Decodable {
    let data: T
}

struct Article: Decodable {
    let type: String
    let id: String
    let title: String
    let body: String
    let created: String?
    let updated: String?
    let author: Author
}


struct Author: Decodable {
    let type: String
    let id: String
    let name: String
    let age: Int
    let gender: Gender
    
    enum Gender: String, Decodable {
        case male
        case female
    }
}
