//
//  DocumentPickerDelegate.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension BrowserTableViewController: UIDocumentPickerDelegate, UIDocumentMenuDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        do {
            try FileManager.default.copyItem(at: url, to: URL(string: "file://"+(self.dir+"/"+url.lastPathComponent).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)!)
            self.reload()
        } catch let error {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
}
