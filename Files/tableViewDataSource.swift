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

extension TodayViewController: UITableViewDataSource {
    
    @available(iOSApplicationExtension 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // Number of rows
        let publicDocs = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.marcela.ada.files")!.appendingPathComponent("File Provider Storage")
        _ = try? FileManager.default.contentsOfDirectory(at: publicDocs, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        
        
        return self.docsContent.count
        
    }

    @available(iOSApplicationExtension 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // Configure cell
        let cell = self.TableView.dequeueReusableCell(withIdentifier: "file")
        let labelFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) // Label font
        let label:UILabel = cell?.viewWithTag(1) as! UILabel // Label
        let image:UIImageView = cell?.viewWithTag(2) as! UIImageView // Icon
        
        label.font = labelFont // Set label font
        
        
        label.text = docsContent?[indexPath.row].lastPathComponent // Set label text
        
        image.image = #imageLiteral(resourceName: "Icon")
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        
        return cell!
    }

    
}
