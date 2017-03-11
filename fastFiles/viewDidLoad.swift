//
//  viewDidLoad.swift
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

extension PDFViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = url?.lastPathComponent // Set title
        webView.loadRequest(URLRequest(url: url!))
        
        // Configure scroll view
        scroll.delegate = self
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 6.0
        scroll.isScrollEnabled = true
    }
}
