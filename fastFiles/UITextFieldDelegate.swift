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
        
        var urlString = textField.text
        
        if textField.tag == 1 { // Load URL
            if !(textField.text?.hasPrefix("http://"))! && !(textField.text?.hasPrefix("https://"))! {
                urlString = "http://"+textField.text!
            }
            let url = URL(string:urlString!)
            if url != nil && (url?.absoluteString.contains("."))! {
                textField.text = urlString
                print(urlString!)
                webView.loadRequest(URLRequest(url: url!))
            } else { // Search
                let urlString = "https://www.google.com/search?q=\(textField.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
                print(urlString)
                let google = URL(string:urlString)
                webView.loadRequest(URLRequest(url: google!))
            }
        }
        
        return true
    }
    
    
}

