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
    func highlight(language:String) {
        let highlightr = Highlightr()
        highlightr!.setTheme(to: "paraiso-dark")
        let code = highlightr!.highlight(text.text, as: language, fastRender: true)
        print(text.text)
        
        text.attributedText = code
        text.backgroundColor = highlightr!.theme.themeBackgroundColor
    }
}
