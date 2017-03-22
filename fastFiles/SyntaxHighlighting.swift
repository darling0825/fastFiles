//
//  SyntaxHighlighting.swift
//  fastFiles
//
//  Created by Adrian on 12.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import Highlightr

/* 
                                    Syntax
                                highlighting
 */

extension TextViewController {
    func highlight(_ language:String, code:String) -> NSAttributedString? {
        
        var lang = language.lowercased()
        
        if language.lowercased() == "py" {
            lang = "python"
        }
        
        if language.lowercased() == "html" || language.lowercased() == "htm" || language.lowercased() == "php" {
            lang = "htmlbars"
        }
        
        if language.lowercased() == "m" || language.lowercased() == "mm" || language.lowercased() == "h" {
            lang = "objectivec"
        }
        
        if language.lowercased() == "sh" {
            lang = "bash"
        }
        
        if language.lowercased() == "js" {
            lang = "javascript"
        }
        
        if language.lowercased() == "md" {
            lang = "markdown"
        }
        
        for lang in (Highlightr()?.supportedLanguages())! {
            if lang == url.pathExtension.lowercased() {
                isCode = true
            } else {
                if lang == "python" {
                    if "py" == url.pathExtension.lowercased() {
                        isCode = true
                    }
                }
                
                if lang == "htmlbars" {
                    if "html" == url.pathExtension.lowercased() || "htm" == url.pathExtension.lowercased() || "php" == url.pathExtension.lowercased() {
                        isCode = true
                    }
                }
                
                if lang == "objectivec" {
                    if "m" == url.pathExtension.lowercased() || "mm" == url.pathExtension.lowercased() || "h" == url.pathExtension.lowercased() {
                        isCode = true
                    }
                }
                
                if lang == "bash" {
                    if "sh" == url.pathExtension.lowercased() {
                        isCode = true
                    }
                }
                
                if lang == "javascript" {
                    if "js" == url.pathExtension.lowercased() {
                        isCode = true
                    }
                }
                
                if lang == "markdown" {
                    if "md" == url.pathExtension.lowercased() {
                        isCode = true
                    }
                }
            }
        }
        
        if isCode {
            let highlightr = Highlightr()
            highlightr?.setTheme(to: "github-gist")
            CodeToolBar()
            self.text.autocorrectionType = .no
            self.text.autocapitalizationType = .none
            return (highlightr?.highlight(code, as: lang.lowercased(), fastRender: true))!
        } else {
            return nil
        }
        
    }
    
    
    
}
