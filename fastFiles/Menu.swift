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
                        
                        let downloading = UIAlertController(title: "Downloading".localized, message: "0%\n\(ByteCountFormatter().string(fromByteCount: 0)) / \(ByteCountFormatter().string(fromByteCount: 0))\n", preferredStyle: .alert)
                        
                        let progressDownload : UIProgressView = UIProgressView(progressViewStyle: .default)
                        progressDownload.tag = 1
                        progressDownload.setProgress(0, animated: true)
                        progressDownload.frame = CGRect(x: 10, y: 85, width: 250, height: 0)
                        downloading.view.addSubview(progressDownload)
                        
                        self.present(downloading, animated: true, completion: nil)
                        
                        let task = URLSession.shared.downloadTask(with: fileURL!, completionHandler: { (location, reponse, error) in
                            
                            self.checkForBytes.invalidate()
                            
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
                        
                        self.checkForBytes = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
                            let progress = Float(task.countOfBytesReceived)/Float(task.countOfBytesExpectedToReceive)
                            let size = ByteCountFormatter().string(fromByteCount: task.countOfBytesReceived)
                            let maxSize = ByteCountFormatter().string(fromByteCount: task.countOfBytesExpectedToReceive)
                            
                            if !progress.isNaN {
                                print("\(Int(progress*100))%")
                                downloading.message = "\(Int(progress*100))%\n\(size) / \(maxSize)\n"
                                (downloading.view.viewWithTag(1) as! UIProgressView).setProgress(progress, animated: true)
                            }
                            
                        }

                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Don't update".localized, style: .default, handler: { (UIAlertAction) in
                        self.performSegue(withIdentifier: "sourceCode", sender: nil)
                    }))

                    
                    if let controller = alert.popoverPresentationController {
                        controller.sourceView = self.view.viewWithTag(1384)
                    }
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                                        
                    let downloading = UIAlertController(title: "Downloading".localized, message: "0%\n\(ByteCountFormatter().string(fromByteCount: 0)) / \(ByteCountFormatter().string(fromByteCount: 0))\n", preferredStyle: .alert)
                    
                    let progressDownload : UIProgressView = UIProgressView(progressViewStyle: .default)
                    progressDownload.tag = 1
                    progressDownload.setProgress(0, animated: true)
                    progressDownload.frame = CGRect(x: 10, y: 85, width: 250, height: 0)
                    downloading.view.addSubview(progressDownload)
                    
                    self.present(downloading, animated: true, completion: nil)
                    
                    let task = URLSession.shared.downloadTask(with: fileURL!, completionHandler: { (location, reponse, error) in
                        
                        self.checkForBytes.invalidate()
                        
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
                    
                    self.checkForBytes = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
                        let progress = Float(task.countOfBytesReceived)/Float(task.countOfBytesExpectedToReceive)
                        let size = ByteCountFormatter().string(fromByteCount: task.countOfBytesReceived)
                        let maxSize = ByteCountFormatter().string(fromByteCount: task.countOfBytesExpectedToReceive)
                        
                        if !progress.isNaN {
                            print("\(Int(progress*100))%")
                            downloading.message = "\(Int(progress*100))%\n\(size) / \(maxSize)\n"
                            (downloading.view.viewWithTag(1) as! UIProgressView).setProgress(progress, animated: true)
                        }
                        
                    }
                    
                }
            }
            
            print(destination)
        }
    }
}


