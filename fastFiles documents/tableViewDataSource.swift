//
//  tableViewDataSource.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import Zip
import AVFoundation
import AVKit

extension DocumentPickerViewController: UITableViewDataSource {
    
    @available(iOSApplicationExtension 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // Number of rows
        
        let publicDocs = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.marcela.ada.files")!.appendingPathComponent("File Provider Storage")
        self.docsContent = try! FileManager.default.contentsOfDirectory(at: publicDocs, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        
        return self.docsContent.count
    }

    @available(iOSApplicationExtension 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // Configure cell
        let cell = self.TableView.dequeueReusableCell(withIdentifier: "file")
        let labelFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) // Label font
        let label:UILabel = cell?.viewWithTag(1) as! UILabel // Label
        let image:UIImageView = cell?.viewWithTag(2) as! UIImageView // Icon
        
        label.text = docsContent[indexPath.row].lastPathComponent // Set label text
        label.font = labelFont // Set label font
        
        var isDir: ObjCBool = false
        let url = self.docsContent[indexPath.row]
        if FileManager.default.fileExists(atPath: (self.docsContent[indexPath.row].absoluteString.removingPercentEncoding?.replacingOccurrences(of: "file://", with: ""))!, isDirectory: &isDir) { // Check if file exists
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

    
}
