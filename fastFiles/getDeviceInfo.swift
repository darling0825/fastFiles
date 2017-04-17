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
        
        deviceInfo.text = "\(device), \(os) \(version)"
        
        var info = "<center><img src='https://img.shields.io/badge/Version-\(App().version)-blue.svg'>"
        if App.Config.appConfiguration == .Debug {
            info += " <img src='https://img.shields.io/badge/Config-Debug-red.svg'>"
        } else if App.Config.appConfiguration == .TestFlight {
            info += " <img src='https://img.shields.io/badge/Config-Beta-orange.svg'>"
        }
        
        news.loadHTMLString(info, baseURL: nil)
        news.scrollView.isScrollEnabled = false
    }
}
