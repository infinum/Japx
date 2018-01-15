//
//  TestData.swift
//  JsonApiParser
//
//  Created by Vlaho Poluta on 15/01/2018.
//  Copyright © 2018 Vlaho Poluta. All rights reserved.
//

import UIKit

let unboxTest = [
    "data": [
        "type": "has-one",
        "id": "parent",
        "attributes": [
            "name": "Some Parent",
        ],
        "relationships": [
            "child": [
                "data": [
                    "type": "child",
                    "id": "child",
                ],
            ],
        ],
    ],
    "included": [
        [
            "type": "child",
            "id": "child",
            "attributes": [
                "name": "Some Child",
            ],
            ],
    ]
    ] as [String : Any]



let wrapTest = [
    "type": "has-one",
    "id": "parent",
    "name": "Some Parent",
    "child": [
        "type": "child",
        "id": "child",
        "name": "Some Child",
    ]
    ] as [String : Any]


let empty = [
    "data": [
        ["type": "empty", "id": "1"],
        ["type": "empty", "id": "2"],
    ],
]

let test2 = [
    "data": [
        "type": "basic",
        "id": "1",
        "attributes": [
            "string": "foobar",
            "int": 123,
        ],
    ],
]
