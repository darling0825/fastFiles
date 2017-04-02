//
//  downloadFromCloud.swift
//  fastFiles
//
//  Created by Adrian on 01.04.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension BrowserTableViewController {
    func downloadFromCloud() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in // Check if iCloud files are downloaded
            
            do {
                let files = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath:self.dir), includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsPackageDescendants)
                
                var undownloadedFiles = 0
                for file in files {
                    if file.pathExtension.lowercased() == "icloud" && file.lastPathComponent.hasPrefix(".") {
                        undownloadedFiles+=1
                    }
                }
                
                if undownloadedFiles == 0 {
                    Timer.invalidate()
                    self.reload()
                } else {
                    undownloadedFiles = 0
                }
                
            } catch let error {
                print("ERROR: \(error.localizedDescription)")
            }
            
        }
    }
}
