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

extension HTMLViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        let basePath = file!.path
        let baseURL = URL(fileURLWithPath: basePath)
        webView.loadHTMLString(code, baseURL: baseURL) // Load code
        
        print("CODE: "+code)
    }
}
