//
//  List files.swift
//  fastFiles
//
//  Created by Adrian on 15.04.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import NMSSH

extension SFTPTableViewController {
    func ListFiles() {
        // List files in server
        
        let session = NMSSHSession.connect(toHost: UserDefaults.standard.string(forKey: "IP"), withUsername: UserDefaults.standard.string(forKey: "USER"))
        if (session?.isConnected)! {
            print("CONNECT!")
            session?.authenticate(byPassword: UserDefaults.standard.string(forKey: "PASSWORD"))
            if (session?.isAuthorized)! {
                print("CONECTED!")
                do {
                    
                    if dir == "~" {
                        dir = try session!.channel.execute("pwd").replacingOccurrences(of: "\n", with: "")
                    }
                    
                    let response = try session!.channel.execute("ls '\(dir)'")
                    files = response.components(separatedBy: "\n")
                    isDir = []
                    
                    // Add ../
                    if (try! session!.channel.execute("cd '\(dir)'; pwd") != "/") {
                        files.insert("../", at: 0)
                    }
                    
                    // Remove .
                    files.removeLast()
                    
                    for file in files {
                                                                        
                        let response = try session?.channel.execute("if [ -d '\(dir)/\(file)' ]; then echo 'IS DIR'; fi")
                        if response != "" { // Is dir
                            isDir.append(true)
                        } else {
                            isDir.append(false)
                        }
                        
                        print(file)
                    }
                    
                } catch let error {
                    let alert = UIAlertController(title: "Error!".localized, message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Error!".localized, message: session!.lastError.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error!".localized, message: session!.lastError.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
