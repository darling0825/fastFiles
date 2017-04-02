//
//  ViewDid.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

/*                                    View did...
*/


extension BrowserTableViewController {
    
    override func viewDidAppear(_ animated: Bool) { // Appear
        super.viewDidAppear(true)
        
        reload()
        
        if nextSelectedRow.indices.contains(0) { // If app is requesting to select file
            self.tableView.selectRow(at: IndexPath(row: nextSelectedRow[0], section: 0), animated: true, scrollPosition: UITableViewScrollPosition.middle)
            Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false, block: { (Timer) in
                self.tableView.deselectRow(at: IndexPath(row: self.nextSelectedRow[0], section: 0), animated: true)
                self.tableView.delegate?.tableView!(self.tableView, didSelectRowAt: IndexPath(row: self.nextSelectedRow[0], section: 0))
                self.nextSelectedRow = []
                self.downloadFromCloud()
            })
        } else {
            downloadFromCloud()
        }
        
        
        
        
    }
    
    // and...
    
    override func viewDidLoad() { // Load
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil) // Reload when app become active
        
        setItems() // Set navigation bar items
        checkForPasteboard() // Check if pasteboard contains a file
        
        
        do { // Get files in current directory
            files = try FileManager.default.contentsOfDirectory(atPath: dir)
            print(files)
        } catch let error {
            if self.dir != "/iCloud" {
                let alert = UIAlertController(title: "Error!".localized, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    _ = self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error!".localized, message: "Login to iCloud if you want to use this feature".localized, preferredStyle: .alert)
    
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    _ = self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        showAd() // Display ad
        
        if App().iCloudDrive() != nil {if dir.contains((App().iCloudDrive()?.path)!) {
            DispatchQueue.global(qos: .background).async {
                App().downloadFromCloud(directory: self.dir) // Download from iCloud Drive
            }
        }}
        
    }
}
