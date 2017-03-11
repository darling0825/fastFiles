//
//  prepareForSegue.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension BrowserTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Prepare for segue
        
        if segue.identifier == "files" || segue.identifier == "files2" { // open folder
            if let nextVC = segue.destination as? BrowserTableViewController {
                nextVC.dir = nextDir
            }
        }
        
        if segue.identifier == "audio" { // open audio
            if let nextVC = segue.destination as? MusicViewController {
                nextVC.url = imageURL!
            }
        }
        
        if segue.identifier == "image" { // open image
            if let nextVC = segue.destination as? ImageViewController {
                nextVC.url = imageURL!
            }
        }
        
        if segue.identifier == "PDF" { // open pdf
            if let nextVC = segue.destination as? PDFViewController {
                nextVC.url = imageURL!
            }
        }
        
        if segue.identifier == "text" { // open text
            if let nextVC = segue.destination as? TextViewController {
                nextVC.url = imageURL!
            }
        }
        
    }
}
