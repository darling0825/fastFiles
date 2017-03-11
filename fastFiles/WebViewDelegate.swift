//
//  WebViewDelegate.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

/*
                                                   WebView did
                                                   finish load
 */

extension HTMLViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.isHidden = true
        self.title = webView.stringByEvaluatingJavaScript(from: "document.title") // Get page title
    }
    
}
