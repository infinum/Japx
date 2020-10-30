//
//  ResultableProtocol.swift
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

protocol Resultable { }

extension Resultable where Self: UIViewController {
    
    func pushResultViewController(with text: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Result") as! ResultViewController
        vc.text = text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func alert(error: Error) {
        print("ERROR:")
        print(error.localizedDescription)
        let alert = UIAlertController(title: "Invalid JSON", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
