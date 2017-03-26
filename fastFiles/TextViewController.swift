//
//  TextViewController.swift
//  fastFiles
//
//  Created by Adrian on 20.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    // Variables
    
    var url: URL!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var keyboard: UIBarButtonItem!
    @IBOutlet weak var htmlToolbar: UIToolbar!
    
    var isCode = false
    
    
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
    
    @IBAction func loadHTML(_ sender: Any) { // Load HTML
        self.performSegue(withIdentifier: "HTML", sender: nil)
    }
    

    
}
