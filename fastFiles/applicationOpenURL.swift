//
//  didOpenURL.swift
//  fastFiles
//
//  Created by Adrian on 27.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import Zip
import AVFoundation
import AVKit

/*
                                     Handle
                                       url
 */

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("URL RECEIVED")
        
        var file = url.urlScheme
        
        if url != file { // Is external file
            do {
                try FileManager.default.moveItem(at: url, to: docsURL.appendingPathComponent(url.lastPathComponent))
                file = docsURL.appendingPathComponent(url.lastPathComponent)
            } catch _ {
                if FileManager.default.fileExists(atPath: docsURL.appendingPathComponent(url.lastPathComponent).path) {
                    file = docsURL.appendingPathComponent(url.lastPathComponent)
                }
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
        if let presented = window?.rootViewController?.presentedViewController {
            presented.dismiss(animated: true, completion: {
                self.window?.rootViewController?.present(mainVC, animated: true, completion: {
                    // Open directory
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "open"), object: nil)
                })
            })
        } else {
            self.window?.rootViewController?.present(mainVC, animated: true, completion: {
                // Open directory
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "open"), object: nil)
            })
        }
        
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: file.path, isDirectory: &isDir) { // Check if file exists
            
            print("FILE EXISTS")
            
            if isDir.boolValue { // Is directory
                print("IS DIR")
                
                // Directory path
                let defaults = UserDefaults.standard
                defaults.set(file.path, forKey: "path")
                defaults.removeObject(forKey: "fileIndex")
                defaults.synchronize()
                
                return true
            } else { // Is file
                
                print("IS FILE")
                
                // Directory path
                let defaults = UserDefaults.standard
                defaults.set(file.deletingLastPathComponent().path, forKey: "path")
                
                // Selected row
                let files = try! FileManager.default.contentsOfDirectory(atPath: file.deletingLastPathComponent().path)
                let nextFileIndex = files.index(of: file.lastPathComponent)
                defaults.removeObject(forKey: "fileIndex")
                defaults.set([nextFileIndex!], forKey: "fileIndex")
                
                defaults.synchronize()
                
                return false
            }
        } else {
            print("FILE DOESN'T EXISTS")
            return false
        }
        
        
    }
}
