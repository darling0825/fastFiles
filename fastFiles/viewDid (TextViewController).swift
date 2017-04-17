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
                                                    ...
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
        
        // Highlight code
        let code = self.highlight(self.url.pathExtension, code: self.text.text)
        if code != nil {
            Timer.scheduledTimer(withTimeInterval: TimeInterval(UserDefaults.standard.value(forKey: "Refresh") as! Int), repeats: true) { (Timer) in
                let code = self.highlight(self.url.pathExtension, code: self.text.text)
                if code != nil {
                    let cursorPos = self.text.selectedTextRange
                    self.text.attributedText = code?["Code"] as! NSAttributedString
                    self.text.selectedTextRange = cursorPos
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        // Syntax Highlighting
        
        htmlToolbar.isHidden = true
        
        let code = highlight(url.pathExtension, code: text.text)
        if code != nil {
            text.attributedText = code?["Code"] as! NSAttributedString
            language = code?["Language"] as! String
            if (code?["Language"] as! String) == "htmlbars" || (code?["Language"] as! String) == "markdown" || (code?["Language"] as! String) == "swift" {
                htmlToolbar.isHidden = false
            }
        }
        
    }


}
