//
//  ResultViewController.swift
//  JSONAPIParser_Example
//
//  Created by Vlaho Poluta on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    var text: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text
    }
}
