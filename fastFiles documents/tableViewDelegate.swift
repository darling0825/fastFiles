//
//  tableViewDelegate.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension DocumentPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // Open file
        var isDir: ObjCBool = false
        
        do {
            if (docsContent?.indices.contains(indexPath.row))! {
                if FileManager.default.fileExists(atPath: (docsContent?[indexPath.row].path)!, isDirectory: &isDir) {
                    if isDir.boolValue {
                        docsContent = try FileManager.default.contentsOfDirectory(at: (docsContent?[indexPath.row])!, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                        TableView.reloadData()
                    } else {
                        dismissGrantingAccess(to: docsContent?[indexPath.row])
                    }
                }
            
            }
        } catch let error {
                let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
    }
}
