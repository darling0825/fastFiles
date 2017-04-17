//
//  TextViewController.swift
//  fastFiles
//
//  Created by Adrian on 20.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import SafariServices

class TextViewController: UIViewController {
    
    // Variables
    
    var url: URL!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var keyboard: UIBarButtonItem!
    @IBOutlet weak var htmlToolbar: UIToolbar!
    
    var isCode = false
    
    var language = ""
    
    
    
    // Actions
    
    @IBAction func dismiss(_ sender: Any) { // Dismiss keyboard
        if text.isFirstResponder {
            text.resignFirstResponder()
        }

    }

    @IBAction func save(_ sender: Any) { // Save file
        
        do {
            try text.text.write(toFile: (url.absoluteString.removingPercentEncoding?.replacingOccurrences(of: "file://", with: ""))!, atomically: true, encoding: String.Encoding.utf8)
        } catch let error {
            let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func loadHTML(_ sender: Any) { // Load HTML or Swift
        if language == "htmlbars" || language == "markdown" {
            self.performSegue(withIdentifier: "HTML", sender: nil)
        } else {
            let task = URLSession.shared.dataTask(with: URL(string:"http://coldg.ddns.net/swift/?s=\(text.text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")!, completionHandler: { (data, response, error) in
                if error == nil {
                    if data != nil {
                        self.dismiss(animated: true, completion: {
                            self.performSegue(withIdentifier: "swift", sender: nil)
                        })
                    }
                } else {
                    self.dismiss(animated: true, completion: {
                        let alert = UIAlertController(title: "Error!".localized, message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    })
                    
                }
            })
            
            task.resume()
            
            
            let alertController = UIAlertController(title: "Compiling...".localized, message: "\n", preferredStyle: .alert)
            present(alertController, animated: true, completion: nil)
        }
        
    }
    

    
}
