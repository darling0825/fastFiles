//
//  TableViewController.swift
//  fastFiles
//
//  Created by Adrian on 15.04.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import NMSSH
import UserNotifications

class SFTPTableViewController: UITableViewController {

    var dir = "~"
    var files = [String]()
    var isDir = [Bool]()
    
    var notificationFile = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ListFiles()
        
        print(isDir)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return files.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "file", for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = files[indexPath.row]
        
        // Check if is a dir
        if isDir[indexPath.row] {
            (cell.viewWithTag(2) as! UIImageView).image = #imageLiteral(resourceName: "Folder")
        } else {
           (cell.viewWithTag(2) as! UIImageView).image = #imageLiteral(resourceName: "file")
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Check if is a dir
        if self.isDir[indexPath.row] { // Is dir
            print("IS DIR")
            self.dir = self.dir+"/"+self.files[indexPath.row]
            
            self.ListFiles()
            self.tableView.reloadData()
            
            print(self.dir)
        } else { // Download file
            
                let downloading = UIAlertController(title: "Downloading".localized, message: nil, preferredStyle: .alert)
            
                self.present(downloading, animated: true, completion: {
                    
                    let session = NMSSHSession.connect(toHost: UserDefaults.standard.string(forKey: "IP"), withUsername: UserDefaults.standard.string(forKey: "USER"))
                    if (session?.isConnected)! {
                        print("CONNECT!")
                        session?.authenticate(byPassword: UserDefaults.standard.string(forKey: "PASSWORD"))
                        if (session?.isAuthorized)! {
                            print("CONECTED!")
                            
                            session?.channel.downloadFile("\(self.dir)/\(self.files[indexPath.row])", to: App().delegate().docsURL.appendingPathComponent(self.files[indexPath.row]).path, progress: { (downloaded, toDownload) -> Bool in
                                
                                
                                print("\(Float(downloaded/toDownload)*100)%")
                                print(toDownload)
                                
                                if downloaded == toDownload {
                                    self.dismiss(animated: true, completion: {
                                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                        
                                        let content = UNMutableNotificationContent()
                                        content.title = self.files[indexPath.row]
                                        content.body = "File downloaded!".localized
                                        content.sound = UNNotificationSound.default()
                                        content.badge = 1
                                        content.categoryIdentifier = "FILE DOWNLOAED"
                                        
                                        let notification = UNNotificationRequest(identifier: "Downloaded", content: content, trigger: trigger)
                                        
                                        UNUserNotificationCenter.current().delegate = self
                                        
                                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                        UNUserNotificationCenter.current().add(notification) {(error) in
                                            if let error = error {
                                                print("ERROR: "+error.localizedDescription)
                                            }
                                        }
                                        
                                    })
                                }
                                
                                return true
                                
                                
                            })
                        }
                    }
                })
        }
    }

    
    @IBAction func Upload(_ sender: Any) { // Upload file
        // Menu
        let vc = UIDocumentMenuViewController(documentTypes: App().allowedUTIs(), in: .import)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cd(_ sender: Any) { // Change directory
        let alert = UIAlertController(title: "Type a directory".localized, message: "cd", preferredStyle: .alert)
        alert.addTextField { (textField) in
            let session = NMSSHSession.connect(toHost: UserDefaults.standard.string(forKey: "IP"), withUsername: UserDefaults.standard.string(forKey: "USER"))
            if (session?.isConnected)! {
                session?.authenticate(byPassword: UserDefaults.standard.string(forKey: "PASSWORD"))
                if (session?.isAuthorized)! {
                    let dir = try! session?.channel.execute("cd '\(self.dir)'; pwd") // Simplefy the path (Remove ../ etc.)
                    textField.placeholder = dir?.replacingOccurrences(of: "\n", with: "")
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
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dir = (alert.textFields?[0].text)!
            if self.dir == "" {
                self.dir = (alert.textFields?[0].placeholder)!
            }
            self.ListFiles()
            self.tableView.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
