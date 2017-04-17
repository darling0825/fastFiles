//
//  SFTPViewController.swift
//  fastFiles
//
//  Created by Adrian on 15.04.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import NMSSH

class SFTPViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var ip: UITextField!
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func login(_ sender: Any) {
        UserDefaults.standard.set(ip.text, forKey: "IP")
        UserDefaults.standard.set(user.text, forKey: "USER")
        UserDefaults.standard.set(password.text, forKey: "PASSWORD")
        
        self.performSegue(withIdentifier: "connect", sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
