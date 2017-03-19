//
//  Variables.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import CoreSpotlight

extension AppDelegate {
    
    // Application did finish launching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Move files imported with iTunes to public documents folder
        moveToPublic()
        
        iCloudSync() // Sync with iCloud
        
        index() // Index for spotlight
        
        UserDefaults.standard.synchronize() // Sync UserDefaults
        
        return true
    }
    
    // Application will resign active
    func applicationWillResignActive(_ application: UIApplication) {
        BrowserTableViewController().player.play()
        background = true
        index() // Index for spotlight
    }
    
    // Application did enter background
    func applicationDidEnterBackground(_ application: UIApplication) {
        BrowserTableViewController().player.play()
        background = true
        index() // Index for spotlight
    }
    
    // Application Will Enter Foreground
    func applicationWillEnterForeground(_ application: UIApplication) {
        BrowserTableViewController().player.play()
        background = true
        index() // Index for spotlight
    }
    
    // Application did become active
    func applicationDidBecomeActive(_ application: UIApplication) {
        background = false
        index() // Index for spotlight
    }
    
    // Application will terminate
    func applicationWillTerminate(_ application: UIApplication) {
        index() // Index for spotlight
    }
    
    
}
