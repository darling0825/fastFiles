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
        
        // Set text delegate
        text.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        // Syntax Highlighting
        let code = highlight(url.pathExtension, code: text.text)
        if code != nil {
            text.attributedText = code
        }
    }


}
