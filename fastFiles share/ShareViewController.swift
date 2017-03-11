//
//  ShareViewController.swift
//  fastFiles share
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import MobileCoreServices

class ShareViewController: UIViewController {
    
    func stop() { // End
        print("DISMISS!!!!")
        self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) { // View did appear
        super.viewDidAppear(false)
        
        let content = extensionContext!.inputItems[0] as! NSExtensionItem // Items
        let file = kUTTypeFileURL as String // File type
        let docs = (FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:"group.marcela.ada.files")!.appendingPathComponent("File Provider Storage")) // Documents folder
        
        for attachment in content.attachments as! [NSItemProvider] { // Process item
            if attachment.hasItemConformingToTypeIdentifier(file) { // If attachment is file URL
                attachment.loadItem(forTypeIdentifier: file, options: nil, completionHandler: { (data, error) in // Load item
                    if error == nil {
                        let url = data as! URL!
                        let newURL = docs.appendingPathComponent((url?.lastPathComponent)!)
                        do {
                            try FileManager.default.copyItem(at: url!, to: newURL) // Copy item
                            
                            let url = NSURL(string: (docs.appendingPathComponent((url?.lastPathComponent)!).absoluteString.replacingOccurrences(of: "file://", with: "files://")))
                            self.openURL(url: url!)
                            self.stop()
                            
                        } catch let error {
                            let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert) // Error
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                self.stop()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                            self.stop()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            } else {
                let alert = UIAlertController(title: "Error!", message: "Unkown file type!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    DispatchQueue.global(qos: .background).async {
                        self.stop()
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
