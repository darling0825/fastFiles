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

class ViewController: UIViewController {
    
    // Variables
    
    
    @IBOutlet weak var deviceInfo: UILabel!
    var player = AVPlayer()
    var imageURL: URL!
    
    
    // Actions
    
    @IBAction func Documents(_ sender: Any) {
        self.performSegue(withIdentifier: "Docs", sender: nil)
    }
    
    
}

