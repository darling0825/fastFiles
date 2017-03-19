//
//  IndexRequestHandler.swift
//  fastFiles search
//
//  Created by Adrian on 19.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices
import UIKit
import AVFoundation

class IndexRequestHandler: CSIndexExtensionRequestHandler {
    
    var docs = [URL]()

    override func searchableIndex(_ searchableIndex: CSSearchableIndex, reindexAllSearchableItemsWithAcknowledgementHandler acknowledgementHandler: @escaping () -> Void) {
        // Reindex all data with the provided index
        
        index()
        
        acknowledgementHandler()
    }
    
    override func searchableIndex(_ searchableIndex: CSSearchableIndex, reindexSearchableItemsWithIdentifiers identifiers: [String], acknowledgementHandler: @escaping () -> Void) {
        // Reindex any items with the given identifiers and the provided index
        
        index()
        
        acknowledgementHandler()
    }

    
    func index() {
        let defaults = UserDefaults(suiteName: "group.marcela.ada.files")
        if ((defaults?.array(forKey: "history")) != nil) {
            let data = defaults?.array(forKey: "history") as? [Data]
            docs = (data?.map { URL(dataRepresentation: $0, relativeTo: nil)! })!
            docs = docs.reversed()
        } else {
            docs = try! FileManager.default.contentsOfDirectory(at: (FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:"group.marcela.ada.files")!.appendingPathComponent("File Provider Storage")), includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        }
        
        var items = [CSSearchableItem]()
        
        for doc in docs {
            let searchItem = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            searchItem.title = doc.deletingPathExtension().lastPathComponent
            
            
            var isDir: ObjCBool = false
            
            if FileManager.default.fileExists(atPath: doc.path, isDirectory: &isDir) { // Check if file exists
                do {
                    if !isDir.boolValue { // Is file
                        if UIImage(data: try Data(contentsOf: doc)) != nil { // Is image
                            searchItem.thumbnailData = UIImagePNGRepresentation(#imageLiteral(resourceName: "image"))
                        } else if (try? AVAudioPlayer(contentsOf: doc)) != nil { // Is audio or video
                            searchItem.thumbnailData = UIImagePNGRepresentation(#imageLiteral(resourceName: "audioVideo"))
                        } else if doc.pathExtension.lowercased() == "pdf" { // Is pdf
                            searchItem.thumbnailData = UIImagePNGRepresentation(#imageLiteral(resourceName: "pdf"))
                        }else if doc.pathExtension.lowercased() == "html" { // Is HTML
                            searchItem.thumbnailData = UIImagePNGRepresentation(#imageLiteral(resourceName: "html"))
                        } else if doc.pathExtension.lowercased() == "zip" { // Is zip
                            searchItem.thumbnailData = UIImagePNGRepresentation(#imageLiteral(resourceName: "zipFile"))
                        } else if doc.pathExtension.lowercased() == "swift" {
                            searchItem.thumbnailData = UIImagePNGRepresentation(#imageLiteral(resourceName: "SwiftFile")) // Is Swift
                        } else if doc.pathExtension.lowercased() == "m" || doc.pathExtension.lowercased() == "mm" {
                            searchItem.thumbnailData = UIImagePNGRepresentation(#imageLiteral(resourceName: "OBJCFile")) // Is Objective-C
                        } else if doc.pathExtension.lowercased() == "py" {
                            searchItem.thumbnailData = UIImagePNGRepresentation(#imageLiteral(resourceName: "PYFile")) // Is Python
                        } else if  doc.pathExtension.lowercased() == "rtf" {
                            searchItem.thumbnailData = UIImagePNGRepresentation(#imageLiteral(resourceName: "rtfFile")) // Is RTF
                        } else if doc.pathExtension.lowercased() == "icloud" {
                            searchItem.thumbnailData = UIImagePNGRepresentation(#imageLiteral(resourceName: "iCloud")) // Is undownloaded file
                        } else {
                            do {
                                let _ = try String(contentsOf: doc, encoding: String.Encoding.utf8)
                                searchItem.thumbnailData = UIImagePNGRepresentation(#imageLiteral(resourceName: "file")) // Is file
                            } catch let error { // Is unkown file
                                print("ERROR: \(error.localizedDescription)")
                                searchItem.thumbnailData = UIImagePNGRepresentation(#imageLiteral(resourceName: "file"))
                            }
                        }
                    } else {
                        searchItem.thumbnailData = UIImagePNGRepresentation(#imageLiteral(resourceName: "Folder"))  // Is folder
                    }
                    
                } catch let error {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
            
            searchItem.contentDescription = "\(doc.pathExtension.uppercased()) file"
            searchItem.contentURL = doc
            
            let item = CSSearchableItem(uniqueIdentifier: "ch.marcela.ada.files.\\\(doc)", domainIdentifier: "ch.marcela.ada.files.file.spotlight", attributeSet: searchItem)
            
            items.append(item)
            
        }
        
        CSSearchableIndex.default().indexSearchableItems(items) { (Error) in
            print("search!")
        }
    }
    
}
