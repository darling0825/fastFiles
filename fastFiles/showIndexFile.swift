//
//  showIndexFile.swift
//  fastFiles
//
//  Created by Adrian on 26.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import Down

extension BrowserTableViewController {
    func showIndexFile() {
        do {
            print("DIR: \(self.dir)")
            
            let files = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath:self.dir), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            print("CONTINUE!")
            
            for file in files {
                print("FILE: \(file.absoluteString)")
                if let code = try? String.init(contentsOf: file) {
                
                    print("FILE: \(file.absoluteString), code: \(code)")
                
                    if file.lastPathComponent == "README.md" {
                        let md = try Down(markdownString: code).toHTML()
                        indexFile.loadHTMLString(md, baseURL: file.deletingLastPathComponent())
                        indexFile.isHidden = false
                        print("LOAD FILE")
                    }
                
                    if file.lastPathComponent == "index.html" {
                        indexFile.loadHTMLString(code, baseURL: file.deletingLastPathComponent())
                        indexFile.isHidden = false
                        print("LOAD FILE")
                    }
                }
            }
            
        } catch let error {
            print("ERROR: "+error.localizedDescription)
        }
    }
}
