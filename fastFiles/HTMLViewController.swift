//
//  HTMLViewController.swift
//  fastFiles
//
//  Created by Adrian on 21.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

class HTMLViewController: UIViewController {

    // Variables
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    var code = ""
    var file = URL(string:"")

}
