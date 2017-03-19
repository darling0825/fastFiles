//
//  tableViewDataSource.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

extension MessagesViewController: UITableViewDataSource {
    @available(iOSApplicationExtension 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.TableView.dequeueReusableCell(withIdentifier: "file")
        let labelFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) // Label font
        let label:UILabel = cell?.viewWithTag(1) as! UILabel // Label
        let image:UIImageView = cell?.viewWithTag(2) as! UIImageView // Icon
        
        label.font = labelFont // Set label font
        
        var url: URL!
        
        label.text = docsContent?[indexPath.row].lastPathComponent // Set label text
        url = self.docsContent?[indexPath.row]
        
        
        
        var isDir: ObjCBool = false
        
        if FileManager.default.fileExists(atPath: (self.docsContent?[indexPath.row].absoluteString.removingPercentEncoding?.replacingOccurrences(of: "file://", with: ""))!, isDirectory: &isDir) { // Check if file exists
            do {
                if !isDir.boolValue { // Is file
                    if UIImage(data: try Data(contentsOf: url)) != nil { // Is image
                        image.image = #imageLiteral(resourceName: "image.png")
                    } else if (try? AVAudioPlayer(contentsOf: url)) != nil { // Is audio or video
                        image.image = #imageLiteral(resourceName: "audioVideo.png")
                    } else if url.pathExtension.lowercased() == "pdf" { // Is pdf
                        image.image = #imageLiteral(resourceName: "pdf.png")
                    }else if url.pathExtension.lowercased() == "html" { // Is HTML
                        image.image = #imageLiteral(resourceName: "html.png")
                    } else if url.pathExtension.lowercased() == "zip" { // Is zip
                        image.image = #imageLiteral(resourceName: "zipFile.png")
                    } else if url.pathExtension.lowercased() == "swift" {
                        image.image = #imageLiteral(resourceName: "SwiftFile") // Is Swift
                    } else if url.pathExtension.lowercased() == "m" || url.pathExtension.lowercased() == "mm" {
                        image.image = #imageLiteral(resourceName: "OBJCFile") // Is Objective-C
                    } else if url.pathExtension.lowercased() == "py" {
                        image.image = #imageLiteral(resourceName: "PYFile") // Is Python
                    } else if url.pathExtension.lowercased() == "rtf" || url.pathExtension.lowercased() == "doc" || url.pathExtension.lowercased() == "docx" {
                        image.image = #imageLiteral(resourceName: "rtfFile") // Is RTF or Word∫
                    } else if url.pathExtension.lowercased() == "icloud" {
                        image.image = #imageLiteral(resourceName: "iCloud-Drive") // Is undownloaded file
                        label.text?.remove(at: (label.text?.startIndex)!)
                        label.text = label.text?.replacingOccurrences(of: "."+url.pathExtension, with: "")
                    } else {
                        do {
                            let _ = try String(contentsOf: url, encoding: String.Encoding.utf8)
                            image.image = #imageLiteral(resourceName: "file") // Is file
                        } catch let error { // Is unkown file
                            print("ERROR: \(error.localizedDescription)")
                            image.image = #imageLiteral(resourceName: "file")
                        }
                    }
                } else {
                    image.image = #imageLiteral(resourceName: "Folder") // Is folder
                }
            } catch let error {
                print("ERROR: \(error.localizedDescription)")
            }
        }
        
        return cell!
    }

    @available(iOSApplicationExtension 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let docs = try FileManager.default.contentsOfDirectory(at: (FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:"group.marcela.ada.files")!.appendingPathComponent("File Provider Storage")), includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            if docsContent! == docs {
                backButton.isEnabled = false
            } else {
                backButton.isEnabled = true
            }
        } catch _ {
            
        }
        
        return (docsContent?.count)!
    }


    
}
