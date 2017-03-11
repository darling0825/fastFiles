//
//  viewDidLoad (ImageViewController).swift
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

extension ImageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set scroll view zoom settings
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.isScrollEnabled = true
        
        displayImage() // Display audio
        
        self.title = url!.lastPathComponent // Set title
        
        
    }
}
