//
//  BrowserTableViewController.swift
//  fastFiles
//
//  Created by Adrian on 20.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Zip

import GoogleMobileAds
import AdSupport

class BrowserTableViewController: UITableViewController {

    var dir = "/"
    var files = [""]
    
    var nextDir = ""
    var imageURL: URL!
    
    var player = AVPlayer()
    
    var renameAlert = UIAlertController()
    
    var zip = false
    
    var nextSelectedRow: [Int] = []
    
    
    @IBOutlet weak var Ad: GADBannerView!
    
    var exportSession: AVAssetExportSession!

    @IBOutlet weak var indexFile: UIWebView!
    
}
