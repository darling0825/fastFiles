//
//  displayText.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

/*
                                                        Display
                                                         text
 */

extension TextViewController {
    func displayText() {
        do {
            if url.pathExtension.lowercased() != "rtf" {
                let fileContent = try String(contentsOf: url)
                text.text = fileContent
            } else { // Is RTF file
                let attributedString = try NSAttributedString(url: url, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
                text.attributedText = attributedString
                text.isEditable = false
            }
        } catch let error {
            let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func keyboardWillShow(_ notification:Notification) {
        let d = notification.userInfo!
        var r = d[UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        r = self.text.convert(r, from:nil)
        self.text.contentInset.bottom = r.size.height
        self.text.scrollIndicatorInsets.bottom = r.size.height
        
        keyboard.isEnabled = true
    }
    
    func keyboardWillHide(_ notification:Notification) {        
        self.text.contentInset = .zero
        self.text.scrollIndicatorInsets = .zero
        
        keyboard.isEnabled = false
    }
}
