//
//  prepareForSegue.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Prepare for segue
        
        if segue.identifier == "Docs" { // open documents folder
            if let nextVC = segue.destination as? BrowserTableViewController {
                nextVC.dir = App().delegate().docsPath
            }
        }
        
        if segue.identifier == "openBrowser" { // open browser
            if let nextVC = segue.destination as? BrowserTableViewController {
                nextVC.dir = UserDefaults.standard.string(forKey: "path")!
                if UserDefaults.standard.value(forKey: "fileIndex") != nil {
                    nextVC.nextSelectedRow = UserDefaults.standard.value(forKey: "fileIndex") as! [Int]
                }
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

        if segue.identifier == "showHelp" { // open Help
            if let nextVC = segue.destination as? HTMLViewController {
                let code = try! String(contentsOfFile: Bundle.main.path(forResource: "Instructions", ofType: "")!+"/index.html")
                nextVC.code = code
                nextVC.file = URL(fileURLWithPath: Bundle.main.path(forResource: "Instructions", ofType: "")!+"/index.html")
            }
        }
        
        if segue.identifier == "iCloud" { // Open iCloud Drive
            if let nextVC = segue.destination as? BrowserTableViewController {
                if App().iCloudDrive() != nil {
                    nextVC.dir = (App().iCloudDrive()?.path)!
                } else {
                    nextVC.dir = "/iCloud"
                }
            }
        }
        
        if segue.identifier == "highlightrLICENSE" { // Open Highlightr MIT License file
            if let nextVC = segue.destination as? TextViewController {
                nextVC.url = URL(fileURLWithPath: Bundle.main.path(forResource: "Highlightr", ofType: "")!).appendingPathComponent("index.txt")
            }
        }
        
    }
}
