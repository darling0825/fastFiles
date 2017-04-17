//
//  Variables.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import CoreSpotlight
import UserNotifications
import NMSSH

extension AppDelegate {
    
    // Application did finish launching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Move files imported with iTunes to public documents folder
        moveToPublic()
        
        iCloudSync() // Sync with iCloud
        
        index() // Index for spotlight
        
        if UserDefaults.standard.value(forKey: "Refresh") == nil {
            UserDefaults.standard.set(5,forKey: "Refresh")
        }
        
        UserDefaults.standard.synchronize() // Sync UserDefaults
        
        if #available(iOS 8, *) { // Register for notifications
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (success, error) in
                if error != nil {
                    print("ERROR: "+error!.localizedDescription)
                }
            })
            
            
        }
        
        
        
        
        
        return true
    }
    
    // Application will resign active
    func applicationWillResignActive(_ application: UIApplication) {
        BrowserTableViewController().player.play()
        background = true
        index() // Index for spotlight
        
        // Blur snapchot
        if UserDefaults.standard.bool(forKey: "touchID") {if UIApplication.shared.keyWindow?.viewWithTag(1) == nil {
            let blur = UIVisualEffectView(frame: (window?.rootViewController?.view.frame)!)
            blur.effect = UIBlurEffect(style: .light)
            blur.tag = 1
        
            UIApplication.shared.keyWindow?.addSubview(blur)
        } else {
            UIApplication.shared.keyWindow?.viewWithTag(1)?.isHidden = false
        }}
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
        background = false
        index() // Index for spotlight
        UIApplication.shared.applicationIconBadgeNumber = 0 // Remove badges
    }
    
    // Application did become active
    func applicationDidBecomeActive(_ application: UIApplication) {
        background = false
        index() // Index for spotlight
        
        // Remove blur effect
        UIApplication.shared.keyWindow?.viewWithTag(1)?.isHidden = true
    }
    
    // Application will terminate
    func applicationWillTerminate(_ application: UIApplication) {
        index() // Index for spotlight
        
        for url in try! FileManager.default.contentsOfDirectory(at: App().tmpURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) { // Remove download caches
            do { try FileManager.default.removeItem(at: url) } catch _ {}
        }
        
        let docs = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]
        if FileManager.default.fileExists(atPath: docs.appendingPathComponent("Inbox").path) {
            
            for doc in try! FileManager.default.contentsOfDirectory(atPath: docs.appendingPathComponent("Inbox").path) {
                do {try FileManager.default.removeItem(at: docs.appendingPathComponent("Inbox").appendingPathComponent(doc))} catch let error {
                    print("ERROR: "+error.localizedDescription)
                }
            }
        }
    }
    
    
    
}
