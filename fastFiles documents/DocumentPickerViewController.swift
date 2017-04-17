//
//  DocumentPickerViewController.swift
//  fastFiles documents
//
//  Created by Adrian on 25.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

class DocumentPickerViewController: UIDocumentPickerExtensionViewController {
    
    var docsContent: [URL]?
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var Export: UIBarButtonItem!
    
    override func viewDidLoad() { // Documents
        let publicDocs = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.marcela.ada.files")!.appendingPathComponent("File Provider Storage")
        docsContent = try! FileManager.default.contentsOfDirectory(at: publicDocs, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        
        if self.documentPickerMode != .exportToService && self.documentPickerMode != .moveToService {
            Export.isEnabled = false
            Export.tintColor = .clear
        }
    }

    @IBAction func back(_ sender: Any) { // Back
        
        do {
            docsContent = try FileManager.default.contentsOfDirectory(at: (docsContent?[0].deletingLastPathComponent().deletingLastPathComponent())!, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            TableView.reloadData()
        } catch let error {
            let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func export(_ sender: Any) {
    }
}
