//
//  Other functions.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import Zip

/*
                                       Other
                                     functions
 */

extension BrowserTableViewController {
    
    func reload() { // Reload table view content
        do {
            files = try FileManager.default.contentsOfDirectory(atPath: dir)
            print(files)
        } catch let error {
            let alert = UIAlertController(title: "Error!".localized, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.title = URL(fileURLWithPath: dir).lastPathComponent
        if self.title == "File Provider Storage" {
            self.title = "Documents"
        }
        self.tableView.reloadData()
        
        if URL(fileURLWithPath: dir) == App().iCloudDrive() {
            self.title = "iCloud"
        }
        
        // Load README.md or index.html
        indexFile.isHidden = true
        
        showIndexFile()
        
        if indexFile.isHidden {
            tableView.contentSize.height -= indexFile.frame.size.height
        }
        
    }
    
    
    func Add() { // Add file or directory
        
        // Menu
        let vc = UIDocumentMenuViewController(documentTypes: App().allowedUTIs(), in: .import)
        
        // import image / video
        vc.addOption(withTitle: "Import image".localized, image: UIImage().from(systemItem: .camera), order: .first) {
            DispatchQueue.global(qos: .background).async {
                self.pickImage()
            }
        }
        
        // Create file
        vc.addOption(withTitle: "Create".localized, image: UIImage().from(systemItem: .compose), order: .first) {
            let alert = UIAlertController(title: "Create a file / directory".localized, message: "Please select a file name".localized, preferredStyle: .alert)
            
            
            let addFile = UIAlertAction(title: "Add file".localized, style: .default) { (UIAlertAction) in // Add file button
                
                if alert.textFields?[1].text != "" {
                    FileManager.default.createFile(atPath: self.dir+"/"+((alert.textFields?[0].text!)!+"."+(alert.textFields?[1].text!)!), contents: nil, attributes: [:])
                    if !FileManager.default.fileExists(atPath: self.dir+"/"+((alert.textFields?[0].text!)!+"."+(alert.textFields?[1].text!)!)) {
                        let alert = UIAlertController(title: "Error!".localized, message: "Unknown error".localized, preferredStyle: .alert)
                        let ok = UIKit.UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.reload()
                        
                        var file = URL(fileURLWithPath: self.dir)
                        
                        file = file.appendingPathComponent(((alert.textFields?[0].text!)!+"."+alert.textFields![1].text!))
                        
                        
                        let files = try! FileManager.default.contentsOfDirectory(atPath: self.dir)
                        let nextFileIndex = files.index(of: file.lastPathComponent)
                        
                        self.tableView.selectRow(at: IndexPath(row: nextFileIndex!, section:0), animated: true, scrollPosition: .middle)
                        Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true, block: { (Timer) in
                            self.tableView.deselectRow(at: IndexPath(row: nextFileIndex!, section:0), animated: true)
                        })
                    }
                } else {
                    FileManager.default.createFile(atPath: self.dir+"/"+(alert.textFields?[0].text!)!, contents: nil, attributes: [:])
                    if !FileManager.default.fileExists(atPath: self.dir+"/"+(alert.textFields?[0].text!)!) {
                        let alert = UIAlertController(title: "Error!".localized, message: "Unknown error".localized, preferredStyle: .alert)
                        let ok = UIKit.UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.reload()
                        
                        var file = URL(fileURLWithPath: self.dir)
                        
                        file = file.appendingPathComponent(((alert.textFields?[0].text!)!))
                        
                        
                        let files = try! FileManager.default.contentsOfDirectory(atPath: self.dir)
                        let nextFileIndex = files.index(of: file.lastPathComponent)
                        
                        self.tableView.selectRow(at: IndexPath(row: nextFileIndex!, section:0), animated: true, scrollPosition: .middle)
                        Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true, block: { (Timer) in
                            self.tableView.deselectRow(at: IndexPath(row: nextFileIndex!, section:0), animated: true)
                        })
                    }
                }
            }
            
            alert.addAction(addFile)
            
            let addFolder = UIAlertAction(title: "Add folder".localized, style: .default) { (UIAlertAction) in // Add folder button
                if alert.textFields?[1].text != "" {
                    do {
                        try FileManager.default.createDirectory(atPath: self.dir+"/"+((alert.textFields?[0].text!)!+"."+(alert.textFields?[1].text!)!), withIntermediateDirectories: true, attributes: nil)
                    } catch let error {
                        let alert = UIAlertController(title: "Error!".localized, message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIKit.UIAlertAction(title:"Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    if !FileManager.default.fileExists(atPath: self.dir+"/"+((alert.textFields?[0].text!)!+"."+(alert.textFields?[1].text!)!)) {
                        let alert = UIAlertController(title: "Error!".localized, message: "Unknown error".localized, preferredStyle: .alert)
                        let ok = UIKit.UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.reload()
                        
                        var file = URL(fileURLWithPath: self.dir)
                        
                        file = file.appendingPathComponent(((alert.textFields?[0].text!)!+"."+alert.textFields![1].text!))
                        
                        
                        let files = try! FileManager.default.contentsOfDirectory(atPath: self.dir)
                        let nextFileIndex = files.index(of: file.lastPathComponent)
                        
                        self.tableView.selectRow(at: IndexPath(row: nextFileIndex!, section:0), animated: true, scrollPosition: .middle)
                        Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true, block: { (Timer) in
                            self.tableView.deselectRow(at: IndexPath(row: nextFileIndex!, section:0), animated: true)
                        })
                    }
                } else {
                    do {
                        try FileManager.default.createDirectory(atPath: URL(fileURLWithPath:self.dir+"/"+(alert.textFields?[0].text!)!).path, withIntermediateDirectories: true, attributes: nil)
                    } catch let error {
                        let alert = UIAlertController(title: "Error!".localized, message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIKit.UIAlertAction(title:"Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    if !FileManager.default.fileExists(atPath: self.dir+"/"+(alert.textFields?[0].text!)!) {
                        let alert = UIAlertController(title: "Error!".localized, message: "Unknown error".localized, preferredStyle: .alert)
                        let ok = UIKit.UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.reload()
                        
                        var file = URL(fileURLWithPath: self.dir)
                        
                        file = file.appendingPathComponent(((alert.textFields?[0].text!)!))
                        
                        
                        let files = try! FileManager.default.contentsOfDirectory(atPath: self.dir)
                        let nextFileIndex = files.index(of: file.lastPathComponent)
                        
                        self.tableView.selectRow(at: IndexPath(row: nextFileIndex!, section:0), animated: true, scrollPosition: .middle)
                        Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true, block: { (Timer) in
                            self.tableView.deselectRow(at: IndexPath(row: nextFileIndex!, section:0), animated: true)
                        })
                    }
                }
            }
            alert.addAction(addFolder)
            
            alert.addTextField { (UITextField) in
                UITextField.placeholder = "File name".localized
            }
            
            alert.addTextField { (UITextField) in
                UITextField.placeholder = "File Extension".localized
            }
            
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    func zipFile() { // Compress file
        
        if !zip { // Check if app is not already requesting for zip files
            zip = true
            
            let alert = UIAlertController(title: "Please select files to compress".localized, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            navigationItem.rightBarButtonItems?[2] = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(self.zipFile))
        } else { // Zip files
            
            navigationItem.rightBarButtonItems?[2] = UIBarButtonItem(image: #imageLiteral(resourceName: "zip.png"), style: .plain, target: self, action: #selector(self.zipFile))
            
            var filesName: [String] = []
            
            for cell in self.tableView.visibleCells {
                if cell.accessoryType == .checkmark {
                    if (cell.viewWithTag(4) as! UILabel).text == "" {
                        filesName.append(((cell.viewWithTag(2) as! UILabel).text!))
                        cell.accessoryType = .none
                    } else {
                        filesName.append(((cell.viewWithTag(2) as! UILabel).text!+"."+(cell.viewWithTag(4) as! UILabel).text!))
                        cell.accessoryType = .none
                    }
                }
            }
            
            let filesList = filesName.joined(separator: "\n")
            
            let createAlert = UIAlertController(title: "Compress".localized, message: "\(filesList)", preferredStyle: .alert)
            createAlert.addAction(UIAlertAction(title: "Create".localized, style: .default, handler: { (UIAlertAction) in
                do {
                    print("ZIP TO CREATE: \n"+self.dir+"/"+(createAlert.textFields?[0].text)!)
                    let files = filesList.components(separatedBy: "\n")
                    
                    for file in files {
                        print("FILE TO ZIP:")
                        print(self.dir+"/"+file)
                        print(files.count)
                    }
                    
                    
                    let alert = UIAlertController(title: "\n\n\n\nCompressing".localized, message: nil, preferredStyle: .alert)
                    
                    let indicator = UIActivityIndicatorView(frame: alert.view.bounds)
                    indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    indicator.color = .black
                    
                    alert.view.addSubview(indicator)
                    indicator.isUserInteractionEnabled = false
                    indicator.startAnimating()
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    var filesURL = [URL]()
                    for fileName in filesName {
                        print(fileName)
                        filesURL.append((URL(string:self.dir.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)!.appendingPathComponent(fileName)))
                    }
                    
                    let zipFile = try Zip.quickZipFiles(filesURL, fileName: (createAlert.textFields?[0].text)!)
                    
                    try FileManager.default.moveItem(at: zipFile, to: App().delegate().docsURL.appendingPathComponent(zipFile.lastPathComponent))
                    
                    self.reload()
                    
                    let files_ = try! FileManager.default.contentsOfDirectory(atPath: self.dir)
                    print(files_)
                    let nextFileIndex = files_.index(of: zipFile.lastPathComponent)
                    print(zipFile.lastPathComponent)
                    
                    self.tableView.selectRow(at: IndexPath(row: nextFileIndex!, section:0), animated: true, scrollPosition: .middle)
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
                        self.tableView.deselectRow(at: IndexPath(row: nextFileIndex!, section:0), animated: true)
                    })
                    
                    self.dismiss(animated: false, completion: nil)
                    
                } catch let error {
                    self.dismiss(animated: true, completion: {
                        let alert = UIAlertController(title: "Error!".localized, message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIKit.UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }))
            
            createAlert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            createAlert.addTextField(configurationHandler: { (UITextField) in
                UITextField.placeholder = "New file name (without extension)".localized
            })
            
            self.present(createAlert, animated: true, completion: nil)
            
            zip = false
        }
    }
    
    
    func Paste() { // Paste file
        
        if UIPasteboard.general.string == nil {
            
            let alert = UIAlertController(title: "Error!".localized, message: "Nothing in clipboard!".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        var path = ""
        
        if (UIPasteboard.general.string?.contains("(copy)"))! { // Copy file
            path = (UIPasteboard.general.string?.replacingOccurrences(of: "(copy) ", with: ""))!
            print(path)
            do {
                try FileManager.default.copyItem(atPath: path, toPath: dir+"/"+(URL(string:"file://"+path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)?.lastPathComponent)!)
            } catch let error {
                let alert = UIAlertController(title: "Error!".localized, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else if (UIPasteboard.general.string?.contains("(move)"))! { // Move file
            path = (UIPasteboard.general.string?.replacingOccurrences(of: "(move) ", with: ""))!
            do {
                try FileManager.default.moveItem(atPath: path, toPath: dir+"/"+(URL(string:"file://"+path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)?.lastPathComponent)!)
            } catch let error {
                let alert = UIAlertController(title: "Error!".localized, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error!".localized, message: "Nothing in clipboard!".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        UIPasteboard.general.string = ""
        
        nextDir = dir
        
        self.reload()
        
        print("PASTE")
    }
}
