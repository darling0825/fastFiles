//
//  UIDocumentPickerDelegate.swift
//  fastFiles
//
//  Created by Adrian on 15.04.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import NMSSH

extension SFTPTableViewController: UIDocumentMenuDelegate, UIDocumentPickerDelegate {
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
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
                    
                    let _ = session?.channel.uploadFile(url.path, to: dir+"/"+url.lastPathComponent)
                    
                    self.present(UIAlertController.init(title: "Uploading...".localized, message: nil, preferredStyle: .alert), animated: true, completion: nil)
                    
                    //while !uploaded! {}
                    
                    print("UPLOADED!")
                    self.dismiss(animated: true, completion: {
                        self.ListFiles()
                        self.tableView.reloadData()
                    })
                    
                    
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
