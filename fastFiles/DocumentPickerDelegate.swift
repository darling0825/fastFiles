//
//  DocumentPickerDelegate.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension BrowserTableViewController: UIDocumentPickerDelegate {
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        do {
            try FileManager.default.copyItem(at: url, to: URL(string: "file://"+(self.dir+url.lastPathComponent).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)!)
            self.reload()
        } catch let error {
            print("ERROR: \(error.localizedDescription)")
        }
    }
}
