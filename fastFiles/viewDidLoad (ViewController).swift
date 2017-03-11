//
//  viewDidLoad.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension ViewController {
    override func viewDidLoad() { // View did load
        super.viewDidLoad()
        
        // Set navigation bar style
        setNavBarStyle()
        
        
        // Get device info
        getDeviceInfo()
        
        // Open file if app is opened from URL
        NotificationCenter.default.addObserver(self, selector: #selector(openFromURL), name: NSNotification.Name(rawValue: "open"), object: nil)

    }
}
