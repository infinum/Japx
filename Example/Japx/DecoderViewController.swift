//
//  DecoderViewController.swift
//  Japx_Example
//
//  Created by Vlaho Poluta on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
#if COCOAPODS
import Japx
#else
import JapxCore
#endif

class DecoderViewController: UIViewController, Resultable {

    @IBOutlet var textView: UITextView!
    
    @IBAction func decodePressed() {
        guard let data = textView.text.data(using: .utf8) else { return }
        
        do {
            let json = try Japx.Decoder.jsonObject(with: data)
            pushResultViewController(with: PrettyPrint.prettyPrintJson(data: json))
        } catch {
            alert(error: error)
        }
    }
}
