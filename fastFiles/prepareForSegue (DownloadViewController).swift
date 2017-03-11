//
//  prepareForSegue (DownloadViewController).swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension DownloadViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Prepare for segue
        
        if segue.identifier == "Downloads" { // Go to downloaded file and..
            if let nextVC = segue.destination as? BrowserTableViewController {
                
                // select it
                let files = try! FileManager.default.contentsOfDirectory(atPath: App().delegate().docsPath)
                let nextFileIndex = files.index(of: finalDest!.lastPathComponent)
                nextVC.nextSelectedRow = [nextFileIndex!]
                nextVC.dir = App().delegate().docsPath
            }
        }
    }
}
