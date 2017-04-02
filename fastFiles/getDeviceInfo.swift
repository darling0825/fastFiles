//
//  getDeviceInfo.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension ViewController {
    
    func getDeviceInfo() { // Get device info
        let device = UIDevice.current.modelName
        let os = UIDevice.current.systemName
        let version = UIDevice.current.systemVersion
        let app = "fastFiles"
        let appVersion = App().version
        
        deviceInfo.text = "\(device), \(os) \(version), \(app) \(appVersion)"
    }
    
}
