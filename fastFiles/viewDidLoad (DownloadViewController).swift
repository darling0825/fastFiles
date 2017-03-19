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
        customName.tintColor = .blue
        url.tintColor = .blue
        google.tintColor = .blue
        
        customName.delegate = self
        
        webView.loadRequest(URLRequest(url: URL(string:"https://www.google.com")!)) // Load Google
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in // A timer
            
            if self.terminationStatus != "" { // Check if a download is finished
                self.dismiss(animated: false, completion: { // Dismiss alert
                    if self.terminationStatus != "Success" { // Download failed
                        self.blur.isHidden = true
                        self.navigationController?.isNavigationBarHidden = false
                        let alert = UIAlertController(title: "Error!", message: self.terminationStatus, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
                        self.present(alert, animated: true, completion: nil)
                    } else { // Download successed
                        self.blur.isHidden = true
                        self.navigationController?.isNavigationBarHidden = false
                        self.performSegue(withIdentifier: "Downloads", sender: nil)
                    }
                    
                    self.terminationStatus = "" // Reset termination status
                })
                
                
            }
        }
        
        webView.delegate = self // Set WebView delegate
        
        blur.isHidden = true // Unblur
        
        (view.viewWithTag(10) as! UIActivityIndicatorView).isHidden = true // Hide activity view
    }
}
