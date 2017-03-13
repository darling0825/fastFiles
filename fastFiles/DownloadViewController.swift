//
//  DownloadViewController.swift
//  fastFiles
//
//  Created by Adrian on 21.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit


class DownloadViewController: UIViewController, UIWebViewDelegate {

    // Variables
    
    
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var download: UIButton!
    @IBOutlet weak var customName: UITextField!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var google: UITextField!
    @IBOutlet weak var blur: UIVisualEffectView!
   
    var terminationStatus = ""
    
    var finalDest = URL(string:"")
    
    var fileURL = URL(string:"")
    

    //Actions
    
    @IBAction func downloadFile(_ sender: Any) {
        
        print("DOWNLOAD FILE")
        
        let docs = App().delegate().docsPath
        var destination = ""
        
        print(self.fileURL!)
        if self.fileURL!.lastPathComponent != "" {
            destination = docs+"/"+self.fileURL!.lastPathComponent
            } else {
                destination = docs+"/Downloaded file"
            }
    
        print(docs+"/"+self.fileURL!.lastPathComponent)
        
        if customName.text != "" {
            if self.fileURL!.lastPathComponent != "" {
                destination = docs+"/"+(customName.text)!+"."+(self.fileURL!.pathExtension)
            } else {
                destination = docs+"/"+(customName.text)!
            }
        }
        
        if destination.hasSuffix(".") {
            destination.remove(at: destination.index(before: destination.endIndex))
        }
        
        let destinationURL = URL(fileURLWithPath: destination)
        
        
        if true {
            print("CONTINUE DOWNLOAD")
            if FileManager.default.fileExists(atPath: destination) {
                let alert = UIAlertController(title: "Error!", message: "This file has been already downloaded!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                
                print("DOWNLOAD!!!")
                
                let alert = UIAlertController(title: "\n\n\n\nDownloading", message: nil, preferredStyle: .alert)
            
                let indicator = UIActivityIndicatorView(frame: alert.view.bounds)
                indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                indicator.color = .black
            
                alert.view.addSubview(indicator)
                indicator.isUserInteractionEnabled = false
                indicator.startAnimating()
            
                self.blur.isHidden = false
                self.navigationController?.isNavigationBarHidden = true
                self.present(alert, animated: true, completion: nil)
            
                let task = URLSession.shared.downloadTask(with: self.fileURL!, completionHandler: { (location, reponse, error) in
                
                    if error == nil {
                        do {
                            self.finalDest = destinationURL
                            self.url.resignFirstResponder()
                            try FileManager.default.moveItem(at: location!, to: destinationURL)
                            self.terminationStatus = "Success"
                        } catch let moveError {
                            self.terminationStatus = moveError.localizedDescription
                        }
                    } else {
                        print("ERRROR")
                        self.dismiss(animated: false, completion: {
                            self.blur.isHidden = true
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
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        fileURL = request.url!
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        customName.text = ""
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        downloadFile(self)
    }
    
}
