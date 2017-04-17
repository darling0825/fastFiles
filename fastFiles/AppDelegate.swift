//
//  AppDelegate.swift
//  fastFiles
//
//  Created by Adrian on 20.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var background = false
    
    var docsPath = ""
    var docsURL: URL!

    var player = AVPlayer()
    
    var docs = [URL]()
    
    var urlOpened = false
    
    var IN_APP_OPEN = false
}

