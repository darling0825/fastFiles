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
            let fileContent = try String(contentsOf: url)
            text.text = fileContent
        } catch let error {
            let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let d = notification.userInfo!
        var r = d[UIKeyboardFrameEndUserInfoKey] as! CGRect
        r = self.text.convert(r, from:nil)
        self.text.contentInset.bottom = r.size.height
        self.text.scrollIndicatorInsets.bottom = r.size.height
        
        keyboard.isEnabled = true
    }
    
    func keyboardWillHide(notification:NSNotification) {
        let d = notification.userInfo!
        var r = d[UIKeyboardFrameEndUserInfoKey] as! CGRect
        r = self.text.convert(r, from:nil)
        self.text.contentInset.bottom = r.size.height
        self.text.scrollIndicatorInsets.bottom = r.size.height
        
        keyboard.isEnabled = false
    }
}
