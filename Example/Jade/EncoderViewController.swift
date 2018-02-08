//
//  EncoderViewController.swift
//  Jade_Example
//
//  Created by Vlaho Poluta on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Jade

class EncoderViewController: UIViewController, Resultable {

    @IBOutlet var textView: UITextView!
    
    @IBAction func encodePressed() {
        guard let data = textView.text.data(using: .utf8) else { return }
        
        do {
            let json = try Jade.Encoder.encode(data: data)
            pushResultViewController(with: PrettyPrint.prettyPrintJson(data: json))
        } catch {
            alert(error: error)
        }
    }
}
