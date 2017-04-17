//
//  prepareForSegue (TextViewController).swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import Down

/*
                                                      Run
                                                      HTML
 */

extension TextViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("Prepare for segue")
        
        if segue.identifier == "HTML" {
            if let nextVC = segue.destination as? HTMLViewController {
                nextVC.code = text.text!
                
                if url.pathExtension == "md" {
                    do {
                        nextVC.code = try Down(markdownString: text.text).toHTML()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
                nextVC.file = url
            }
        }
        
        if segue.identifier == "swift" {
            if let nextVC = segue.destination as? NMTerminalViewController {
                nextVC.command = "execAndDelete ~/script && logout";
                nextVC.host = "coldg.ddns.net"
                nextVC.user = "swiftexec"
                nextVC.password = "swift"
            }
        }
    }
}
