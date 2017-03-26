//
//  Menu.swift
//  fastFiles
//
//  Created by Adrian on 24.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import Zip

/*
                                                                    Main
                                                                    menu
 */

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(indexPath.row)")!
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        
        // Download source code
        
        let fileURL = URL(string:"https://github.com/ColdGrub1384/fastFiles/archive/master.zip")
        if indexPath.row == 5 {
            print("DOWNLOAD FILE")
            
            let docs = App().libraryPath
            var destination = ""
            
            print(fileURL!)
            if fileURL!.lastPathComponent != "" {
                destination = docs+"/"+fileURL!.lastPathComponent
            } else {
                destination = docs+"/Source Code"
            }
            
            
            let destinationURL = URL(fileURLWithPath: destination)
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in // A timer
                
                if self.terminationStatus != "" { // Check if a download is finished
                    self.dismiss(animated: false, completion: { // Dismiss alert
                        self.terminationStatus = "" // Reset termination status
                        self.performSegue(withIdentifier: "sourceCode", sender: nil)
                        return
                    })
                    
                }
            }

            
            if true {
                print("CONTINUE DOWNLOAD")
                
                if FileManager.default.fileExists(atPath: App().libraryURL.appendingPathComponent("fastFiles").path) {
                    let alert = UIAlertController(title: "Source code".localized, message: "Do you want to update the source code, or open the latest downloaded version?".localized, preferredStyle: .actionSheet)
                    
                    alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                    
                    alert.addAction(UIAlertAction(title: "Update".localized, style: .default, handler: { (UIAlertAction) in
                        print("DOWNLOAD!!!")
                        
                        try! FileManager.default.removeItem(at: App().libraryURL.appendingPathComponent("fastFiles"))
                        
                        let alert = UIAlertController(title: "\n\n\n\nDownloading".localized, message: nil, preferredStyle: .alert)
                        
                        let indicator = UIActivityIndicatorView(frame: alert.view.bounds)
                        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        indicator.color = .black
                        
                        alert.view.addSubview(indicator)
                        indicator.isUserInteractionEnabled = false
                        indicator.startAnimating()
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        let task = URLSession.shared.downloadTask(with: fileURL!, completionHandler: { (location, reponse, error) in
                            
                            if error == nil {
                                do {
                                    try FileManager.default.moveItem(at: location!, to: destinationURL.deletingLastPathComponent().appendingPathComponent("fastFiles.zip"))
                                    
                                    do {
                                        self.finalDest = try Zip.quickUnzipFile(destinationURL.deletingLastPathComponent().appendingPathComponent("fastFiles.zip"))
                                        try FileManager.default.moveItem(at: self.finalDest, to: destinationURL.deletingLastPathComponent().appendingPathComponent("fastFiles"))
                                        try FileManager.default.removeItem(at: destinationURL.deletingLastPathComponent().appendingPathComponent("fastFiles.zip"))
                                    } catch let error {
                                        print("ERROR: "+error.localizedDescription)
                                    }
                                    
                                    self.terminationStatus = "Success"
                                    
                                } catch let moveError {
                                    self.terminationStatus = moveError.localizedDescription
                                }
                            } else {
                                print("ERRROR")
                                self.dismiss(animated: false, completion: {
                                    self.navigationController?.isNavigationBarHidden = false
                                    let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                                    alert.addAction(UIKit.UIAlertAction(title: "Ok", style: .default, handler:nil))
                                    self.present(alert, animated: true, completion: nil)
                                })
                            }
                            
                        })
                        
                        task.resume()
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Don't update".localized, style: .default, handler: { (UIAlertAction) in
                        self.performSegue(withIdentifier: "sourceCode", sender: nil)
                    }))

                    
                    if let controller = alert.popoverPresentationController {
                        controller.sourceView = self.view.viewWithTag(1384)
                    }
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    print("DOWNLOAD!!!")
                    
                    let alert = UIAlertController(title: "\n\n\n\nDownloading".localized, message: nil, preferredStyle: .alert)
                    
                    let indicator = UIActivityIndicatorView(frame: alert.view.bounds)
                    indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    indicator.color = .black
                    
                    alert.view.addSubview(indicator)
                    indicator.isUserInteractionEnabled = false
                    indicator.startAnimating()
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    let task = URLSession.shared.downloadTask(with: fileURL!, completionHandler: { (location, reponse, error) in
                        
                        if error == nil {
                            do {
                                try FileManager.default.moveItem(at: location!, to: destinationURL.deletingLastPathComponent().appendingPathComponent("fastFiles.zip"))
                                
                                do {
                                    self.finalDest = try Zip.quickUnzipFile(destinationURL.deletingLastPathComponent().appendingPathComponent("fastFiles.zip"))
                                    try FileManager.default.moveItem(at: self.finalDest, to: destinationURL.deletingLastPathComponent().appendingPathComponent("fastFiles"))
                                    try FileManager.default.removeItem(at: destinationURL.deletingLastPathComponent().appendingPathComponent("fastFiles.zip"))
                                } catch let error {
                                    print("ERROR: "+error.localizedDescription)
                                }
                                
                                self.terminationStatus = "Success"
                                
                            } catch let moveError {
                                self.terminationStatus = moveError.localizedDescription
                            }
                        } else {
                            print("ERRROR")
                            self.dismiss(animated: false, completion: {
                                self.navigationController?.isNavigationBarHidden = false
                                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
                                self.present(alert, animated: true, completion: nil)
                            })
                        }
                        
                    })
                    
                    task.resume()
                }
            }
            
            print(destination)
        }
    }
}


