//
//  viewDidLoad (TextViewController).swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

/*
                                                  View did
                                                    load
 */

extension TextViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = url!.lastPathComponent // Set title
        
        // Display text
        displayText()
        
        // Update text view size
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
            // Syntax highlighting
            self.highlight(language: self.url.pathExtension.lowercased())
            
            if self.text.text == "undefined" { // Invalid language
                Timer.invalidate()
                self.text.backgroundColor = .white
                self.text.attributedText = nil
                let text = try! String(contentsOf: self.url)
                
                self.text.text = text
                self.text.textColor = .black
            }
            
        }
    }

}
