//
//  touchID.swift
//  fastFiles
//
//  Created by Adrian on 19.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import LocalAuthentication
/*
                                                        Touch
                                                         ID
 */

extension ViewController {
    func touchID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Are you the owner of this device?", reply: { (success, error) in
                if !success {
                    let alert = UIAlertController(title: "Error!", message: "Error during verification ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                        exit(0)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
}
