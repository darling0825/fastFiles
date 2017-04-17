//
//  DownloadViewController.swift
//  fastFiles
//
//  Created by Adrian on 21.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import UserNotifications

class DownloadViewController: UIViewController, UIWebViewDelegate {

    // Variables
    
    
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var download: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var loading: UIProgressView!
    
    
    var fileURL = URL(string:"")
    var finalDest = URL(string:"")
    
    var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    var checkForBytes = Timer()
    
    //Actions
    
    @IBAction func downloadFile(_ sender: Any) {
        
        print("DOWNLOAD FILE")
            
        let task = URLSession.shared.downloadTask(with: self.fileURL!, completionHandler: { (location, reponse, error) in
            
            self.checkForBytes.invalidate()
            
            if error == nil {
                print(location!.absoluteString)
                self.url.resignFirstResponder()
                do {
                    self.finalDest = App().delegate().docsURL.appendingPathComponent(reponse!.suggestedFilename!)
                    print("FILE NAME: "+(reponse?.suggestedFilename)!)
                    print(try FileManager.default.contentsOfDirectory(atPath: location!.deletingLastPathComponent().path))
                    print(self.finalDest!)
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    
                    let content = UNMutableNotificationContent()
                    content.title = "\(reponse!.suggestedFilename!)"
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
                    
                    try FileManager.default.moveItem(at: location!, to: self.finalDest!)
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: {
                            self.blur.isHidden = true
                        })
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: {
                            self.blur.isHidden = true
                            self.navigationController?.isNavigationBarHidden = false
                            print(error.localizedDescription)
                            let alert = UIAlertController(title: "Error!".localized, message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIKit.UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        })
                    }
                }
                
            } else {
                print("ERRROR")
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: {
                        self.blur.isHidden = true
                        let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }
            
        })
        
        task.resume()
        
        let downloading = UIAlertController(title: "Downloading".localized, message: "0%\n\(ByteCountFormatter().string(fromByteCount: 0)) / \(ByteCountFormatter().string(fromByteCount: 0))\n", preferredStyle: .alert)
        
        let progressDownload : UIProgressView = UIProgressView(progressViewStyle: .default)
        progressDownload.tag = 1
        progressDownload.setProgress(0, animated: true)
        progressDownload.frame = CGRect(x: 10, y: 85, width: 250, height: 0)
        downloading.view.addSubview(progressDownload)
        
        downloading.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (UIAlertAction) in
            task.cancel(byProducingResumeData: { (data) in
                print("CANCEL")
            })
        }))
        
        self.blur.isHidden = false
        self.present(downloading, animated: true, completion: nil)
        
        checkForBytes = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
            let progress = Float(task.countOfBytesReceived)/Float(task.countOfBytesExpectedToReceive)
            let size = ByteCountFormatter().string(fromByteCount: task.countOfBytesReceived)
            let maxSize = ByteCountFormatter().string(fromByteCount: task.countOfBytesExpectedToReceive)
            
            if !progress.isNaN {
                if progress*100 >= 0 {
                    print("\(Int(progress*100))%")
                    downloading.message = "\(Int(progress*100))%\n\(size) / \(maxSize)\n"
                    (downloading.view.viewWithTag(1) as! UIProgressView).setProgress(progress, animated: true)
                } else {
                    print("?%")
                    downloading.message = "???\n\(size) / ???\n"
                    (downloading.view.viewWithTag(1) as! UIProgressView).setProgress(1, animated: false)
                    (downloading.view.viewWithTag(1) as! UIProgressView).tintColor = UIColor.black
                }
            }
            
        }
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        fileURL = request.url!
        
        self.loading.setProgress(0.25, animated: true)
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loading.setProgress(1, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (Timer) in // Hide progress bar
            self.loading.setProgress(0, animated: false)
        }
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.loading.setProgress(1, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (Timer) in // Hide progress bar
            self.loading.setProgress(0, animated: false)
        }
        
        
        if error.localizedDescription == "Frame load interrupted".localized { // Is downloadable file
            downloadFile(self)
        } else {
            let alert = UIAlertController(title: "Error!".localized, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
