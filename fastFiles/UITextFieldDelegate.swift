//
//  UITextFieldDelegate.swift
//  fastFiles
//
//  Created by Adrian on 05.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

/*
                                        Did press
                                        return key
 */

extension DownloadViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.placeholder == "URL" { // Load URL
            if !(textField.text?.hasPrefix("http://"))! && !(textField.text?.hasPrefix("https://"))! {
                textField.text = "http://"+textField.text!
            }
            let url = URL(string:textField.text!)
            if url != nil{
                webView.loadRequest(URLRequest(url: url!))
            } else {
                let alert = UIAlertController(title: "Error!", message: "Invalid URL!\nMake sure to add http:// or https://", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else if textField.placeholder == "Search" { // Google
            let urlString = "https://www.google.com/search?q=\(textField.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
            print(urlString)
            let google = URL(string:urlString)
            webView.loadRequest(URLRequest(url: google!))
        }
        
        return true
    }
    
    
}

