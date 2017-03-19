//
//  MessagesViewController.swift
//  Send file
//
//  Created by Adrian on 18.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    var docsContent: [URL]? = [URL(string:"file:///")!]
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let publicDocs = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.marcela.ada.files")!.appendingPathComponent("File Provider Storage")
        docsContent = try! FileManager.default.contentsOfDirectory(at: publicDocs, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        
        print(docsContent!)
        
    }
    
    @IBAction func Back(_ sender: Any) {
        do {
            docsContent = try FileManager.default.contentsOfDirectory(at: (docsContent?[0].deletingLastPathComponent().deletingLastPathComponent())!, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            TableView.reloadData()
        } catch let error {
            let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        view.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        view.viewWithTag(5)?.isHidden = false
    }

}
