//
//  viewDidLoad (DownloadViewController).swift
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

extension DownloadViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Design text fields
        url.tintColor = .blue
        google.tintColor = .blue
        
        
        webView.loadRequest(URLRequest(url: URL(string:"https://www.google.com")!)) // Load Google
        
        webView.delegate = self // Set WebView delegate
        
        blur.isHidden = true // Unblur
        
        (view.viewWithTag(10) as! UIActivityIndicatorView).isHidden = true // Hide activity view
        
        
        backgroundTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: { // Start background task
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
        })
        
    }
}
