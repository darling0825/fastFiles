//
//  prepareForSegue (TextViewController).swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

/*
                                                      Run
                                                      HTML
 */

extension TextViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("Prepare for segue")
        
        if segue.identifier == "HTML" {
            print("Identifier is HTML")
            if let nextVC = segue.destination as? HTMLViewController {
                print("Set values")
                nextVC.code = text.text!
                print("CODE: "+text.text)
                nextVC.file = url
            }
        }
    }
}
