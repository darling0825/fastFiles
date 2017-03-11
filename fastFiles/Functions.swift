//
//  Variables.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    // Application did finish launching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Move files imported with iTunes to public documents folder
        moveToPublic()
                
        return true
    }
    
    // Application will resign active
    func applicationWillResignActive(_ application: UIApplication) {
        BrowserTableViewController().player.play()
        background = true
    }
    
    // Application did enter background
    func applicationDidEnterBackground(_ application: UIApplication) {
        BrowserTableViewController().player.play()
        background = true
    }
    
    // Application Will Enter Foreground
    func applicationWillEnterForeground(_ application: UIApplication) {
        BrowserTableViewController().player.play()
        background = true
    }
    
    // Application did become active
    func applicationDidBecomeActive(_ application: UIApplication) {
        background = false
    }
    
    // Application will terminate
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}
