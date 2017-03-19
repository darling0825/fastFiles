//
//  UI.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Zip

/*
                                         UI
                                   Configuration
 */

extension BrowserTableViewController {
    
    func setItems() { // Set navigation bar items
        self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(image: #imageLiteral(resourceName: "paste.png"), style: .plain, target: self, action: #selector(Paste)))
        self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(image: #imageLiteral(resourceName: "zip.png"), style: .plain, target: self, action: #selector(self.zipFile)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(Add))
    }
    
    func checkForPasteboard() { // Check if pasteboard contains a file
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
            let delegate = UIApplication.shared.delegate as! AppDelegate
            if !delegate.background {
                if (UIPasteboard.general.string != nil) {
                    if (UIPasteboard.general.string?.contains("(copy)"))! || (UIPasteboard.general.string?.contains("(move)"))! {
                        self.navigationItem.rightBarButtonItems?[1].isEnabled = true
                    } else {
                        self.navigationItem.rightBarButtonItems?[1].isEnabled = false
                    }
                }
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // Configure cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "file", for: indexPath) // Cell
        let labelFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) // Label font
        let label:UILabel = cell.viewWithTag(2) as! UILabel // Label
        let image: UIImageView = cell.viewWithTag(3) as! UIImageView // Icon
        
        label.font = labelFont
        label.text = files[indexPath.row]
        
        cell.viewWithTag(5)?.isHidden = true
        
        let url = URL(fileURLWithPath: self.dir).appendingPathComponent(files[indexPath.row]) // Current file url
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: self.dir+"/"+files[indexPath.row], isDirectory: &isDir) { // Check if file exists
            do {
                if !isDir.boolValue { // Is a file
                    if UIImage(data: try Data(contentsOf: url)) != nil {
                        image.image = #imageLiteral(resourceName: "image.png") // Is image
                    } else if (try? AVAudioPlayer(contentsOf: url)) != nil {
                        image.image = #imageLiteral(resourceName: "audioVideo.png") // Is audio or video
                    } else if url.pathExtension.lowercased() == "pdf" {
                        image.image = #imageLiteral(resourceName: "pdf.png") // Is pdf
                    }else if url.pathExtension.lowercased() == "html" {
                        image.image = #imageLiteral(resourceName: "html.png") // Is HTML
                    } else if url.pathExtension.lowercased() == "zip" {
                        image.image = #imageLiteral(resourceName: "zipFile.png") // Is zip
                    } else if url.pathExtension.lowercased() == "swift" {
                        image.image = #imageLiteral(resourceName: "SwiftFile") // Is Swift
                    } else if url.pathExtension.lowercased() == "m" || url.pathExtension.lowercased() == "mm" {
                        image.image = #imageLiteral(resourceName: "OBJCFile") // Is Objective-C
                    } else if url.pathExtension.lowercased() == "py" {
                        image.image = #imageLiteral(resourceName: "PYFile") // Is Python
                    } else if url.pathExtension.lowercased() == "rtf" || url.pathExtension.lowercased() == "doc" || url.pathExtension.lowercased() == "docx" {
                        image.image = #imageLiteral(resourceName: "rtfFile") // Is RTF or Word
                    } else if url.pathExtension.lowercased() == "icloud" {
                        image.image = #imageLiteral(resourceName: "iCloud-Drive") // Is undownloaded file
                        cell.viewWithTag(5)?.isHidden = false
                        (cell.viewWithTag(5) as! UIActivityIndicatorView).startAnimating()
                        label.text?.remove(at: (label.text?.startIndex)!)
                        label.text = label.text?.replacingOccurrences(of: "."+url.pathExtension, with: "")
                    } else {
                        do {
                            let _ = try String(contentsOf: url, encoding: String.Encoding.utf8)
                            image.image = #imageLiteral(resourceName: "file.png") // Is unknown file
                        } catch let error {
                            print("ERROR: \(error.localizedDescription)")
                            image.image = #imageLiteral(resourceName: "file")
                        }
                    }
                } else {
                    image.image = #imageLiteral(resourceName: "Folder") // Is directory
                    
                    if label.text == ".Trash" {
                        image.image = #imageLiteral(resourceName: "Trash") // Is the trash
                        label.text = ""
                    }
                }
            } catch let error {
                image.image = #imageLiteral(resourceName: "file")
                print("ERROR: \(error.localizedDescription)")
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // Did select row
        
        let url = URL(string: "file://")!.appendingPathComponent(dir).appendingPathComponent(files[indexPath.row]) // File URL
        
        
        // Save to history
        
        var history = [URL]()
        
        let defaults = UserDefaults(suiteName: "group.marcela.ada.files")
        if defaults?.array(forKey: "history") != nil {
            let data = defaults?.array(forKey: "history") as? [Data]
            history = (data?.map { URL(dataRepresentation: $0, relativeTo: nil)! })!
            if history.contains(url) {
                history.append(url)
                history.remove(at: 0)
            } else {
                history.append(url)
            }
        }
        
        
        let urlsData = history.map { $0.dataRepresentation }
        defaults?.set(urlsData, forKey: "history")
        defaults?.synchronize()
        
        print(history)
        
        self.tableView.deselectRow(at: indexPath, animated: true) // Deselect row
        
        var isDir: ObjCBool = false
        
        if zip { // If app is requesting for select files to zip
            let cell = tableView.cellForRow(at: indexPath)
            if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
                cell?.accessoryType = .none
                
            } else {
                cell?.accessoryType = .checkmark
            }
        }
        
        if FileManager.default.fileExists(atPath: dir+"/"+files[indexPath.row]+"", isDirectory: &isDir) && !zip { // Check if file exists
            
            print("FILE EXISTS")
            
            if isDir.boolValue { // Is directory
                
                print("IS DIR")
                
                nextDir = dir+"/"+files[indexPath.row]+"/" // Directory path
                
                // Open directory
                if self.restorationIdentifier == "first" {
                    self.performSegue(withIdentifier: "files", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "files2", sender: nil)
                }
            } else { // Is file
                
                print("IS FILE")
                
                
                print(url)
                
                do {
                    
                    if UIImage(data: try Data(contentsOf: url)) != nil { // Is image
                        print("IS IMAGE")
                        imageURL = url
                        self.performSegue(withIdentifier: "image", sender: nil) // Open image
                    } else if (try? AVAudioPlayer(contentsOf: url)) != nil { // Is audio or video
                        let alert = UIAlertController(title: "Open with...", message: "Do you want to open this file as audio or video? (2 choices are correct)", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "As Video", style: .default, handler: { (UIAlertAction) in // Open as video
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Stop"), object: nil)
                            self.player = AVPlayer(url: url)
                            let playerViewController = AVPlayerViewController()
                            playerViewController.player = self.player
                            self.player.play()
                            
                            let audioSession = AVAudioSession.sharedInstance()
                            try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
                            
                            self.present(playerViewController, animated: true, completion: nil)
                        }))
                        
                        alert.addAction(UIAlertAction(title: "As Audio", style: .default, handler: { (UIAlertAction) in // Open as audio
                            self.imageURL = url
                            self.performSegue(withIdentifier: "audio", sender: nil)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    } else if url.pathExtension.lowercased() == "pdf" || url.pathExtension.lowercased() == "doc" || url.pathExtension.lowercased() == "docx" { // Is PDF or Word
                        imageURL = url
                        self.performSegue(withIdentifier: "PDF", sender: self) // Open PDF
                    } else if url.pathExtension.lowercased() == "zip" { // Is ZIP
                        do {
                            let zipURL = try Zip.quickUnzipFile(url) // Unzip file
                            let newURL = URL(fileURLWithPath:self.dir).appendingPathComponent(zipURL.lastPathComponent)
                            try FileManager.default.moveItem(at: zipURL, to: newURL)
                            self.reload()
                            nextDir = (newURL.absoluteString.replacingOccurrences(of: "file://", with: "").removingPercentEncoding!) // Unzipped directory path
                            
                            // Open unzipped directory
                            if self.restorationIdentifier == "first" {
                                self.performSegue(withIdentifier: "files", sender: nil)
                            } else {
                                self.performSegue(withIdentifier: "files2", sender: nil)
                            }
                        } catch let error {
                            let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        do {
                            let _ = try String(contentsOf: url) // Continue if is text
                            imageURL = url
                            print("IS TEXt")
                            self.performSegue(withIdentifier: "text", sender: nil)
                        } catch let error {
                            let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                } catch let error {
                    let alert = UIAlertController(title: "Error!", message: error.localizedDescription+"\n\n\(url)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                        _ = self.navigationController?.popViewController(animated: true)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            print("FILE DOES NOT EXISTS")
        }
    }

    
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        
        if action == #selector(copy(_:)) { // Did select "Copy"
            UIPasteboard.general.string = "(copy) \(dir+"/"+files[indexPath.row])"
        }
        
        if action == #selector(cut(_:)) { // Did select "Cut"
            UIPasteboard.general.string = "(move) \(dir+"/"+files[indexPath.row])"
            files.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool { // Show:
        
        if action == #selector(copy(_:)) /*Copy*/ || action == #selector(cut(_:)) /*Cut*/ {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool { // Show menu at holding on cell
        return true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { // Number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // Number of rows
        return files.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? { // Swipe actions
        
        let delete = UITableViewRowAction(style: .default, title: "      ") { (UITableViewRowAction, IndexPath) in // Remove file
            
            do {
                try FileManager.default.removeItem(atPath: self.dir+"/"+self.files[indexPath.row])
                self.files.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch let error {
                let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        let share = UITableViewRowAction(style: .normal, title: "      ") { (UITableViewRowAction, IndexPath) in // Share file
            let url = URL(string: ("file://"+self.dir+"/"+self.files[indexPath.row]).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
            
            let shareController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
            shareController.popoverPresentationController?.sourceView = self.view
            self.present(shareController, animated: true, completion: nil)
        }
        
        let rename = UITableViewRowAction(style: .normal, title: "      ") { (UITableViewRowAction, IndexPath) in // Rename file
            let url = URL(string: ("file://"+self.dir+"/"+self.files[indexPath.row]).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
            
            self.renameAlert = UIAlertController(title: "Rename", message: "Select new file name", preferredStyle: .alert)
            self.renameAlert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { (UIAlertAction) in
                do {
                    if self.renameAlert.textFields?[1].text == "" {
                        try FileManager.default.moveItem(at: url!, to: (url?.deletingLastPathComponent().appendingPathComponent((self.renameAlert.textFields?[0].text)!, isDirectory: false))!)
                    } else {
                        try FileManager.default.moveItem(at: url!, to: (url?.deletingLastPathComponent().appendingPathComponent(((self.renameAlert.textFields?[0].text)!+"."+(self.renameAlert.textFields?[1].text)!), isDirectory: false))!)
                    }
                    self.nextDir = self.dir
                    print("SEGUE")
                    self.reload()
                } catch let error {
                    self.dismiss(animated: true, completion: {
                        let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIKit.UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }))
            
            self.renameAlert.addTextField(configurationHandler: { (UITextField) in
                UITextField.placeholder = "File name"
                if url?.pathExtension != "" {
                    print(url!)
                    print(url!.pathExtension)
                    print("file://"+self.dir+"/"+(self.renameAlert.textFields?[0].text)!.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
                    UITextField.text = url?.deletingPathExtension().lastPathComponent
                }
            })
            
            self.renameAlert.addTextField(configurationHandler: { (UITextField) in
                UITextField.placeholder = "File extension"
                if url?.pathExtension != "" {
                    print(url!)
                    print(url!.pathExtension)
                    print("file://"+self.dir+"/"+(self.renameAlert.textFields?[0].text)!.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
                    UITextField.text = url?.pathExtension
                }
            })
            
            self.renameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(self.renameAlert, animated: true, completion: nil)
    
        }
        
        
        // Change buttons background color
        share.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "share"))
        rename.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "edit"))
        delete.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "delete"))
        
        return /*Show:*/[delete, rename, share]
    }

    
}
