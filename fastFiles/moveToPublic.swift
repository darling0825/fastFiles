//
//  moveToPublic.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension AppDelegate {
    func moveToPublic() { // Move files imported with iTunes to public documents folder
        docsURL = (FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:"group.marcela.ada.files")!.appendingPathComponent("File Provider Storage"))
        docsPath = (docsURL.absoluteString.removingPercentEncoding?.replacingOccurrences(of: "file://", with: ""))!
        
        if !FileManager.default.fileExists(atPath: docsURL.path) {
            do {
                try FileManager.default.createDirectory(at: docsURL, withIntermediateDirectories: true, attributes: [:])
            } catch let error {
                print("ERROR: \(error.localizedDescription)")
            }
        }
        
        let docs = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]
        do {
            let docsContent = try FileManager.default.contentsOfDirectory(at: docs, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for file in docsContent {
                if !FileManager.default.fileExists(atPath: docsPath+"/"+file.lastPathComponent) {
                    do {
                        try FileManager.default.moveItem(at: file, to: docsURL.appendingPathComponent(file.lastPathComponent))
                    } catch let error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
            
        } catch let error {
            print("ERROR: \(error.localizedDescription)")
        }
        
        print(docsPath)
    }
}
