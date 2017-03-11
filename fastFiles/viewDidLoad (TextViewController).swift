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
        
    }
}
