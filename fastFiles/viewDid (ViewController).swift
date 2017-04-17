//
//  viewDidLoad.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

/*
                                                        View
                                                        did..
 */

extension ViewController {
    override func viewDidLoad() { // View did load
        super.viewDidLoad()
        
        
        // Get device info
        getDeviceInfo()
        
        // Open file if app is opened from URL
        NotificationCenter.default.addObserver(self, selector: #selector(openFromURL), name: NSNotification.Name(rawValue: "open"), object: nil)

        // Touch ID
        
        if UserDefaults.standard.bool(forKey: "touchID") {
            touchID()
        }
        
        // Design
        self.navigationController?.navigationBar.tintColor = .white
        
    }
}
