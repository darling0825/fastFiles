//
//  ViewController.swift
//  fastFiles
//
//  Created by Adrian on 20.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    // Variables
    
    var terminationStatus = ""
    
    var finalDest: URL!
    
    @IBOutlet weak var deviceInfo: UILabel!
    var player = AVPlayer()
    var imageURL: URL!
    
    var checkForBytes = Timer()
    
    @IBOutlet weak var news: UIWebView!
    
    
    // Actions
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
     
    
}

