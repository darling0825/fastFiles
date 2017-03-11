//
//  PDFViewController.swift
//  fastFiles
//
//  Created by Adrian on 24.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var url = URL(string: "")
    
    
}
