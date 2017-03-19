//
//  CodeToolBar.swift
//  fastFiles
//
//  Created by Adrian on 19.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

/*
                                                    Code
                                                  toolbar
 */

extension TextViewController {
    func CodeToolBar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        
        var items = [UIBarButtonItem]()
        items.append(UIBarButtonItem(title: "(", style: .done, target: self, action: #selector(insertText(sender:)))) // (
        items.append(UIBarButtonItem(title: ")", style: .done, target: self, action: #selector(insertText(sender:)))) // )
        
        items.append(UIBarButtonItem(title: " ", style: .done, target: self, action: nil))
        
        items.append(UIBarButtonItem(title: "{", style: .done, target: self, action: #selector(insertText(sender:)))) // {
        items.append(UIBarButtonItem(title: "}", style: .done, target: self, action: #selector(insertText(sender:)))) // }
        
        items.append(UIBarButtonItem(title: " ", style: .done, target: self, action: nil))
        
        items.append(UIBarButtonItem(title: "\\", style: .done, target: self, action: #selector(insertText(sender:)))) // \
        items.append(UIBarButtonItem(title: "/", style: .done, target: self, action: #selector(insertText(sender:)))) // /
        
        items.append(UIBarButtonItem(title: " ", style: .done, target: self, action: nil))
        
        items.append(UIBarButtonItem(title: "\"", style: .done, target: self, action: #selector(insertText(sender:)))) // "
        
        items.append(UIBarButtonItem(title: " ", style: .done, target: self, action: nil))
        
        items.append(UIBarButtonItem(title: "<", style: .done, target: self, action: #selector(insertText(sender:)))) // <
        items.append(UIBarButtonItem(title: ">", style: .done, target: self, action: #selector(insertText(sender:)))) // >
        
        items.append(UIBarButtonItem(title: " ", style: .done, target: self, action: nil))
        
        items.append(UIBarButtonItem(title: "!", style: .done, target: self, action: #selector(insertText(sender:)))) // !
        items.append(UIBarButtonItem(title: "?", style: .done, target: self, action: #selector(insertText(sender:)))) // ?
        
        items.append(UIBarButtonItem(title: " ", style: .done, target: self, action: nil))
        
        items.append(UIBarButtonItem(title: "&", style: .done, target: self, action: #selector(insertText(sender:)))) // &
        items.append(UIBarButtonItem(title: "|", style: .done, target: self, action: #selector(insertText(sender:)))) // |
        
        
        toolbar.sizeToFit()
        toolbar.items = items
        
        self.text.inputAccessoryView = toolbar
        
        print("Add toolbar")
    }
    
    func insertText(sender: UIBarButtonItem) {
        self.text.replace(self.text.selectedTextRange!, withText: sender.title!)
    }
    
}
