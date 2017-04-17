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
        
        webView.loadRequest(URLRequest(url: URL(string:"https://www.google.com")!)) // Load Google
        
        webView.delegate = self // Set WebView delegate
        
        blur.isHidden = true // Unblur
        
        // Config videos
        webView.allowsPictureInPictureMediaPlayback = true
        webView.mediaPlaybackRequiresUserAction = true

        
        backgroundTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: { // Start background task
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
        })
        
    }
}
