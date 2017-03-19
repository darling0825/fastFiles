//
//  App.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

class App {
    func delegate() -> AppDelegate {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate
    }
    
    func allowedUTIs() -> [String] {
        return ["public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"]
    }
    
    let adID = "ca-app-pub-9214899206650515/7127479986"
    
    func iCloudDrive() -> URL? {
        return FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
    
    func downloadFromCloud(directory:String) {
        do {
            let files = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath:directory), includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants)
            
            for file in files {
                if file.lastPathComponent.hasPrefix(".") && file.pathExtension.lowercased() == "icloud" {
                    
                    var iCloudFileURL = file.deletingLastPathComponent()
                    iCloudFileURL = file
                    iCloudFileURL = iCloudFileURL.deletingPathExtension()
                    var str = iCloudFileURL.lastPathComponent
                    str.remove(at: str.startIndex)
                    str = iCloudFileURL.deletingLastPathComponent().appendingPathComponent(str).path
                    iCloudFileURL = URL(fileURLWithPath: str)
                    
                    do {
                        try FileManager.default.startDownloadingUbiquitousItem(at: iCloudFileURL)
                    } catch let error {
                        print("ERROR: \(error.localizedDescription)")
                    }
                    
                    print(iCloudFileURL)
                }
            }
            
        } catch let error {
            print("ERROR:\(error.localizedDescription)")
        }
    }
    
}

extension URL {
    var urlScheme: URL {
        
        return URL(string:self.absoluteString.replacingOccurrences(of: "file://", with: "files://"))!
    }
}
